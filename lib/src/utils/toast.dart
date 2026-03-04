import 'package:fluttertoast/fluttertoast.dart';
import 'package:yutter/src/constants/color.dart';

Future<void> notGrantedPermissionToast() async {
  await Fluttertoast.showToast(
    msg: 'Permiso de Almacenamiento denegado.',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.background.withValues(alpha: .6),
    textColor: AppColors.foreground,
    fontSize: 15.0,
  );
}

Future<void> notInternetConectionToast() async {
  await Fluttertoast.showToast(
    msg: 'Sin conexión a Internet.',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.background.withValues(alpha: .6),
    textColor: AppColors.foreground,
    fontSize: 15.0,
  );
}

Future<void> invalidUrlToast() async {
  await Fluttertoast.showToast(
    msg: "El enlace proporcionado no es válido.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.background.withValues(alpha: .6),
    textColor: AppColors.foreground,
    fontSize: 15.0,
  );
  return;
}

Future<void> toast(String message) async {
  await Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.background.withValues(alpha: .6),
    textColor: AppColors.foreground,
    fontSize: 15.0,
  );
}
