import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebViewScreen extends HookConsumerWidget {
  const WebViewScreen({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final load = useState(false);
    final cookieManager = CookieManager.instance();
    final expiresDate =
        DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch;
    final webUrl = WebUri(
      url,
    );
    Future<void> getLoginCookie() async {
      final cookies = await getCookie();
      final identity = ref.read(idPasswordProvider);
      await loginLcam(
        identity[0],
        identity[1],
        cookies[0],
        cookies[1],
      );

      await cookieManager.deleteAllCookies();

      await cookieManager.setCookie(
        url: webUrl,
        name: 'JSESSIONID',
        value: cookies[0].split('=')[1],
        expiresDate: expiresDate,
        isSecure: true,
      );
      await cookieManager.setCookie(
        url: webUrl,
        name: 'LiveApps-Cookie',
        value: cookies[1].split('=')[1],
        expiresDate: expiresDate,
        isSecure: true,
      );
      await cookieManager.setCookie(
        url: webUrl,
        name: 'L-CamApp',
        value: 'Y',
        expiresDate: expiresDate,
        isSecure: true,
      );
      load.value = true;
    }

    useEffect(
      () {
        getLoginCookie();
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: load.value
          ? InAppWebView(
              initialUrlRequest: URLRequest(
                url: webUrl,
              ),
            )
          : const SizedBox(),
    );
  }
}
