import 'package:familytree/Controllers/AuthController.dart';

class SplashScreenController {
  Future<bool> checkAuth() async {
    return await AuthController().checkAuth();
  }
}
