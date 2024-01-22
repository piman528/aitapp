import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulHookConsumerWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late final WebViewController controller;
  late final WebViewCookieManager cookieManager;

  /// 初期状態を設定
  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    cookieManager = WebViewCookieManager();
    getLoginCookie();
  }

  Future<void> getLoginCookie() async {
    final cookies = await getCookie();
    final identity = ref.read(idPasswordProvider);
    await loginLcam(
      identity[0],
      identity[1],
      cookies[0],
      cookies[1],
    );
    print(cookies[0].split('=')[1]);
    print(cookies[1].split('=')[1]);

    cookieManager.setCookie(
      WebViewCookie(
        name: 'JSESSIONID',
        value: cookies[0].split('=')[1],
        domain:
            'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/',
      ),
    );

    cookieManager.setCookie(
      WebViewCookie(
        name: 'LiveApps-Cookie',
        value: cookies[1].split('=')[1],
        domain:
            'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/',
      ),
    );
    cookieManager.setCookie(
      WebViewCookie(
        name: 'L-CamApp',
        value: 'Y',
        domain:
            'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/',
      ),
    );
    controller.loadRequest(
      Uri.parse(
        'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
