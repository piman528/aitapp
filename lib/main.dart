import 'dart:async';
import 'dart:io';

import 'package:aitapp/infrastructure/github_rest_access.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/setting_int_provider.dart';
import 'package:aitapp/provider/shared_preference_provider.dart';
import 'package:aitapp/screens/login.dart';
import 'package:aitapp/screens/tabs.dart';
import 'package:aitapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_proxy/system_proxy.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // システムのproxy設定を取得する.
  final proxy = await SystemProxy.getProxySettings();
  debugPrint('=== proxy: $proxy');
  // HttpOverridesの派生クラスをHttpOverrides.globalに指定する.
  HttpOverrides.global = ProxiedHttpOverrides(
    proxy?['host'],
    proxy?['port'],
  );
  final directory = await getApplicationDocumentsDirectory();
  final plist = directory.listSync();
  for (final p in plist) {
    try {
      await p.delete();
    } on Exception {
      // ファイルの削除に失敗した場合
    }
  }
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // localeに日本語を登録する
      supportedLocales: const [
        Locale('ja'),
      ],

      // アプリのlocaleを日本語に変更する
      locale: const Locale('ja', 'JP'),
    );
  }
}

class ProxiedHttpOverrides extends HttpOverrides {
  ProxiedHttpOverrides(this._host, this._port);
  final String? _port;
  final String? _host;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // host情報が設定されていればhostとportを指定、そうでなければ DIRECT を設定.
    return super.createHttpClient(context)
      // set proxy
      ..findProxy = (uri) {
        return _port != null ? 'PROXY $_host:$_port;' : 'DIRECT';
      };
  }
}

class InitHome extends HookConsumerWidget {
  const InitHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<String>> loadIdPass() async {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('id') ?? '';
      final password = prefs.getString('password') ?? '';
      ref.read(idPasswordProvider.notifier).setIdPassword(id, password);
      return [id, password];
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

    useEffect(() {
      checkVersion().then(
        (value) => value
            ? showDialog<Widget>(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text(
                      'アプリのアップデートがあります',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      // ボタン領域
                      ElevatedButton(
                        child: const Text('後で'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: const Text('OK'),
                        onPressed: () {
                          launchUrl(
                            Uri.parse(
                              'https://github.com/piman528/aitapp/releases/latest',
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              )
            : null,
      );
      return null;
    });

    return FutureBuilder(
      future: loadIdPass(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data?[0] != '' &&
            snapshot.data?[1] != '') {
          return const TabScreen();
        } else if (snapshot.hasData &&
            snapshot.data?[0] == '' &&
            snapshot.data?[1] == '') {
          return const LoginScreen();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
