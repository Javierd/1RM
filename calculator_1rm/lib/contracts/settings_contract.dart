abstract class SettingsPresenterContract{
  void loadUserSettings();
  void updateUserSettings(String name, bool value);
}

abstract class SettingsPageContract{
  void updateUserSettings(Future<Map<String, bool>> result);
  void updateUserSetting(String name, bool newValue);
}