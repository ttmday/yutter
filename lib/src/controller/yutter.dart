// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yutter/src/controller/notifier/download.dart';
// import 'package:device_info_plus/device_info_plus.dart';

import 'package:yutter/src/controller/notifier/video_info.dart';
import 'package:yutter/src/models/video_info.dart';
import 'package:yutter/src/service/downloader.dart';
import 'package:yutter/src/service/yutter.dart';
import 'package:yutter/src/utils/dir.dart';
import 'package:yutter/src/utils/toast.dart';

class YutterController {
  late final TextEditingController videoUrlController;
  late final YutterService _yutterService;
  late final DownloadService _downloadService;

  final VideoInfoStateNotifier videoInfoStateNotifier =
      VideoInfoStateNotifier();

  final DownloadStateNotifier downloadNotifier = DownloadStateNotifier();

  bool havePermission = false;

  YutterController({
    required YutterService yutterService,
    required DownloadService downloaderService,
  }) {
    _yutterService = yutterService;
    _downloadService = downloaderService;
    videoUrlController = TextEditingController();

    requesPermission().then((isGranted) {
      havePermission = isGranted;
      if (!havePermission) {
        videoInfoStateNotifier.value = VideoInfoStatePermission();
        notGrantedPermissionToast().then((_) {});
      }
    });
  }

  Future<void> tryRequestPermission() async {
    var result = await requesPermission();

    havePermission = result;
    if (!havePermission) {
      videoInfoStateNotifier.value = VideoInfoStatePermission();
      notGrantedPermissionToast().then((_) {});
    }
  }

  Future<bool> requesPermission() async {
    if (!(await Permission.manageExternalStorage.isGranted)) {
      final status = await Permission.manageExternalStorage.request();
      if (status.isDenied) {
        videoInfoStateNotifier.value = VideoInfoStateEmpty();
        return false;
      }
    }

    // if (Platform.isAndroid) {
    //   final deviceInfo = DeviceInfoPlugin();
    //   final androidInfo = await deviceInfo.androidInfo;

    //   if (androidInfo.version.sdkInt >= 33) {
    //     final photos = await Permission.photos.request();
    //     final videos = await Permission.videos.request();
    //     final audio = await Permission.audio.request();

    //     return photos.isGranted && videos.isGranted && audio.isGranted;
    //   } else {
    //     final status = await Permission.storage.request();
    //     return status.isGranted;
    //   }
    // }

    return true;
  }

  Future<bool> checkInternetConnection() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }

  void clear() {
    videoInfoStateNotifier.value = VideoInfoStateEmpty();
    downloadNotifier.value = DownloadStateEmpty();
  }

  bool validateURL(String videoUrl) {
    return _yutterService.validateDomain(videoUrl);
  }

  Future<void> retry() async {
    await getVideoInfo(videoUrlController.text);
  }

  Future<void> getVideoInfo(String url) async {
    YoutubeExplode yt = YoutubeExplode();
    videoInfoStateNotifier.value = VideoInfoStateLoading();
    final resutl = await _yutterService.initialize(url, yt: yt);

    resutl.fold(
      (e) {
        videoInfoStateNotifier.value = VideoInfoStateError(
          e.message,
          error: e.error,
        );
      },
      (_) {
        videoInfoStateNotifier.value = VideoInfoStateSuccess(
          VideoInfoModel(
            title: _yutterService.getVideoTitle(),
            author: _yutterService.getAuthor(),
            thumbnail: _yutterService.getThumbUrl(),
            videoId: _yutterService.getVideoId(),
            duration: _yutterService.getVideoDuration(),
            audioResolutions: _yutterService.getAudioResolutions(),
            videoResolutions: _yutterService.getVideoResolutions(),
          ),
        );
      },
    );

    yt.close();
  }

  Future<void> download(dynamic streamInfo, String type) async {
    if (!havePermission) {
      havePermission = await requesPermission();

      if (!havePermission) {
        videoInfoStateNotifier.value = VideoInfoStatePermission();
        await notGrantedPermissionToast();
        return;
      }
    }
    VideoInfoModel info =
        (videoInfoStateNotifier.value as VideoInfoStateSuccess).data;
    if (type == "video") {
      return await downloadVideo(streamInfo, info);
    }

    return await downloadAudio(streamInfo, info);
  }

  Future<void> downloadAudio(
    AudioStreamInfo streamInfo,
    VideoInfoModel info,
  ) async {
    YoutubeExplode yt = YoutubeExplode();
    downloadNotifier.value = DownloadStateLoading();
    var result = await _downloadService.downloadAudio(
      yt,
      videoInfo: info,
      audioStreamInfo: streamInfo,
      callbackProgress: (progress) {
        downloadNotifier.value = DownloadStateProgress(progress);
      },
      callbackStatus: (status) {
        if (downloadNotifier.value is DownloadStateVideoAudioProcessing) {
          return;
        }

        if (status == "[CONVERSION]") {
          downloadNotifier.value = DownloadStateConversion();
        }
      },
    );

    downloadNotifier.value = DownloadStateEmpty();
    result.fold(
      (e) async {
        downloadNotifier.value = DownloadStateError(e.message, error: e.error);
        await toast(e.message);
      },
      (data) async {
        downloadNotifier.value = DownloadStateSuccess(
          info: info,
          location: await DirUtils.getAppAudioPath(),
          outputpath: data.data["outputPath"],
        );
      },
    );

    yt.close();
  }

  Future<void> downloadVideo(
    VideoStreamInfo streamInfo,
    VideoInfoModel info,
  ) async {
    YoutubeExplode yt = YoutubeExplode();
    downloadNotifier.value = DownloadStateLoading();
    var result = await _downloadService.downloadVideo(
      yt,
      videoInfo: info,
      videoStreamInfo: streamInfo,
      audioStreamInfo: _yutterService.getAudioHighestBitrate(),
      callbackProgress: (progress) {
        downloadNotifier.value = DownloadStateProgress(progress);
      },
      callbackStatus: (status) {
        if (status == "[AUDIO_PROCESSING]") {
          downloadNotifier.value = DownloadStateVideoAudioProcessing();
        }

        if (status == "[CONVERSION]") {
          downloadNotifier.value = DownloadStateConversion();
        }
      },
    );

    downloadNotifier.value = DownloadStateEmpty();
    result.fold(
      (e) async {
        downloadNotifier.value = DownloadStateError(e.message, error: e.error);
        await toast(e.message);
      },
      (data) async {
        downloadNotifier.value = DownloadStateSuccess(
          info: info,
          location: await DirUtils.getAppVideoPath(),
          outputpath: data.data["outputPath"],
        );
      },
    );

    yt.close();
  }

  Future<void> openLocation(String path) async {
    try {
      final uri = Uri.parse("file:$path");
      print("path $path");
      print("uri $uri");
      final ok = await canLaunchUrl(uri);
      if (!ok) {
        print("No se pudo abrir la ubicación");
        toast("No se pudo abrir la ubicación.");
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("Error al intentar abrir la ubicación: $e");
      toast("No se pudo abrir la ubicación");
    }
  }

  void dispose() {
    videoUrlController.dispose();
  }
}
