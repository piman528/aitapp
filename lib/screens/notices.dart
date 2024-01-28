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
    required this.univKey,
    required this.classKey,
    required this.bukket,
  });

  static const pageLength = 2;
  final Key univKey;
  final Key classKey;
  final PageStorageBucket bukket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useRef(0);
    final pageController = usePageController(initialPage: currentPage.value);
    final tabController = useTabController(
      initialLength: pageLength,
    );
    final isLoading = useState(false);

    void loading({required bool state}) {
      if (state != isLoading.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isLoading.value = state;
        });
      }
    }

    void setPageStorage() {
      PageStorage.of(context).writeState(
        context,
        currentPage.value,
        identifier: const ValueKey('currentPage'),
      );
    }

    useEffect(
      () {
        final dynamic p = PageStorage.of(context)
            .readState(context, identifier: const ValueKey('currentPage'));
        if (p != null) {
          currentPage.value = p as int;
          tabController.index = p;
        }
        return () {};
      },
      [],
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
                pageController.animateToPage(
                  currentPage.value,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              }
              setPageStorage();
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0 && !isLoading.value) {
                //左ページへ
                if (0 < currentPage.value) {
                  currentPage.value -= 1;
                  tabController.animateTo(
                    currentPage.value,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 250),
                  );
                  pageController.animateToPage(
                    currentPage.value,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                  setPageStorage();
                }
              } else if (details.primaryVelocity! < 0 && !isLoading.value) {
                //右ページへ
                if (pageLength - 1 > currentPage.value) {
                  currentPage.value += 1;
                  tabController.animateTo(
                    currentPage.value,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 250),
                  );
                  pageController.animateToPage(
                    currentPage.value,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                  setPageStorage();
                }
              }
            },
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                UnivNoticeList(
                  getNotice: ref.read(univNoticeTokenProvider) ?? GetNotice(),
                  loading: loading,
                  key: univKey,
                ),
                ClassNoticeList(
                  getNotice: ref.read(classNoticeTokenProvider) ?? GetNotice(),
                  loading: loading,
                  key: classKey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
