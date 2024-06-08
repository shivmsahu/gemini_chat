import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  SharedPreferences? _preferences;

  static final PreferencesUtil _instance = PreferencesUtil._();

  factory PreferencesUtil() {
    return _instance;
  }

  PreferencesUtil._();

  /// call this method one time to initialize Shared-preferences before using it
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }
}