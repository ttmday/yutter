import 'package:flutter/material.dart';
import 'package:yutter/src/constants/assets.dart';
import 'package:yutter/src/constants/color.dart';

class ThumbImage extends StatelessWidget {
  const ThumbImage({
    super.key,
    required this.thumbnail,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    final w = width ?? MediaQuery.of(context).size.width;
    final maxWidth = 380.0;
    return FadeInImage.assetNetwork(
      placeholder: Assets.emptyState,
      image: thumbnail,
      width: w > maxWidth ? maxWidth : w,
      height: height ?? 200,
      fit: .fill,
      imageErrorBuilder: (context, error, stackTrace) {
        return Center(
          child: Text(
            "Portada no encontrada.",
            textAlign: .center,
            style: TextStyle(color: AppColors.text, fontSize: 14.0),
          ),
        );
      },
    );
  }
}
