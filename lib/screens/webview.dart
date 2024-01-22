import 'package:aitapp/infrastructure/access_lcan.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulHookConsumerWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = useState<WebViewController?>(null);
    final cookieManager = useRef(WebViewCookieManager());

    Future<void> getLoginCookie() async {
      final cookies = await getCookie();
      final identity = ref.read(idPasswordProvider);
      final isLogin = await loginLcam(
        identity[0],
        identity[1],
        cookies[0],
        cookies[1],
      );
      print(cookies[0].split('=')[1]);
      print(cookies[1].split('=')[1]);
      cookieManager.value.setCookie(
        WebViewCookie(
            name: 'JSESSIONID',
            value: cookies[0].split('=')[1],
            domain:
                'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/'),
      );
      cookieManager.value.setCookie(
        WebViewCookie(
            name: 'LiveApps-Cookie',
            value: cookies[1].split('=')[1],
            domain:
                'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/'),
      );
      cookieManager.value.setCookie(
        WebViewCookie(
            name: 'L-CamApp',
            value: 'Y',
            domain:
                'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/'),
      );
      controller.value = WebViewController()
        ..loadRequest(
          Uri.parse(
              'https://lcam.aitech.ac.jp/portalv2/smartphone/smartPhoneHome/nextPage/entryRegist/'),
        );
    }

    useEffect(
      () {
        getLoginCookie();
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(),
      body: controller.value != null
          ? WebViewWidget(
              controller: controller.value!,
            )
          : const SizedBox(),
    );
  }
}
