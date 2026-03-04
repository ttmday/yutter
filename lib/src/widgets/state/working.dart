import 'package:flutter/material.dart';
import 'package:yutter/src/constants/assets.dart';
import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/widgets/button.dart';

class WorkingState extends StatelessWidget {
  const WorkingState({super.key, required this.controller});

  final YutterController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .center,
      children: [
        Text(
          "¡Ups!",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: .w700,
            fontSize: 32.0,
          ),
        ),
        const SizedBox(height: AppDesign.padding * 1.5),
        Image.asset(Assets.working, height: 120.0),
        const SizedBox(height: AppDesign.padding * 3),
        Text(
          "Algo salió mal, pero estamos trabajando para solucionarlo rápidamente.",
          textAlign: .center,
          style: TextStyle(color: AppColors.field, fontSize: 14.0),
        ),
        const SizedBox(height: AppDesign.padding * 4),
        Button(
          onPressed: () {
            requestPermission();
          },
          width: .infinity,
          text: "Reintentar",
        ),
      ],
    );
  }

  void requestPermission() async {
    await controller.tryRequestPermission();
  }
}
