import 'package:aitapp/application/state/notice_load/notice_load.dart';
import 'package:aitapp/presentation/wighets/appbar.dart';
import 'package:aitapp/presentation/wighets/notice_tab_page.dart';
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
    final isLoading = ref.watch(noticeLoadNotifierProvider);

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
        return null;
      },
      [currentPage.value],
    );

    return Column(
      children: [
        AppBarWidget(
          child: IgnorePointer(
            ignoring: isLoading,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.6),
              ),
              child: TabBar(
                labelColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primary,
                ),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance, size: 18),
                        SizedBox(width: 4),
                        Text('学内'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.class_, size: 18),
                        SizedBox(width: 4),
                        Text('授業'),
                      ],
                    ),
                  ),
                ],
                controller: tabController,
                onTap: (index) {
                  if (!isLoading) {
                    currentPage.value = index;
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0 &&
                  !isLoading &&
                  0 < currentPage.value) {
                //左ページへ
                currentPage.value -= 1;
              } else if (details.primaryVelocity! < 0 &&
                  !isLoading &&
                  pageLength - 1 > currentPage.value) {
                //右ページへ
                currentPage.value += 1;
              }
            },
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: const [
                NoticeTabPage(
                  isCommon: true,
                ),
                NoticeTabPage(
                  isCommon: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
