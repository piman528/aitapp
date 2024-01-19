import 'package:aitapp/provider/filter_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/screens/contacts.dart';
import 'package:aitapp/screens/links.dart';
import 'package:aitapp/screens/login.dart';
import 'package:aitapp/screens/open_asset_pdf.dart';
import 'package:aitapp/screens/settings.dart';
import 'package:aitapp/screens/syllabus_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const OpenAssetPdf(
                        title: '行事予定',
                        path: 'assets/pdfs/annual-events.pdf',
                      ),
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.book,
                title: '学生便覧',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const OpenAssetPdf(
                        title: '学生便覧',
                        path: 'assets/pdfs/binran_2023.pdf',
                      ),
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.map_rounded,
                title: '学内マップ',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const OpenAssetPdf(
                        title: '学内マップ',
                        path: 'assets/pdfs/guide-campus-yakusa.pdf',
                      ),
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.search,
                title: 'シラバス検索',
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => SyllabusSearchScreen(),
                    ),
                  );
                  ref.read(selectFiltersProvider.notifier).state = null;
                },
              ),
              DrawerTile(
                icon: Icons.link,
                title: 'L-Cam',
                onTap: () {
                  launchUrl(
                    mode: LaunchMode.externalApplication,
                    Uri.parse(
                      'https://lcam.aitech.ac.jp/portalv2/',
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.link,
                title: 'Moodle',
                onTap: () {
                  launchUrl(
                    mode: LaunchMode.externalApplication,
                    Uri.parse(
                      'https://cms.aitech.ac.jp/my/index.php',
                    ),
                  );
                },
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.link,
                title: '各種リンク',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const Links(),
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.phone,
                title: '各所連絡先',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const Contacts(),
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
                  await prefs.remove('password').then(
                    (value) {
                      ref
                          .read(idPasswordProvider.notifier)
                          .setIdPassword('', '');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (ctx) => const LoginScreen(),
                        ),
                      );
                    },
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
