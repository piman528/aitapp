// ignore_for_file: lines_longer_than_80_chars

import 'package:aitapp/application/usecases/main_drawer_usecase.dart';
import 'package:aitapp/presentation/screens/campus_map.dart';
import 'package:aitapp/presentation/screens/contacts.dart';
import 'package:aitapp/presentation/screens/course_registration.dart';
import 'package:aitapp/presentation/screens/links.dart';
import 'package:aitapp/presentation/screens/login.dart';
import 'package:aitapp/presentation/screens/open_asset_pdf.dart';
import 'package:aitapp/presentation/screens/settings.dart';
import 'package:aitapp/presentation/screens/syllabus_search.dart';
import 'package:aitapp/presentation/wighets/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usecase = MainDrawerUseCase(ref, context);
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              DrawerTile(
                icon: Icons.calendar_today,
                title: '行事予定',
                onTap: () {
                  usecase.go(
                    const OpenAssetPdf(
                      title: '行事予定',
                      path: 'assets/pdfs/annual-events.pdf',
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.book,
                title: '学生便覧',
                onTap: () {
                  usecase.go(
                    const OpenAssetPdf(
                      title: '学生便覧',
                      path: 'assets/pdfs/binran2025.pdf',
                    ),
                  );
                },
              ),
              DrawerTile(
                icon: Icons.map_rounded,
                title: '学内マップ',
                onTap: () {
                  usecase.go(const CampusMap());
                },
              ),
              DrawerTile(
                icon: Icons.search,
                title: 'シラバス検索',
                onTap: () {
                  usecase.openSyllabusSearch(SyllabusSearchScreen());
                },
              ),
              DrawerTile(
                icon: Icons.link,
                title: 'L-Cam',
                onTap: () async {
                  await usecase.loginCampus(isMoodle: false);
                },
              ),
              DrawerTile(
                icon: Icons.link,
                title: 'Moodle',
                onTap: () async {
                  await usecase.loginCampus(isMoodle: true);
                },
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.event,
                title: '履修/アンケート/成績',
                onTap: () {
                  usecase.openWebView(const CourseRegistration());
                },
              ),
              DrawerTile(
                icon: Icons.link,
                title: '各種リンク',
                onTap: () {
                  usecase.go(const Links());
                },
              ),
              DrawerTile(
                icon: Icons.phone,
                title: '各所連絡先',
                onTap: () {
                  usecase.go(const Contacts());
                },
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.settings,
                title: '設定',
                onTap: () {
                  usecase.go(const Settings());
                },
              ),
              DrawerTile(
                icon: Icons.logout,
                title: 'ログアウト',
                onTap: () {
                  usecase.removeIdentity(const LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
