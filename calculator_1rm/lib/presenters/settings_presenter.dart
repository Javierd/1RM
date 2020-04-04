import 'package:calculator_1rm/contracts/settings_contract.dart';
import 'package:calculator_1rm/models/settings.dart';
import 'package:calculator_1rm/presenters/base_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPresenter extends BasePresenter<SettingsPageContract> implements SettingsPresenterContract{
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
  @override
  void loadUserSettings() {
    view.updateUserSettings(Settings.loadUserSettings(_prefs));
  }

  @override
  void updateUserSettings(String name, bool value) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(name, value);

  }

  Future setUserSetting(String name, bool value) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(name, value);
    view.updateUserSetting(name, value);
  }

}