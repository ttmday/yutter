import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/controller/notifier/video_info.dart';

import 'package:yutter/src/widgets/state/empty.dart';
import 'package:yutter/src/widgets/state/loading.dart';
import 'package:yutter/src/widgets/state/permission.dart';
import 'package:yutter/src/widgets/stream.dart';

class SearchContent extends StatelessWidget {
  const SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Consumer<YutterController>(
        builder: (context, controller, _) {
          return ValueListenableBuilder(
            valueListenable: controller.videoInfoStateNotifier,
            builder: (context, state, _) {
              return switch (state) {
                VideoInfoStatePermission _ => PermissionState(
                  controller: controller,
                ),
                VideoInfoStateLoading _ => const LoadingState(),
                // APIResponseStateError _ => SomethingWrongState(
                //   retry: provider.retry,
                // ),
                VideoInfoStateSuccess info => Stream(info.data),
                _ => const EmptyState(),
              };
            },
          );
        },
      ),
    );
  }
}
