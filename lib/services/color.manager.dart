import 'package:shared_preferences/shared_preferences.dart';

class ColorManager {
  Future<int?> prefferedColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('color');
  }
}
