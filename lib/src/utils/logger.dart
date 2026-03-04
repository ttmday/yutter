import 'package:logging/logging.dart';

class LoggingUtils {
  const LoggingUtils._();

  static void startListening() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  static Logger getLogger(String name) {
    return Logger(name);
  }
}
