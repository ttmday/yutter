import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/extensions.dart';

import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/models/video_info.dart';
import 'package:yutter/src/widgets/thumb_image.dart';

class StreamInfo extends StatelessWidget {
  const StreamInfo(this.info, {super.key});

  final VideoInfoModel info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Consumer<YutterController>(
        builder: (context, provider, _) {
          final w = MediaQuery.of(context).size.width;
          final maxWidth = 560.0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: w > maxWidth ? maxWidth : w,
                height: 200,
                clipBehavior: Clip.hardEdge,
                constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: 200),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: .8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDesign.radius),
                  ),
                ),
                child: Stack(
                  children: [
                    ThumbImage(thumbnail: info.getThumbnail()),
                    if (info.duration != null)
                      Positioned(
                        right: 18.0,
                        bottom: 12.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.destructive.withValues(alpha: .6),
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppDesign.radius / 2),
                            ),
                          ),
                          child: Padding(
                            padding: .symmetric(vertical: 4.0, horizontal: 8.0),
                            child: Center(
                              child: Text(
                                info.duration!.formatStr,
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppDesign.padding * 2),
              SizedBox(
                width: w > maxWidth ? maxWidth : w,
                child: Text(
                  info.title,
                  textAlign: .start,
                  style: TextStyle(color: AppColors.text, fontSize: 16.0),
                ),
              ),
              const SizedBox(height: AppDesign.padding * .8),
              SizedBox(
                width: w > maxWidth ? maxWidth : w,
                child: Text(
                  info.author,
                  textAlign: .start,
                  style: TextStyle(color: AppColors.field, fontSize: 14.0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
