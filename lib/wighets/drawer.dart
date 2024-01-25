import 'package:aitapp/const.dart';
import 'package:aitapp/provider/filter_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/screens/contacts.dart';
import 'package:aitapp/screens/course_registration.dart';
import 'package:aitapp/screens/links.dart';
import 'package:aitapp/screens/login.dart';
import 'package:aitapp/screens/open_asset_pdf.dart';
import 'package:aitapp/screens/settings.dart';
import 'package:aitapp/screens/syllabus_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  Future<void> loginCampus({
    required WidgetRef ref,
    required bool isMoodle,
  }) async {
    late final InAppWebViewController webviewcontroller;
    late final HeadlessInAppWebView headlessWebView;
    final identity = ref.read(idPasswordProvider);
    final now = DateTime.now();
    headlessWebView = HeadlessInAppWebView(
      initialFile: 'assets/html/index.html',
      onWebViewCreated: (InAppWebViewController webViewController) {
        webviewcontroller = webViewController;
        // Javascriptからの処理を登録
        webViewController.addJavaScriptHandler(
          handlerName: 'return',
          callback: (ciphertext) {
            debugPrint('来たよ $ciphertext');
            launchUrl(
              mode: LaunchMode.externalApplication,
              Uri.parse(
                'https://lcam.aitech.ac.jp/portalv2/login/preLogin/preSpAppSso?spAppSso=Y&selectLocale=ja&para=$ciphertext',
              ),
            );
            headlessWebView.dispose();
          },
        );
      },
      onLoadStop: (controller, url) async {
        await webviewcontroller.evaluateJavascript(
          source:
              "getPara('${now.year}${now.month}${now.day}${now.hour}${now.minute}','${identity[0]}','${identity[1]}','${isMoodle == true ? 'Y' : 'N'}','$blowfishKey');",
        );
      },
    );
    await headlessWebView.run();
  }

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
                onTap: () async {
                  await loginCampus(ref: ref, isMoodle: false);
                },
              ),
              DrawerTile(
                icon: Icons.link,
                title: 'Moodle',
                onTap: () async {
                  await loginCampus(ref: ref, isMoodle: true);
                },
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.event,
                title: '履修/アンケート/成績',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (ctx) => const CourseRegistration(),
                    ),
                  );
                },
              ),
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
