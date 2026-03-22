import 'package:flutter/material.dart';

import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/utils/theme.dart';
import 'package:yutter/src/widgets/clear_button.dart';

import 'package:yutter/src/widgets/search_content.dart';

import 'package:yutter/src/widgets/yutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeUtils.setStatusBarAndNavigationBarTheme(
      color: AppColors.foreground,
      brightness: Brightness.light,
    );
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: AppDesign.padding,
            left: AppDesign.padding * 1.5,
            right: AppDesign.padding * 1.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                children: [Yutter(), ClearButton()],
              ),
              SizedBox(height: AppDesign.padding),
              Expanded(child: SearchContent()),
            ],
          ),
        ),
      ),
    );
  }
}
