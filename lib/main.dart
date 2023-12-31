import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/screens/login.dart';
import 'package:aitapp/screens/tabs.dart';
import 'package:aitapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
        Locale('en'),
        Locale('ja'),
      ],

      // アプリのlocaleを日本語に変更する
      locale: const Locale('ja', 'JP'),
    );
  }
}
