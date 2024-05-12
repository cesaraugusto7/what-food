import 'package:connectivity_plus/connectivity_plus.dart';

class ConexaoInternet {
//######Função de validar conexão com internet##################
  static Future<bool> isConnect() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
