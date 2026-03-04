import 'package:flutter/material.dart';
import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/widgets/video_url_textformfield.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Iniciar descarga",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: .w700,
            fontSize: 32.0,
          ),
        ),
        const SizedBox(height: AppDesign.padding * .8),
        Text(
          "¡Descarga tus videos y música favorita ahora!",
          textAlign: .center,
          style: TextStyle(color: AppColors.field, fontSize: 14.0),
        ),
        const SizedBox(height: AppDesign.padding * 3),
        VideoUrlTextFormField(),
      ],
    );
  }
}
