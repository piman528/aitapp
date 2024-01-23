import 'dart:io';

import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/screens/login.dart';
import 'package:aitapp/screens/tabs.dart';
import 'package:aitapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_proxy/system_proxy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // システムのproxy設定を取得する.
  final proxy = await SystemProxy.getProxySettings();
  print('=== proxy: $proxy');
  // HttpOverridesの派生クラスをHttpOverrides.globalに指定する.
  HttpOverrides.global = ProxiedHttpOverrides(
    proxy?['host'],
    proxy?['port'],
  );
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<String>> loadIdPass() async {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('id') ?? '';
      final password = prefs.getString('password') ?? '';
      ref.watch(idPasswordProvider.notifier).setIdPassword(id, password);
      return [id, password];
    }

    return MaterialApp(
      theme: buildThemeLight(),
      darkTheme: buildThemeDark(),
      // themeMode: mode,
      home: FutureBuilder(
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
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // localeに英語と日本語を登録する
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
