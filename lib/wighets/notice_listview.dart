import 'dart:io';

import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/provider/class_notices_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/last_login_time_provider.dart';
import 'package:aitapp/provider/last_notice_login_time_provider.dart';
import 'package:aitapp/provider/notice_token_provider.dart';
import 'package:aitapp/provider/tab_button_provider.dart';
import 'package:aitapp/provider/univ_notices_provider.dart';
import 'package:aitapp/wighets/notice_item.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoticeList extends HookConsumerWidget {
  const NoticeList({
    super.key,
    required this.getNotice,
    required this.loading,
    required this.tabs,
    required this.isCommon,
  });

  final GetNotice getNotice;
  final void Function({required bool state}) loading;
  final ValueNotifier<int> tabs;
  final bool isCommon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = useState<Widget>(
      const Center(
        child: SizedBox(
          height: 25, //指定
          width: 25, //指定
          child: CircularProgressIndicator(),
        ),
      ),
    );
    final pageKey = useMemoized(
      () => ValueKey(
        isCommon ? 'univNoticePage' : 'classNoticePage',
      ),
    );
    final scrollKey = useMemoized(
      () => ValueKey(
        isCommon ? 'univScrollOffset' : 'classScrollOffset',
      ),
    );
    final error = useState<String?>(null);
    final isLoading = useState(false);
    final filter = useState('');
    final beforeReloadLengh = useRef(0);
    final page = useRef(
      (PageStorage.of(context).readState(
            context,
            identifier: pageKey,
          ) ??
          10) as int,
    );
    final isManual = useRef(false);
    final operation = useRef<CancelableOperation<void>?>(null);
    final textEditingController = useTextEditingController();
    final isDispose = useRef(false);
    final controller = useScrollController(
      initialScrollOffset:
          (PageStorage.of(context).readState(context, identifier: scrollKey) ??
              0.0) as double,
    );

    List<Notice> filteredList(List<Notice> list) {
      late final List<Notice> result;
      if (isCommon) {
        result = list
            .where(
              (notice) =>
                  notice.title.toLowerCase().contains(
                        filter.value.toLowerCase(),
                      ) ||
                  notice.sender.toLowerCase().contains(
                        filter.value.toLowerCase(),
                      ),
            )
            .toList();
      } else {
        result = list
            .where(
              (notice) =>
                  (notice as ClassNotice).subject.toLowerCase().contains(
                        filter.value.toLowerCase(),
                      ) ||
                  notice.title.toLowerCase().contains(
                        filter.value.toLowerCase(),
                      ) ||
                  notice.sender.toLowerCase().contains(
                        filter.value.toLowerCase(),
                      ),
            )
            .toList();
      }

      return result;
    }

    Future<void> load({
      required bool withLogin,
      bool isRetry = false,
    }) async {
      late final List<Notice> result;
      error.value = null;
      loading(state: true);
      isLoading.value = true;
      try {
        if (withLogin) {
          final identity = ref.read(idPasswordProvider);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(lastLoginTimeProvider.notifier).updateLastLoginTime();
          });
          await getNotice.create(identity[0], identity[1]);

          (isCommon
                  ? ref.read(lastUnivLoginTimeProvider.notifier)
                  : ref.read(lastClassLoginTimeProvider.notifier))
              .state = ref.read(lastLoginTimeProvider);
        }
        result = await getNotice.getNoticelist(
          page: page.value,
          isCommon: isCommon,
          withLogin: withLogin,
        );
        if (!isDispose.value) {
          if (isCommon) {
            ref
                .read(univNoticesProvider.notifier)
                .reloadNotices(result as List<UnivNotice>);
          } else {
            ref
                .read(classNoticesProvider.notifier)
                .reloadNotices(result as List<ClassNotice>);
          }
        }
      } on SocketException {
        if (!isDispose.value) {
          error.value = 'インターネットに接続できません';
        }
      } on Exception catch (err) {
        if (!isRetry) {
          await load(withLogin: true, isRetry: true);
        } else if (!isDispose.value) {
          error.value = err.toString();
        }
      }
      if (!isDispose.value) {
        loading(state: false);
        isLoading.value = false;
      }
    }

    ref
      ..listen(lastLoginTimeProvider, (previous, next) {
        if (!isLoading.value && tabs.value == (isCommon ? 0 : 1)) {
          operation.value = CancelableOperation.fromFuture(
            load(withLogin: true),
          );
        }
      })
      ..listen(tabButtonProvider, (previous, next) {
        controller.animateTo(
          0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      });

    useEffect(
      () {
        final lastNoticeLoginTimeProvider = isCommon
            ? ref.read(lastUnivLoginTimeProvider)
            : ref.read(lastClassLoginTimeProvider);
        final lastLogin = ref.read(lastLoginTimeProvider);
        if (lastNoticeLoginTimeProvider == null ||
            lastNoticeLoginTimeProvider != lastLogin) {
          operation.value = CancelableOperation.fromFuture(
            load(withLogin: true),
          );
        }
        textEditingController.addListener(() {
          filter.value = textEditingController.text;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          (isCommon
                  ? ref.read(univNoticeTokenProvider.notifier)
                  : ref.read(classNoticeTokenProvider.notifier))
              .state = getNotice;
        });
        return () {
          if (operation.value != null) {
            operation.value!.cancel();
          }
          isDispose.value = true;
        };
      },
      [],
    );

    if ((isCommon && ref.read(univNoticesProvider) != null) ||
        (!isCommon && ref.read(classNoticesProvider) != null)) {
      if (error.value == null) {
        final result = isCommon
            ? ref.read(univNoticesProvider)!
            : ref.read(classNoticesProvider)!;
        final filteredResult = filteredList(result);
        content.value = NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              PageStorage.of(context).writeState(
                context,
                controller.offset,
                identifier: scrollKey,
              );
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              isManual.value = true;
              if (!isLoading.value) {
                page.value = 10;
                beforeReloadLengh.value = 0;
                await load(withLogin: true);
              }
              if (!isDispose.value) {
                isManual.value = false;
              }
            },
            child: CustomScrollView(
              controller: controller,
              slivers: [
                SliverAppBar(
                  scrolledUnderElevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  automaticallyImplyLeading: false,
                  expandedHeight: 80,
                  snap: true,
                  floating: true,
                  flexibleSpace: SearchBarWidget(
                    controller: textEditingController,
                    hintText: '送信元、キーワードで検索',
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext c, int i) {
                      if (i == filteredResult.length - 3) {
                        if (!isLoading.value &&
                            filteredResult.length != beforeReloadLengh.value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            page.value += 10;
                            beforeReloadLengh.value = filteredResult.length;
                            PageStorage.of(context).writeState(
                              context,
                              page.value,
                              identifier: pageKey,
                            );
                            load(withLogin: false);
                          });
                        }
                      }
                      return NoticeItem(
                        notice: filteredResult[i],
                        index: result.indexOf(filteredResult[i]),
                        getNotice: getNotice,
                        tap: !isLoading.value,
                        isCommon: isCommon,
                        page: page.value,
                      );
                    },
                    childCount: filteredResult.length,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: error.toString());
      }
    } else if (error.value != null) {
      content.value = Center(
        child: Text(error.value!),
      );
    }
    return Column(
      children: [
        LinearProgressIndicator(
          minHeight: 2,
          value: isLoading.value &&
                  ((isCommon && ref.read(univNoticesProvider) != null) ||
                      (!isCommon && ref.read(classNoticesProvider) != null)) &&
                  !isManual.value
              ? null
              : 0,
        ),
        Expanded(
          child: content.value,
        ),
      ],
    );
  }
}
