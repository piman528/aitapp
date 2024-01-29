import 'dart:io';

import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/provider/class_notices_provider.dart';
import 'package:aitapp/provider/file_downloading_provider.dart';
import 'package:aitapp/provider/id_password_provider.dart';
import 'package:aitapp/provider/last_login_time_provider.dart';
import 'package:aitapp/provider/last_notice_login_time_provider.dart';
import 'package:aitapp/provider/notice_token_provider.dart';
import 'package:aitapp/wighets/class_notice.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClassNoticeList extends HookConsumerWidget {
  const ClassNoticeList({
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
    final beforeReloadLengh = useRef(0);
    final page = useRef(
      (PageStorage.of(context).readState(
            context,
            identifier: const ValueKey('classNoticePage'),
          ) ??
          10) as int,
    );
    final isManual = useRef(false);
    final error = useState<String?>(null);
    final isLoading = useState(false);
    final classController = useTextEditingController();
    final classFilter = useState('');
    final operation = useRef<CancelableOperation<void>?>(null);
    final isDispose = useRef(false);
    final controller = useScrollController(
      initialScrollOffset: (PageStorage.of(context).readState(
            context,
            identifier: const ValueKey('classScrollOffset'),
          ) ??
          0.0) as double,
    );

    List<ClassNotice> filteredList(List<ClassNotice> list) {
      final result = list
          .where(
            (classNotice) =>
                classNotice.subject.toLowerCase().contains(
                      classFilter.value.toLowerCase(),
                    ) ||
                classNotice.title.toLowerCase().contains(
                      classFilter.value.toLowerCase(),
                    ) ||
                classNotice.sender.toLowerCase().contains(
                      classFilter.value.toLowerCase(),
                    ),
          )
          .toList();
      return result;
    }

    Future<void> load({
      required bool withLogin,
    }) async {
      late final List<ClassNotice> result;
      loading(state: true);
      isLoading.value = true;
      try {
        if (withLogin) {
          final identity = ref.read(idPasswordProvider);
          await getNotice.create(identity[0], identity[1], ref);
          ref.read(classNoticeTokenProvider.notifier).state = getNotice;
          ref.read(lastClassLoginTimeProvider.notifier).state =
              ref.read(lastLoginTimeProvider);
          result = await getNotice.getClassNoticelist(page.value);
        } else {
          result = await getNotice.getClassNoticelistNext(page.value);
        }
        if (!isDispose.value) {
          ref.read(classNoticesProvider.notifier).reloadNotices(result);
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
        isLoading.value = false;
        loading(state: false);
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
        final classNoticeLastLogin = ref.read(lastClassLoginTimeProvider);
        final lastLogin = ref.read(lastLoginTimeProvider);
        if (classNoticeLastLogin == null || classNoticeLastLogin != lastLogin) {
          operation.value = CancelableOperation.fromFuture(
            load(withLogin: true),
          );
        }
        classController.addListener(() {
          classFilter.value = classController.text;
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

    if (ref.read(classNoticesProvider) != null) {
      if (error.value == null) {
        final result = ref.read(classNoticesProvider)!;
        final filteredResult = filteredList(result);
        content.value = NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              PageStorage.of(context).writeState(
                context,
                controller.offset,
                identifier: const ValueKey('classScrollOffset'),
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
                    controller: classController,
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
                              identifier: const ValueKey('classNoticePage'),
                            );
                            load(withLogin: false);
                          });
                        }
                      }
                      return ClassNoticeItem(
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
                  ref.read(classNoticesProvider) != null &&
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
