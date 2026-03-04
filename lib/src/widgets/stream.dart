import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/controller/notifier/download.dart';
import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/models/video_info.dart';
import 'package:yutter/src/widgets/state/downloaded.dart';
import 'package:yutter/src/widgets/stream_info.dart';
import 'package:yutter/src/widgets/stream_resolutions.dart';

class Stream extends StatelessWidget {
  const Stream(this.info, {super.key});

  final VideoInfoModel info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Consumer<YutterController>(
        builder: (context, controller, _) {
          return Stack(
            clipBehavior: .hardEdge,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  StreamInfo(info),
                  const SizedBox(height: AppDesign.padding * 3),
                  Expanded(
                    child: StreamResolutions(
                      audioResolutions: info.audioResolutions,
                      videoResolutions: info.videoResolutions,
                    ),
                  ),
                ],
              ),

              ValueListenableBuilder(
                valueListenable: controller.downloadNotifier,
                builder: (context, state, _) {
                  var location = "";
                  var bottom = -1000.0;
                  if (state is DownloadStateSuccess) {
                    // location = state.location;
                    bottom = 3.0;
                  }
                  return AnimatedPositioned(
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 600),
                    left: 0.0,
                    right: 0.0,
                    bottom: bottom,
                    child: DownloadedState(
                      info: info,
                      location: location,
                      controller: controller,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
