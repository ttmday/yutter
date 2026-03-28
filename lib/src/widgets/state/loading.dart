import 'package:flutter/material.dart';

import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/widgets/skeleton.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = 560.0;
    return Column(
      children: [
        SizedBox(
          width: w > maxWidth ? maxWidth : w,
          child: Text(
            "Obteniendo información de video...",
            textAlign: .center,
            style: TextStyle(color: AppColors.text, fontSize: 16.0),
          ),
        ),
        const SizedBox(height: AppDesign.padding * 3),
        Column(
          crossAxisAlignment: .start,
          children: [
            Skeleton(width: w > maxWidth ? maxWidth : w, height: 200),

            const SizedBox(height: AppDesign.padding * 2),
            Skeleton(width: w * .8, height: 40),
            const SizedBox(height: AppDesign.padding * .8),
            Skeleton(width: w * .4, height: 18),
          ],
        ),
      ],
    );
  }
}
