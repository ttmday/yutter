import 'package:flutter/material.dart';

abstract class DownloadAudioState {}

class DownloadAudioStateEmpty extends DownloadAudioState {}

class DownloadAudioStateLoading extends DownloadAudioState {
  final String message = "Iniciando descarga...";
}

class DownloadAudioStateProgress extends DownloadAudioState {
  final int progress;

  DownloadAudioStateProgress(this.progress);
}

class DownloadAudioStateConversion extends DownloadAudioState {
  final String message = "Convirtiendo...";
}

class DownloadAudioStateSuccess extends DownloadAudioState {
  final String outputpath;

  DownloadAudioStateSuccess(this.outputpath);
}

class DownloadAudioStateError extends DownloadAudioState {
  final String message;
  final dynamic error;

  DownloadAudioStateError(this.message, {this.error});
}

class DownloadAudioStateNotifier extends ValueNotifier<DownloadAudioState> {
  DownloadAudioStateNotifier() : super(DownloadAudioStateEmpty());
}
