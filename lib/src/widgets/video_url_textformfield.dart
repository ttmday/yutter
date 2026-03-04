import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';

import 'package:yutter/src/controller/yutter.dart';

import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';
import 'package:yutter/src/utils/toast.dart';

import 'package:yutter/src/widgets/button.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class VideoUrlTextFormField extends StatefulWidget {
  const VideoUrlTextFormField({super.key});

  @override
  State<VideoUrlTextFormField> createState() => _VideoUrlTextFormFieldState();
}

class _VideoUrlTextFormFieldState extends State<VideoUrlTextFormField>
    with ClipboardListener {
  late final YutterController _yutterController;
  late final StreamSubscription _intentSub;

  final InputBorder inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.border),
    borderRadius: BorderRadius.all(Radius.circular(AppDesign.radius)),
  );

  @override
  void initState() {
    super.initState();
    clipboardWatcher.addListener(this);
    // start watch
    clipboardWatcher.start();

    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (value) {
        if (value.isEmpty) return;
        String text = value[0].path;

        _onPaste(text);
      },
      onError: (err) {
        log("getIntentDataStream error: $err");
      },
    );

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isEmpty) return;
      String text = value[0].path;

      _onPaste(text);

      ReceiveSharingIntent.instance.reset();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yutterController = context.read<YutterController>();
    });
  }

  @override
  void dispose() {
    clipboardWatcher.removeListener(this);
    // stop watch
    clipboardWatcher.stop();
    _yutterController.dispose();

    _intentSub.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YutterController>(
      builder: (context, controller, _) {
        return Column(
          children: [
            SizedBox(
              height: 44.0,
              child: TextFormField(
                controller: controller.videoUrlController,

                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'https://www.youtube.com/watch?v=...',
                  hintStyle: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14.0,
                  ),
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  contentPadding: const EdgeInsets.all(AppDesign.padding),
                ),
              ),
            ),
            const SizedBox(height: AppDesign.padding * 2),
            Row(
              children: [
                Button(
                  width: .infinity,
                  onPressed: () async {
                    String paste = await getClipboardPaste();
                    _onPaste(paste);
                  },
                  text: 'Iniciar',
                ),
                // const SizedBox(width: AppDesign.padding * 1.6),
                // Button(onPressed: _onClear, text: 'Borrar', filled: false),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<String> getClipboardPaste() async {
    ClipboardData? newClipboardData = await Clipboard.getData(
      Clipboard.kTextPlain,
    );
    String text = newClipboardData?.text ?? "";

    return text;
  }

  @override
  void onClipboardChanged() async {
    String paste = await getClipboardPaste();
    if (paste == _yutterController.videoUrlController.text) return;

    _onPaste(paste);
  }

  void _onPaste(String text) async {
    String link = text;

    if (link.isEmpty || !_yutterController.validateURL(link)) {
      await invalidUrlToast();
      return;
    }

    _yutterController.videoUrlController.text = link;
    _getVideoInfoFromLink();
  }

  // void _onClear() {
  //   _yutterController.clear();
  // }

  void _getVideoInfoFromLink() {
    String videoUrl = _yutterController.videoUrlController.text;
    _yutterController.getVideoInfo(videoUrl);
  }
}
