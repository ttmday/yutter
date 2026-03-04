import 'package:flutter/material.dart';
import 'package:yutter/src/constants/assets.dart';
import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/widgets/button.dart';

class PermissionState extends StatelessWidget {
  const PermissionState({super.key, required this.controller});

  final YutterController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .center,
      children: [
        Text(
          "Permisos",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: .w700,
            fontSize: 32.0,
          ),
        ),
        const SizedBox(height: AppDesign.padding * 1.5),
        Image.asset(Assets.permissionState, height: 120.0),
        const SizedBox(height: AppDesign.padding * 3),
        Text(
          "Se necesitan permisos de almacenamiento para continuar.",
          textAlign: .center,
          style: TextStyle(color: AppColors.field, fontSize: 14.0),
        ),
        const SizedBox(height: AppDesign.padding * 4),
        Button(
          onPressed: () {
            requestPermission();
          },
          width: .infinity,
          text: "Conceder permisos",
        ),
      ],
    );
  }

  void requestPermission() async {
    await controller.tryRequestPermission();
  }
}
