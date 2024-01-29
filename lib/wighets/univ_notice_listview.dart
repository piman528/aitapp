import 'dart:io';

import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:aitapp/provider/file_downloading_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/last_login_time_provider.dart';
import 'package:aitapp/provider/last_notice_login_time_provider.dart';
import 'package:aitapp/provider/notice_token_provider.dart';
import 'package:aitapp/provider/univ_notices_provider.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/univ_notice.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UnivNoticeList extends HookConsumerWidget {
  const UnivNoticeList({
    super.key,
    required this.getNotice,
    required this.loading,
  });

  final GetNotice getNotice;
  final void Function({required bool state}) loading;

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
    final error = useState<String?>(null);
    final isLoading = useState(false);
    final univFilter = useState('');
    final beforeReloadLengh = useRef(0);
    final page = useRef(
      (PageStorage.of(context).readState(
            context,
            identifier: const ValueKey('univNoticePage'),
          ) ??
          10) as int,
    );
    final isManual = useRef(false);
    final operation = useRef<CancelableOperation<void>?>(null);
    final univController = useTextEditingController();
    final isDispose = useRef(false);
    final controller = useScrollController(
      initialScrollOffset: (PageStorage.of(context).readState(
            context,
            identifier: const ValueKey('univScrollOffset'),
          ) ??
          0.0) as double,
    );

    List<UnivNotice> filteredList(List<UnivNotice> list) {
      final result = list
          .where(
            (univNotice) =>
                univNotice.title.toLowerCase().contains(
                      univFilter.value.toLowerCase(),
                    ) ||
                univNotice.sender.toLowerCase().contains(
                      univFilter.value.toLowerCase(),
                    ),
          )
          .toList();
      return result;
    }

    Future<void> load({
      required bool withLogin,
    }) async {
      late final List<UnivNotice> result;
      loading(state: true);
      isLoading.value = true;
      try {
        if (withLogin) {
          final identity = ref.read(idPasswordProvider);
          await getNotice.create(identity[0], identity[1], ref);
          ref.read(univNoticeTokenProvider.notifier).state = getNotice;
          ref.read(lastUnivLoginTimeProvider.notifier).state =
              ref.read(lastLoginTimeProvider);
          result = await getNotice.getUnivNoticelist(page.value);
        } else {
          result = await getNotice.getUnivNoticelistNext(page.value);
        }
        if (!isDispose.value) {
          ref.read(univNoticesProvider.notifier).reloadNotices(result);
        }
      } on SocketException {
        if (!isDispose.value) {
          error.value = 'インターネットに接続できません';
        }
      } on Exception catch (err) {
        if (!isDispose.value) {
          error.value = err.toString();
        }
      }
      if (!isDispose.value) {
        loading(state: false);
        isLoading.value = false;
      }
    }

    ref.listen(lastLoginTimeProvider, (previous, next) {
      if (!isLoading.value) {
        if (!ref.read(fileDownloadingProvider)) {
          operation.value = CancelableOperation.fromFuture(
            load(withLogin: true),
          );
        }
      }
    });

    useEffect(
      () {
        final univNoticeLastLogin = ref.read(lastUnivLoginTimeProvider);
        final lastLogin = ref.read(lastLoginTimeProvider);
        if (univNoticeLastLogin == null || univNoticeLastLogin != lastLogin) {
          operation.value = CancelableOperation.fromFuture(
            load(withLogin: true),
          );
        }
        univController.addListener(() {
          univFilter.value = univController.text;
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

    if (ref.read(univNoticesProvider) != null) {
      if (error.value == null) {
        final result = ref.read(univNoticesProvider)!;
        final filteredResult = filteredList(result);
        content.value = NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              PageStorage.of(context).writeState(
                context,
                controller.offset,
                identifier: const ValueKey('univScrollOffset'),
              );
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              isManual.value = true;
              if (!isLoading.value) {
                page.value = 5;
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
                    controller: univController,
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
                              identifier: const ValueKey('univNoticePage'),
                            );
                            load(withLogin: false);
                          });
                        }
                      }
                      return UnivNoticeItem(
                        notice: filteredResult[i],
                        index: result.indexOf(filteredResult[i]),
                        getNotice: getNotice,
                        tap: !isLoading.value,
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
                  ref.read(univNoticesProvider) != null &&
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
