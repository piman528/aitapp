import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/wighets/class_notice_listview.dart';
import 'package:aitapp/wighets/univ_notice_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NoticeScreen extends HookWidget {
  const NoticeScreen({super.key});

  static const pageLength = 2;

  @override
  Widget build(BuildContext context) {
    final getUnivNotice = useRef(GetNotice());
    final getClassNotice = useRef(GetNotice());
    final currentPage = useRef(0);
    final pageController = usePageController(initialPage: currentPage.value);
    final tabController = useTabController(initialLength: pageLength);
    final isLoading = useState(false);

    void loading({required bool state}) {
      if (state != isLoading.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isLoading.value = state;
        });
      }
    }

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
                }
              }
            },
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                UnivNoticeList(
                  getNotice: getUnivNotice.value,
                  loading: loading,
                ),
                ClassNoticeList(
                  getNotice: getClassNotice.value,
                  loading: loading,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
