import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/notice_token_provider.dart';
import 'package:aitapp/wighets/class_notice_listview.dart';
import 'package:aitapp/wighets/univ_notice_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoticeScreen extends HookConsumerWidget with RouteAware {
  const NoticeScreen({
    super.key,
  });

  static const pageLength = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState<int>(
      (PageStorage.of(context).readState(
            context,
            identifier: const ValueKey('currentPage'),
          ) ??
          0) as int,
    );
    final tabController = useTabController(
      initialLength: pageLength,
      initialIndex: currentPage.value,
    );
    final isLoading = useState(false);
    final isDispose = useRef(false);

    void loading({required bool state}) {
      if (state != isLoading.value && !isDispose.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isLoading.value = state;
        });
      }
    }

    useEffect(
      () {
        tabController.animateTo(
          currentPage.value,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 250),
        );
        PageStorage.of(context).writeState(
          context,
          currentPage.value,
          identifier: const ValueKey('currentPage'),
        );
        return () {
          isDispose.value = true;
        };
      },
      [currentPage.value],
    );

    return Column(
      children: [
        IgnorePointer(
          ignoring: isLoading.value,
          child: TabBar(
            tabs: const [
              Tab(text: '学内'),
              Tab(text: '授業'),
            ],
            controller: tabController,
            onTap: (index) {
              if (!isLoading.value) {
                currentPage.value = index;
              }
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0 &&
                  !isLoading.value &&
                  0 < currentPage.value) {
                //左ページへ
                currentPage.value -= 1;
              } else if (details.primaryVelocity! < 0 &&
                  !isLoading.value &&
                  pageLength - 1 > currentPage.value) {
                //右ページへ
                currentPage.value += 1;
              }
            },
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                UnivNoticeList(
                  getNotice: ref.read(univNoticeTokenProvider) ?? GetNotice(),
                  loading: loading,
                  tabs: currentPage,
                ),
                ClassNoticeList(
                  getNotice: ref.read(classNoticeTokenProvider) ?? GetNotice(),
                  loading: loading,
                  tabs: currentPage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
