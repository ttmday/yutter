import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

import 'package:yutter/src/utils/logger.dart';

class FFmpegService {
  final _log = LoggingUtils.getLogger("FFmpegService");

  Future<bool> converter(
    String title, {
    required String author,
    required String path,
    required String thumb,
    required String outputPath,
  }) async {
    var outPath = outputPath.replaceAll(RegExp(r'\.(webm|mp4|m4a)$'), '.mp3');

    bool thumbExists = false;
    try {
      _log.info("Obteniendo información de caratula...");
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(thumb));
      final response = await request.close();
      thumbExists = response.statusCode == 200;
    } catch (_) {
      thumbExists = false;
    }

    List<String> arguments = [
      '-i', path, // Entrada 0
      '-i', thumb, // Entrada 1
      '-map', '0:a', // Usar audio del primer archivo
      '-map', '1:0', // Usar imagen del segundo archivo
      '-c:a', 'libmp3lame', // Convertir audio a mp3
      '-ab', '320k', // Bitrate
      '-ar', '44100', // Frecuencia
      '-c:v', 'mjpeg', // Forzar formato de imagen para la carátula
      '-id3v2_version', '3', // Metadatos ID3v2.3 (estándar)
      '-metadata', 'title=$title',
      '-metadata', 'artist=$author',
      '-disposition:v',
      'attached_pic', // Define la imagen como carátula adjunta
      '-y', // Sobrescribir
      outPath, // ARCHIVO DE SALIDA (siempre al final)
    ];

    if (!thumbExists) {
      _log.warning(
        "⚠️ No se pudo obtener la información de carátula, generando MP3 sin imagen...",
      );
      arguments = [
        '-i',
        path,
        '-vn',
        '-c:a',
        'libmp3lame',
        '-ab',
        '320k',
        '-metadata',
        'title=$title',
        '-metadata',
        'artist=$author',
        '-y',
        outPath,
      ];
    }

    _log.info("🔄 Convirtiendo a MP3...");
    _log.info("[Arguments] $arguments");

    try {
      final result = await FFmpegKit.executeWithArguments(arguments);
      final returnCode = await result.getReturnCode();

      if (returnCode == null) {
        _log.severe("⚠️ Error FFmpeg: ${returnCode.toString()}");
        return false;
      }

      if (returnCode.isValueSuccess()) {
        _log.info("🎵 Conversión finalizada: $outPath");
        if (await File(path).exists()) await File(path).delete();
        return true;
      }
      _log.severe("⚠️ Error FFmpeg: ${returnCode.toString()}");
      return false;
    } catch (e) {
      _log.severe("🚫 Error: FFmpeg no encontrado en el sistema.");
      if (await File(path).exists()) await File(path).delete();
      return false;
    }
  }

  Future<bool> converterVideo(
    String title, {
    required String author,
    required String videoPath,
    required String audioPath,
    required String outputPath,
  }) async {
    var outPath = outputPath.replaceAll(RegExp(r'\.(webm|mp4|m4a)$'), '.mp4');

    final arguments = [
      '-i',
      videoPath,
      '-i',
      audioPath,
      '-c:v',
      'copy',
      '-c:a',
      'aac',
      '-map',
      '0:v:0',
      '-map',
      '1:a:0',
      '-metadata',
      'title=$title',
      '-metadata',
      'artist=$author',
      '-shortest',
      '-y',
      outPath,
    ];

    _log.info("🔄 Convirtiendo...");
    _log.info("[Arguments] $arguments");

    try {
      final result = await FFmpegKit.executeWithArguments(arguments);
      final returnCode = await result.getReturnCode();
      _log.info("[Corversion] $result");

      if (returnCode == null) {
        _log.severe("⚠️ Error FFmpeg: ${returnCode.toString()}");
        return false;
      }

      if (returnCode.isValueSuccess()) {
        if (await File(videoPath).exists()) await File(videoPath).delete();

        if (await File(audioPath).exists()) await File(audioPath).delete();

        _log.info("📺 Conversión finalizada: $outPath");
        return true;
      }
      _log.severe("⚠️ Error en FFmpeg: ${returnCode.toString()}");
      return false;
    } catch (e) {
      if (await File(videoPath).exists()) await File(videoPath).delete();

      if (await File(audioPath).exists()) await File(audioPath).delete();
      _log.severe("🚫 Error: FFmpeg no encontrado en el sistema.");
      return false;
    }
  }
}
