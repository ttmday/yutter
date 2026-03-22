import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yutter/src/constants/color.dart';

import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/controller/notifier/download.dart';
import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/widgets/button.dart';
import 'package:yutter/src/widgets/with_download.dart';

class StreamResolutions extends StatefulWidget {
  const StreamResolutions({
    super.key,
    required this.audioResolutions,
    required this.videoResolutions,
  });

  final List<AudioStreamInfo> audioResolutions;
  final List<VideoStreamInfo> videoResolutions;

  @override
  State<StreamResolutions> createState() => _StreamResolutionsState();
}

class _StreamResolutionsState extends State<StreamResolutions> {
  dynamic streamInfo;
  String selected = "";

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = 380.0;
    return Consumer<YutterController>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Audio List
                    Text(
                      "Audio",
                      style: TextStyle(
                        color: AppColors.field.withValues(alpha: .8),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: AppDesign.padding),
                    ...List.generate(widget.audioResolutions.length, (index) {
                      final r = widget.audioResolutions[index];

                      if (r.qualityLabel.isEmpty) {
                        return SizedBox.shrink();
                      }

                      final tag = "audio_${r.qualityLabel}";
                      return Padding(
                        padding: index == widget.audioResolutions.length - 1
                            ? .zero
                            : .only(bottom: AppDesign.padding),
                        child: CustomInkWell(
                          controller: provider,
                          tag: tag,
                          onTap: () {
                            setState(() {
                              streamInfo = r;
                              selected = tag;
                            });
                          },
                          isSelected: selected == "audio_${r.qualityLabel}",
                          streamInfo: r,
                        ),
                      );
                    }),
                    const SizedBox(height: AppDesign.padding * 3),
                    // Video List
                    Text(
                      "Video",
                      style: TextStyle(
                        color: AppColors.field.withValues(alpha: .8),
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: AppDesign.padding),
                    ...List.generate(widget.videoResolutions.length, (index) {
                      final r = widget.videoResolutions[index];
                      if (r.qualityLabel.isEmpty) {
                        return SizedBox.shrink();
                      }

                      final tag = "video_${r.qualityLabel}";
                      return Padding(
                        padding: index == widget.videoResolutions.length - 1
                            ? .zero
                            : .only(bottom: AppDesign.padding),
                        child: CustomInkWell(
                          controller: provider,

                          onTap: () {
                            setState(() {
                              streamInfo = r;
                              selected = tag;
                            });
                          },
                          isSelected: selected == tag,
                          tag: tag,
                          streamInfo: r,
                        ),
                      );
                    }),
                    const SizedBox(height: AppDesign.padding * 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDesign.padding * 2),
            ValueListenableBuilder(
              valueListenable: provider.downloadNotifier,
              builder: (context, state, _) => Button(
                onPressed: () => _download(provider),
                width: w > maxWidth ? maxWidth : w,
                disabled: state is! DownloadStateEmpty || selected.isEmpty,
                color: state is! DownloadStateEmpty ? AppColors.primary : null,
                text: (state as dynamic).message,
              ),
            ),
          ],
        );
      },
    );
  }

  void _download(YutterController controller) {
    if (streamInfo == null) {
      return;
    }
    var type = selected.startsWith("audio") ? "audio" : "video";
    controller.download(streamInfo, type);
  }
}

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.tag,
    required this.streamInfo,
    required this.controller,
  });

  final Function() onTap;
  final YutterController controller;
  final bool isSelected;
  final String tag;
  final dynamic streamInfo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.downloadNotifier,
      builder: (context, state, child) {
        var progress = 0;
        var download = state is DownloadStateProgress && isSelected;
        if (state is DownloadStateProgress) {
          progress = state.progress;
        }
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: .all(.circular(AppDesign.radius)),
          ),
          child: WithDownload(
            download: download,
            received: progress,
            total: 100,
            height: 40,
            child: InkWell(
              onTap: state is! DownloadStateEmpty ? null : onTap,

              borderRadius: .all(.circular(AppDesign.radius)),
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: .symmetric(horizontal: AppDesign.padding),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              Radio(value: isSelected),
              const SizedBox(width: AppDesign.padding * 2),
              Text(streamInfo.qualityLabel),
              const Spacer(),
              Text(
                "${(streamInfo.size.totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Radio extends StatelessWidget {
  const Radio({super.key, this.value = false});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.background),
        shape: .circle,
      ),
      child: SizedBox(
        width: 12,
        height: 12,
        child: value
            ? Center(
                child: SizedBox(
                  width: 6,
                  height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(color: AppColors.background),
                      shape: .circle,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
