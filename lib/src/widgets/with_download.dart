import 'package:flutter/material.dart';

import 'package:yutter/src/constants/color.dart';
// import 'package:yutter/src/constants/design.dart';

class WithDownload extends StatelessWidget {
  const WithDownload({
    super.key,
    required this.child,
    this.download = false,
    this.received = 0,
    this.total = 0,
    this.height,
    this.width,
  });

  final Widget child;
  final bool download;
  final int received;
  final int total;

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    Size q = MediaQuery.sizeOf(context);
    bool isDownload = download && total > 0;
    // int percent = isDownload ? ((received / total) * 100).floor() : 0;
    return SizedBox(
      width: width ?? q.width,
      height: height ?? q.height,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          child,
          if (isDownload)
            Positioned(
              height: height ?? q.height,
              width: (received / total) * (width ?? q.width),
              bottom: 0,
              child: ColoredBox(
                color: download
                    ? AppColors.accent.withValues(alpha: .6)
                    : Colors.transparent,
              ),
            ),
          // if (download)
          //   Positioned.fill(
          //     child: ColoredBox(
          //       color: AppColors.secondary.withValues(alpha: .15),
          //       child: Center(
          //         child: Text(
          //           '$percent%',
          //           style: AppDesign.textTheme(
          //             context,
          //           ).headlineLarge!.copyWith(color: AppColors.primary),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
