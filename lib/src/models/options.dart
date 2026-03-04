class OptionsModel {
  final String? outputPath;
  final String? type;

  OptionsModel({this.outputPath, this.type}) {
    if (type != null) {
      assert(type == "audio");
      assert(type == "video");
    }
  }
}
