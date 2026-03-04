import 'package:flutter/material.dart';
import 'package:yutter/src/models/video_info.dart';

abstract class DownloadState {}

class DownloadStateEmpty extends DownloadState {
  final String message = "Descargar";
}

class DownloadStateLoading extends DownloadState {
  final String message = "Descargando...";
}

class DownloadStateProgress extends DownloadState {
  final String message = "Descargando...";
  final int progress;

  DownloadStateProgress(this.progress);
}

class DownloadStateConversion extends DownloadState {
  final String message = "Convirtiendo...";
}

class DownloadStateVideoAudioProcessing extends DownloadState {
  final String message = "Procesando audio...";
}

class DownloadStateSuccess extends DownloadState {
  final VideoInfoModel info;
  final String message = "Descarga exitosa";
  final String location;
  final String outputpath;

  DownloadStateSuccess({
    required this.info,
    required this.location,
    required this.outputpath,
  });
}

class DownloadStateError extends DownloadState {
  final String message = "Descarga fallida";
  final String errorMessage;
  final dynamic error;

  DownloadStateError(this.errorMessage, {this.error});
}

class DownloadStateNotifier extends ValueNotifier<DownloadState> {
  DownloadStateNotifier() : super(DownloadStateEmpty());
}
