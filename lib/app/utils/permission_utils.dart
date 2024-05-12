import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<void> solicitarPermissoes() async {
    await [
      Permission.location,
      Permission.camera,
      Permission.mediaLibrary,
      Permission.accessMediaLocation,
      Permission.notification,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();
    if (await Permission.camera.isPermanentlyDenied) {
      openAppSettings();
      // throw 'Para utilizar o app é necessário permitir o acesso à câmera.';
    }
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
      // throw 'Para utilizar o app é necessário permitir o acesso à localização.';
    }
    if (await Permission.locationAlways.isPermanentlyDenied) {
      openAppSettings();
      // throw 'Para utilizar o app é necessário permitir o acesso à localização.';
    }
    if (await Permission.locationWhenInUse.isPermanentlyDenied) {
      openAppSettings();
      // throw 'Para utilizar o app é necessário permitir o acesso à localização.';
    }
    if (await Permission.mediaLibrary.isPermanentlyDenied) {
      openAppSettings();
      // throw 'Para utilizar o app é necessário permitir o acesso à galeria.';
    }
    if (await Permission.accessMediaLocation.isPermanentlyDenied) {
      openAppSettings();
      // throw 'Para utilizar o app é necessário permitir o acesso à galeria.';
    }
    if (await Permission.notification.isPermanentlyDenied) {
      openAppSettings();
      // throw 'Para utilizar o app é necessário permitir o recebimento de notificações.';
    }
  }
}
