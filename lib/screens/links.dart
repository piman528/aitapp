import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Links extends StatelessWidget {
  const Links({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('各種リンク'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('MyKiTS 教科書販売'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://gomykits.kinokuniya.co.jp/aichikogyo/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('愛知工業大学附属図書館'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://library.aitech.ac.jp/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('授業・試験時間について'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/schedule/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('学生生活について'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/students/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('各種証明書の発行'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/certificates/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('学習支援'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/academic-sup/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('キャンパスルール'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/campus-rules/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('各種保険'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/insurances/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('自動車・バイク・自転車通学'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/vehicles/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('通学定期券'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/commuter-pass/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('健康管理'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/staying-healthy/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('障がい学習支援に関するガイドライン'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/services/disabled-support/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('ハラスメントへの取り組み'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/guide/responsibility/harassment/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
          ListTile(
            title: const Text('緊急災害時の対応'),
            onTap: () => launchUrl(
              Uri.parse(
                'https://www.ait.ac.jp/campuslife/disasters/',
              ),
            ),
            trailing: const Icon(Icons.link),
          ),
        ],
      ),
    );
  }
}
