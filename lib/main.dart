import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:yutter/src/routes/router.dart';

import 'package:yutter/src/constants/theme.dart';

//utils
import 'package:yutter/src/utils/logger.dart';

// service & controller
import 'package:yutter/src/controller/yutter.dart';
import 'package:yutter/src/service/downloader.dart';
import 'package:yutter/src/service/ffmpeg.dart';
import 'package:yutter/src/service/yutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LoggingUtils.startListening();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RouterProvider>(create: (context) => const RouterProvider()),
        Provider<YutterController>(
          create: (context) => YutterController(
            yutterService: YutterService(),
            downloaderService: DownloadService(service: FFmpegService()),
          ),
        ),
      ],
      builder: (context, _) {
        GoRouter router = context.read<RouterProvider>().router;
        return MaterialApp.router(
          builder: FToastBuilder(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(),
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          routerDelegate: router.routerDelegate,
        );
      },
    );
  }
}
