import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:yutter/src/models/result.dart';
import 'package:yutter/src/models/video_info.dart';

import 'package:yutter/src/service/ffmpeg.dart';
import 'package:yutter/src/utils/dir.dart';
import 'package:yutter/src/utils/logger.dart';
import 'package:yutter/src/utils/utils.dart';

enum DownloaderStatus {
  init,
  verifying,
  downloading,
  error,
  conversion,
  conversionError,
  audioProcessing,
  done;

  String getStatusString() {
    return "[${name.toUpperCase()}]";
  }
}

class DownloadService {
  final _log = LoggingUtils.getLogger("DownloadService");

  late final FFmpegService _ffmpegService;

  DownloadService({required FFmpegService service}) {
    _ffmpegService = service;
  }

  Future<Either<EResult, YResult>> downloadAudio(
    YoutubeExplode yt, {
    required VideoInfoModel videoInfo,
    required StreamInfo audioStreamInfo,
    required void Function(int) callbackProgress,
    required void Function(String) callbackStatus,
  }) async {
    try {
      var totalSize = audioStreamInfo.size.totalBytes;

      _log.info("\n🔍 Verificando...");
      callbackStatus("[VERIFYING]");
      var title = sanitizeString(videoInfo.title);

      _log.info("\n🔍 Procesando audio [ID: ${videoInfo.videoId}]...");

      _log.info("\n📽️  Título: $title");
      _log.info("🎵 Resolución: ${audioStreamInfo.qualityLabel}");
      _log.info(
        "📦 Tamaño: ${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
      );

      var tempPath = (await getTemporaryDirectory()).path;
      var audioFileName = "$tempPath/$title";
      _log.info("\n🎵 Iniciando descarga de audio...");
      callbackStatus("[INIT]");

      callbackStatus("[DOWNLOADING]");
      var (ok, file) = await downloadStream(
        yt,
        audioStreamInfo,
        audioFileName,
        callbackProgress: callbackProgress,
      );

      if (!ok) {
        callbackStatus("[ERROR]");
        _log.severe("\n❌ Descarga no procesada");
        return Left(EResult(message: "Descarga no procesada"));
      }

      _log.info("\n✅ Descarga finalizada.");

      final outputPath = "${await DirUtils.getAppAudioPath()}/$title.mp3";
      callbackStatus("[CONVERSION]");
      var convertion = await _ffmpegService.converter(
        title,
        author: videoInfo.author,
        path: file.path,
        thumb: videoInfo.getThumbnail(),
        outputPath: outputPath,
      );

      if (!convertion) {
        callbackStatus("[CONVERSION_ERROR]");
        _log.severe("\n❌ Conversión no procesada");
        return Left(EResult(message: "Conversión no procesada"));
      }

      MediaScanner.loadMedia(path: outputPath);

      callbackStatus("[DONE]");

      return Right(
        YResult("Descarga finalizada.", data: {"outputPath": outputPath}),
      );
    } catch (e) {
      callbackStatus("[ERROR]");
      _log.severe("\n❌ Descarga finalizada con error: $e");
      return Left(EResult(message: "Descarga finalizada con error", error: e));
    }
  }

  Future<Either<EResult, YResult>> downloadVideo(
    YoutubeExplode yt, {
    required VideoInfoModel videoInfo,
    required StreamInfo videoStreamInfo,
    required StreamInfo audioStreamInfo,
    required void Function(int) callbackProgress,
    required void Function(String) callbackStatus,
  }) async {
    _log.info("\n🔍 Verificando...");
    callbackStatus("[VERIFYING]");
    var title = sanitizeString(videoInfo.title);

    _log.info("\n🔍 Procesando video [ID: ${videoInfo.videoId}]...");

    var tempPath = (await getTemporaryDirectory()).path;
    var videoFileName = "$tempPath/${title}_${videoStreamInfo.qualityLabel}";
    var totalSize = videoStreamInfo.size.totalBytes;

    _log.info("\n📽️  Título: $title");
    _log.info("📺 Resolución: ${videoStreamInfo.qualityLabel}");
    _log.info(
      "📦 Tamaño: ${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
    );

    try {
      _log.info("\n📺 Iniciando descarga de video...");
      callbackStatus("[INIT]");

      callbackStatus("[DOWNLOADING]");
      var (okVideo, fileVideo) = await downloadStream(
        yt,
        videoStreamInfo,
        videoFileName,
        callbackProgress: callbackProgress,
      );

      if (!okVideo) {
        callbackStatus("[ERROR]");
        _log.severe("\n❌ Descarga no procesada");
        return Left(EResult(message: "Descarga no procesada"));
      }

      _log.info("\n📺 Procesando descarga de audio...");

      callbackStatus("[AUDIO_PROCESSING]");

      var audioFileName = "$tempPath/${title}_${DateTime.now().toString()}";
      var (okAudio, fileAudio) = await downloadStream(
        yt,
        audioStreamInfo,
        audioFileName,
        callbackProgress: (_) {}, //No se emite el progreso del audio.
      );

      _log.info("\n✅ Descarga finalizada.");
      final outputPath = "${await DirUtils.getAppVideoPath()}/$title.mp4";
      callbackStatus("[CONVERSION]");
      var convertion = await _ffmpegService.converterVideo(
        title,
        author: videoInfo.author,
        videoPath: fileVideo.path,
        audioPath: fileAudio.path,
        outputPath: outputPath,
      );

      if (!convertion) {
        callbackStatus("[CONVERSION_ERROR]");
        _log.severe("\n❌ Conversión no procesada");
        return Left(EResult(message: "Conversión no procesada"));
      }

      MediaScanner.loadMedia(path: outputPath);

      callbackStatus("[DONE]");
      return Right(
        YResult("Descarga finalizada.", data: {"outputPath": outputPath}),
      );
    } catch (e) {
      callbackStatus("[ERROR]");
      _log.severe("\n❌ Descarga finalizada con error: $e");
      return Left(EResult(message: "Descarga finalizada con error", error: e));
    }
  }

  Future<(bool, File)> downloadStream(
    YoutubeExplode yt,
    StreamInfo streamInfo,
    String fileName, {
    required void Function(int) callbackProgress,
  }) async {
    final file = File("$fileName.webm");
    final outputStream = file.openWrite();

    try {
      var downloaded = 0;
      var stream = yt.videos.streamsClient.get(streamInfo);
      var totalSize = streamInfo.size.totalBytes;

      await for (var data in stream) {
        downloaded += data.length;
        var progress = ((downloaded / totalSize) * 100).toInt();
        callbackProgress(progress);
        outputStream.add(data);
      }

      await outputStream.flush();
      await outputStream.close();

      if (downloaded == 0) {
        _log.warning("downloaded = 0");
        return (false, file);
      }

      return (true, file);
    } catch (e) {
      _log.severe("[downloadStream Exception] $e");
      await outputStream.close();
      return (false, file);
    }
  }
}
