import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoInfoModel {
  final String title;
  final String author;
  final String? thumbnail;
  final String videoId;
  final List<AudioStreamInfo> audioResolutions;
  final List<VideoStreamInfo> videoResolutions;
  final Duration? duration;

  const VideoInfoModel({
    required this.title,
    required this.author,
    required this.thumbnail,
    required this.videoId,
    required this.duration,
    required this.audioResolutions,
    required this.videoResolutions,
  });

  String getThumbnail() {
    return thumbnail ?? "";
  }
}
