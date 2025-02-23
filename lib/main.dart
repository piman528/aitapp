import 'dart:async';
import 'dart:io';

import 'package:aitapp/application/state/identity_provider.dart';
import 'package:aitapp/application/state/setting_int_provider.dart';
import 'package:aitapp/application/state/shared_preference_provider.dart';
import 'package:aitapp/domain/types/identity.dart';
import 'package:aitapp/infrastructure/database/db_helper.dart';
import 'package:aitapp/infrastructure/restaccess/access_latest_version.dart';
import 'package:aitapp/presentation/dialogs/update_dialog.dart';
import 'package:aitapp/presentation/screens/login.dart';
import 'package:aitapp/presentation/screens/tabs.dart';
import 'package:aitapp/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final jsonData = await rootBundle.loadString('assets/building.json');
  await DatabaseHelper().importFromJson(jsonData);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          // ここでインスタンス化し、Providerの値を上書きします
          await SharedPreferences.getInstance(),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingIntProvider)!['colorTheme']!;

    return MaterialApp(
      theme: buildThemeLight(),
      darkTheme: buildThemeDark(),
      themeMode: switch (themeMode) {
        0 => ThemeMode.system,
        1 => ThemeMode.light,
        2 => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      home: const InitHome(),
    );
  }
}

class InitHome extends HookConsumerWidget {
  const InitHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = useState<Widget>(const SizedBox.shrink());
    void loadIdPass() {
      final prefs = ref.read(sharedPreferencesProvider);
      final id = prefs.getString('id');
      final password = prefs.getString('password');
      if (id != null && password != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.read(identityProvider.notifier).setIdPassword(
                Identity(id: id, password: password),
              );
          content.value = const TabScreen();
        });
      } else {
        content.value = const LoginScreen();
      }
    }

    Future<bool> checkVersion() async {
      final currentVersion = (await PackageInfo.fromPlatform()).version;
      try {
        final latestVersion = await getLatestVersion();
        return latestVersion != 'v$currentVersion';
      } on SocketException {
        await Fluttertoast.showToast(msg: 'インターネットに接続できません');
      } on Exception {
        await Fluttertoast.showToast(msg: 'バージョンの確認に失敗しました');
      }
      return false;
    }

    useEffect(
      () {
        loadIdPass();
        checkVersion().then(
          (value) => value
              ? showDialog<Widget>(
                  context: context,
                  builder: (BuildContext ctx) {
                    return const UpdateDialog();
                  },
                )
              : null,
        );
        return null;
      },
      [],
    );

    return content.value;
  }
}
