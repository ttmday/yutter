import 'package:flutter/material.dart';

import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';

class DownloadBar extends StatelessWidget {
  const DownloadBar({super.key, required this.receive});

  final int receive;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = 560.0;
    return Container(
      padding: .all(AppDesign.padding),
      width: w > maxWidth ? maxWidth : w,
      height: 40,
      decoration: BoxDecoration(
        border: .all(color: AppColors.border.withValues(alpha: .8)),
        borderRadius: BorderRadius.all(Radius.circular(AppDesign.radius / 2)),
      ),
      child: Row(
        mainAxisAlignment: .spaceAround,
        crossAxisAlignment: .center,
        children: [
          ...List.generate(10, (index) {
            return AnimatedOpacity(
              duration: Duration(milliseconds: 600),
              curve: Curves.easeIn,
              opacity: receive >= index ? 1 : 0,
              child: ColoredBox(
                color: AppColors.background,
                child: SizedBox(width: 22.0, height: 36.0),
              ),
            );
          }),
        ],
      ),
    );
  }
}
