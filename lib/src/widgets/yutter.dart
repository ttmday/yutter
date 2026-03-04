import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:flutter/material.dart';

class Yutter extends StatelessWidget {
  const Yutter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: Text(
        'Yutter',
        style: AppDesign.textTheme(
          context,
        ).headlineLarge!.copyWith(color: AppColors.primary, fontSize: 32.0),
      ),
    );
  }
}
