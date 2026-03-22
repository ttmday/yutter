import 'package:flutter/material.dart';

import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/models/video_info.dart';
import 'package:yutter/src/widgets/button.dart';
import 'package:yutter/src/widgets/thumb_image.dart';

class DownloadedState extends StatelessWidget {
  const DownloadedState({
    super.key,
    required this.info,
    required this.location,
    required this.controller,
  });

  final VideoInfoModel info;
  final String location;
  final YutterController controller;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = 380.0;
    return Container(
      padding: .symmetric(
        horizontal: AppDesign.padding * 2.5,
        vertical: AppDesign.padding * 3.5,
      ),
      decoration: BoxDecoration(
        color: Color(0xff131312).withValues(alpha: .98),
        borderRadius: .all(.circular(AppDesign.radius * 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Descarga exitosa",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: .w700,
              fontSize: 28.0,
            ),
          ),
          const SizedBox(height: AppDesign.padding * 2),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: .all(.circular(AppDesign.radius * 2)),
            ),
            child: ClipRRect(
              borderRadius: .all(Radius.circular(AppDesign.radius)),
              child: ThumbImage(
                thumbnail: info.getThumbnail(),
                height: 140,
                width: 180,
              ),
            ),
          ),
          const SizedBox(height: AppDesign.padding * 2),
          SizedBox(
            width: w > maxWidth ? maxWidth : w,
            child: Text(
              info.title,
              textAlign: .center,
              style: TextStyle(color: AppColors.text, fontSize: 14.0),
            ),
          ),
          const SizedBox(height: AppDesign.padding * .8),
          SizedBox(
            width: w > maxWidth ? maxWidth : w,
            child: Text(
              info.author,
              textAlign: .center,
              style: TextStyle(color: AppColors.field, fontSize: 12.0),
            ),
          ),
          const SizedBox(height: AppDesign.padding * 3),

          Button(onPressed: _onBack, filled: false, text: "Cerrar"),
        ],
      ),
    );
  }

  void _onBack() {
    controller.clear();
  }
}
