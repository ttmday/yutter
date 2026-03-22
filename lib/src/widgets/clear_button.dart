import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/controller/notifier/video_info.dart';

import 'package:yutter/src/widgets/button.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<YutterController>(
      builder: (context, provider, _) {
        return ValueListenableBuilder(
          valueListenable: provider.videoInfoStateNotifier,
          builder: (context, state, _) {
            return switch (state) {
              VideoInfoStateSuccess _ => Button(
                width: 52.0,
                height: 36.0,
                onPressed: () {
                  provider.clear();
                },
                text: "Clear",
              ),
              _ => const SizedBox.shrink(),
            };
          },
        );
      },
    );
  }
}
