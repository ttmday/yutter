import 'package:flutter/material.dart';
import 'package:yutter/src/models/video_info.dart';

abstract class VideoInfoState {}

class VideoInfoStateEmpty extends VideoInfoState {}

class VideoInfoStateLoading extends VideoInfoState {}

class VideoInfoStatePermission extends VideoInfoState {}

class VideoInfoStateSuccess extends VideoInfoState {
  final VideoInfoModel data;

  VideoInfoStateSuccess(this.data);
}

class VideoInfoStateError extends VideoInfoState {
  final String message;
  final dynamic error;

  VideoInfoStateError(this.message, {this.error});
}

class VideoInfoStateNotifier extends ValueNotifier<VideoInfoState> {
  VideoInfoStateNotifier() : super(VideoInfoStateEmpty());
}
