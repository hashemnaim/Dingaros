import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  SPHelper._();

  static SPHelper spHelper = SPHelper._();

  SharedPreferences sharedPreferences;

  Future<SharedPreferences> initSharedPrefrences() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences;
    } else {
      return sharedPreferences;
    }
  }

  setToken(String value) {
    sharedPreferences.setString('accessToken', value);
  }
   setText(String key,String value) {
    sharedPreferences.setString(key, value);
  }
   getText(String key) {
  String x = sharedPreferences.getString(key);
    return x;  }
  setFcmToken(String value) {
    sharedPreferences.setString('fcmToken', value);
  }

  String getToken() {
    String x = sharedPreferences.getString('accessToken');
    return x;
  }
  String getFcmToken() {
    String x = sharedPreferences.getString('fcmToken');
    return x;
  }

  setOnBoarding(bool value) {
    sharedPreferences.setBool('OnBoarding', value);
  }

  bool getOnBoarding() {
    return sharedPreferences.getBool('OnBoarding');
  }
}
