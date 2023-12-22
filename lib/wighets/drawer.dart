import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/screens/login.dart';
import 'package:aitapp/screens/settings.dart';
import 'package:aitapp/screens/student_handbook.dart';
import 'package:aitapp/screens/syllabus_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              DrawerTile(
                icon: Icons.calendar_today,
                title: '行事予定',
                onTap: () {},
              ),
              DrawerTile(
                icon: Icons.book,
                title: '学生便覧',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const StudentHandbookScreen(),
                    ),
                  );
                  // launchUrl(
                  //   Uri.parse(
                  //     'https://www.ait.ac.jp/assets/docs/binran2023.pdf',
                  //   ),
                  // );
                },
              ),
              DrawerTile(icon: Icons.map_rounded, title: '学内マップ', onTap: () {}),
              DrawerTile(
                icon: Icons.search,
                title: 'シラバス検索',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const SyllabusSearchScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.settings,
                title: '設定',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const Settings(),
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.logout,
                title: 'ログアウト',
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('id');
                  await prefs.remove('password');
                  ref.read(idPasswordProvider.notifier).setIdPassword('', '');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      onTap: onTap,
    );
  }
}
