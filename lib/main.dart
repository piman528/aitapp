import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/screens/login.dart';
import 'package:aitapp/screens/tabs.dart';
import 'package:aitapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({
    super.key,
  });

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  Future<List<String>> loadIdPass() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id') ?? '';
    final password = prefs.getString('password') ?? '';
    ref.watch(idPasswordProvider.notifier).setIdPassword(id, password);
    return [id, password];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadIdPass(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data?[0] != '' &&
            snapshot.data?[1] != '') {
          return MaterialApp(
            home: const TabScreen(),
            theme: buildThemeLight(),
            darkTheme: buildThemeDark(),
          );
        } else if (snapshot.hasData &&
            snapshot.data?[0] == '' &&
            snapshot.data?[1] == '') {
          return MaterialApp(
            home: const LoginScreen(),
            theme: buildThemeLight(),
            darkTheme: buildThemeDark(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
