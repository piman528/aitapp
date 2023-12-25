import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/wighets/class_notice_listview.dart';
import 'package:aitapp/wighets/univ_notice_listview.dart';
import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen>
    with SingleTickerProviderStateMixin {
  final getUnivNotice = GetNotice();
  final getClassNotice = GetNotice();
  late PageController _pageController;
  late TabController _tabController;
  int _currentPage = 0;
  static const pageLength = 2;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _tabController = TabController(
      length: pageLength,
      vsync: this,
      initialIndex: _currentPage,
    );
  }

  void loading({required bool state}) {
    if (state != isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            isLoading = state;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IgnorePointer(
          ignoring: isLoading,
          child: TabBar(
            tabs: const [
              Tab(text: '学内'),
              Tab(text: '授業'),
            ],
            controller: _tabController,
            onTap: (index) {
              if (!isLoading) {
                setState(() {
                  _currentPage = index;
                  _pageController.animateToPage(
                    _currentPage,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                });
              }
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0 && !isLoading) {
                //左ページへ
                if (0 < _currentPage) {
                  setState(() {
                    _currentPage -= 1;
                    _tabController.animateTo(
                      _currentPage,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 250),
                    );
                    _pageController.animateToPage(
                      _currentPage,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  });
                }
              } else if (details.primaryVelocity! < 0 && !isLoading) {
                //右ページへ
                if (pageLength - 1 > _currentPage) {
                  setState(() {
                    _currentPage += 1;
                    _tabController.animateTo(
                      _currentPage,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 250),
                    );
                    _pageController.animateToPage(
                      _currentPage,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  });
                }
              }
            },
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                UnivNoticeList(
                  getNotice: getUnivNotice,
                  loading: loading,
                ),
                ClassNoticeList(
                  getNotice: getClassNotice,
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
