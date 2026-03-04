import 'package:flutter/material.dart';

abstract class DownloadVideoState {}

class DownloadVideoStateEmpty extends DownloadVideoState {}

class DownloadVideoStateLoading extends DownloadVideoState {
  final String message = "Iniciando descarga...";
}

class DownloadVideoStateProgress extends DownloadVideoState {
  final int progress;

  DownloadVideoStateProgress(this.progress);
}

class DownloadVideoAudioStateProcess extends DownloadVideoState {
  final String message = "Procesando audio...";
}

class DownloadVideoStateConversion extends DownloadVideoState {
  final String message = "Convirtiendo...";
}

class DownloadVideoStateSuccess extends DownloadVideoState {
  final String outputpath;

  DownloadVideoStateSuccess(this.outputpath);
}

class DownloadVideoStateError extends DownloadVideoState {
  final String message;
  final dynamic error;

  DownloadVideoStateError(this.message, {this.error});
}

class DownloadVideoStateNotifier extends ValueNotifier<DownloadVideoState> {
  DownloadVideoStateNotifier() : super(DownloadVideoStateEmpty());
}
