import 'package:aitapp/provider/shared_preference_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingIntNotifier extends StateNotifier<Map<String, int>> {
  SettingIntNotifier(
    StateNotifierProviderRef<SettingIntNotifier, Map<String, int>?> ref,
  ) : super({}) {
    pref = ref.read(sharedPreferencesProvider);
    getSP();
  }
  late final SharedPreferences pref;

  void changeNum(String settingKey, int num) {
    state = state.map(
      (key, value) =>
          key == settingKey ? MapEntry(key, num) : MapEntry(key, value),
    );
    pref.setString(settingKey, num.toString());
  }

  void getSP() {
    state = {
      ...{
        'classTimeTableRow': int.parse(
          pref.getString('classTimeTableRow') ?? '6',
        ),
        'colorTheme': int.parse(
          pref.getString('colorTheme') ?? '0',
        ),
      },
    };
  }
}

final settingIntProvider =
    StateNotifierProvider<SettingIntNotifier, Map<String, int>?>(
  (ref) {
    return SettingIntNotifier(ref);
  },
);
