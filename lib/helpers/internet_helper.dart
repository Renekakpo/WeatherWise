import 'package:connectivity_plus/connectivity_plus.dart';

class InternetHelper {
  // Singleton pattern to ensure only one instance of InternetHelper is created
  static final InternetHelper _instance = InternetHelper._internal();

  factory InternetHelper() {
    return _instance;
  }

  InternetHelper._internal();

  // Method to check if there is an internet connection
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // Optional: Stream to listen to connectivity changes
  Stream<ConnectivityResult> get connectivityStream {
    return Connectivity().onConnectivityChanged;
  }
}