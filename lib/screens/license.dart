import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LicenseScreen extends HookWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final version = useState<String?>(null);
    Future<void> getVer() async {
      final packageInfo = await PackageInfo.fromPlatform();
      version.value = packageInfo.version;
    }

    useEffect(
      () {
        getVer();
        return null;
      },
      [],
    );

    return LicensePage(
      applicationName: '愛工大アプリ',
      applicationVersion: version.value,
    );
  }
}
