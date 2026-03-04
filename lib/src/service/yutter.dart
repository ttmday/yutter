import 'package:dartz/dartz.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:yutter/src/models/result.dart';
import 'package:yutter/src/utils/logger.dart';

class YutterService {
  final _log = LoggingUtils.getLogger("YutterService");

  late Video _video;
  late String _videoId;
  late StreamManifest _manifest;

  Future<Either<EResult, YResult>> initialize(
    String url, {
    required YoutubeExplode yt,
  }) async {
    _videoId = getVideoIDFromUrl(url);

    if (_videoId.isEmpty) {
      _log.severe(
        "\n❌ Error: La URL proporcionada no es un enlace válido de YouTube.",
      );
      return Left(
        EResult(
          message: "La URL proporcionada no es un enlace válido de YouTube.",
          error: "[INVALID videoID]",
        ),
      );
    }

    try {
      _log.info("\n🔍 Obteniendo información de video [ID: $_videoId]...");
      _video = await yt.videos.get(_videoId);
      _manifest = await yt.videos.streamsClient.getManifest(
        _videoId,
        ytClients: [YoutubeApiClient.androidVr],
      );
    } catch (e) {
      return Left(
        EResult(message: "Al parecer, algo ha salido muy mal", error: e),
      );
    }

    return Right(
      YResult(
        "Ok",
        data: {
          "video": _video,
          "manifest": _manifest,
          "thumbnail": getThumbUrl(),
        },
      ),
    );
  }

  AudioStreamInfo getAudioHighestBitrate() {
    return _manifest.audio.withHighestBitrate();
  }

  bool validateDomain(String rawUrl) {
    rawUrl = Uri.decodeFull(rawUrl).trim();
    final uri = Uri.parse(rawUrl);
    const validDomains = [
      'youtube.com',
      'www.youtube.com',
      'm.youtube.com',
      'youtu.be',
      'music.youtube.com',
    ];
    if (!validDomains.contains(uri.host)) {
      return false;
    }

    return true;
  }

  String getVideoIDFromUrl(String rawUrl) {
    try {
      rawUrl = Uri.decodeFull(rawUrl).trim();
      final uri = Uri.parse(rawUrl);

      if (!validateDomain(rawUrl)) {
        return "";
      }

      // 2. Extraer ID según el formato
      // Formato: youtu.be/VIDEO_ID
      if (uri.host == 'youtu.be') {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : "";
      }

      // Formato: youtube.com/watch?v=VIDEO_ID o music.youtube.com/watch?v=...
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v']!;
      }

      // Formato: youtube.com/embed/VIDEO_ID o youtube.com/v/VIDEO_ID
      if (uri.pathSegments.contains('embed') ||
          uri.pathSegments.contains('v')) {
        return uri.pathSegments.last;
      }
    } catch (_) {
      return "";
    }
    return "";
  }

  StreamManifest getManifest() {
    return _manifest;
  }

  String getVideoId() {
    return _videoId;
  }

  String getAuthor() {
    return _video.author;
  }

  Duration? getVideoDuration() {
    return _video.duration;
  }

  String getVideoTitle() {
    return _video.title;
  }

  String getThumbUrl() {
    var thumbUrl = _video.thumbnails.maxResUrl;

    if (thumbUrl.isEmpty) {
      thumbUrl = _video.thumbnails.standardResUrl;
    }
    if (thumbUrl.isEmpty) {
      thumbUrl = _video.thumbnails.mediumResUrl;
    }

    return thumbUrl;
  }

  String getFilename() {
    return _video.title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '');
  }

  List<AudioStreamInfo> getAudioResolutions() {
    var audioStreams = _manifest.audio
        .sortByBitrate()
        .where((info) => info.container.name == "mp4")
        .toList();

    Map<String, String> resolutions = {};
    List<AudioStreamInfo> streams = [];
    for (var i = 0; i < audioStreams.length; i++) {
      var s = audioStreams[i];
      if (!resolutions.containsKey(s.qualityLabel)) {
        streams.add(s);
        resolutions.putIfAbsent(
          s.qualityLabel,
          () =>
              "${s.qualityLabel} | ${s.container.name} | ${(s.size.totalMegaBytes).toStringAsFixed(2)} MB",
        );
      }
    }

    return streams;
  }

  List<VideoStreamInfo> getVideoResolutions() {
    var videoStreams = _manifest.video
        .sortByVideoQuality()
        .where((info) => info.container.name == "mp4")
        .toList();

    Map<String, String> resolutions = {};
    List<VideoStreamInfo> streams = [];
    for (var i = 0; i < videoStreams.length; i++) {
      var s = videoStreams[i];
      if (s.container.name == "mp4" &&
          !resolutions.containsKey(s.qualityLabel)) {
        streams.add(s);
        resolutions.putIfAbsent(
          s.qualityLabel,
          () =>
              "${s.qualityLabel} | ${s.container.name} | ${(s.size.totalMegaBytes).toStringAsFixed(2)} MB",
        );
      }
    }

    _log.info("\n📺 Resoluciones disponibles:");
    var entries = resolutions.entries.toList();
    for (var i = 0; i < entries.length - 1; i++) {
      _log.info("[$i] ${entries[i].value}");
    }

    return streams;
  }
}
