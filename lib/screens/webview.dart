import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebViewScreen extends StatefulHookConsumerWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late final InAppWebViewController webViewController;
  late final CookieManager cookieManager;
  final expiresDate =
      DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch;
  final url = WebUri(
    'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/',
  );

  @override
  Widget build(BuildContext context) {
    final load = useState(false);
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
      await cookieManager.deleteAllCookies();

      await cookieManager.setCookie(
        url: url,
        name: 'JSESSIONID',
        value: cookies[0].split('=')[1],
        expiresDate: expiresDate,
        isSecure: true,
      );
      await cookieManager.setCookie(
        url: url,
        name: 'LiveApps-Cookie',
        value: cookies[1].split('=')[1],
        expiresDate: expiresDate,
        isSecure: true,
      );
      await cookieManager.setCookie(
        url: url,
        name: 'L-CamApp',
        value: 'Y',
        expiresDate: expiresDate,
        isSecure: true,
      );
      load.value = true;
    }

    useEffect(
      () {
        cookieManager = CookieManager.instance();
        getLoginCookie();
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(),
      body: load.value
          ? InAppWebView(
              initialUrlRequest: URLRequest(
                url: url,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
            )
          : const SizedBox(),
    );
  }
}
