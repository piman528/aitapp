import 'package:aitapp/application/state/select_syllabus_filter/select_syllabus_filter.dart';
import 'package:aitapp/application/state/syllabus_filter/syllabus_filters.dart';
import 'package:aitapp/application/state/syllabus_search/syllabus_search.dart';
import 'package:aitapp/application/usecases/syllabus_search_usecase.dart';
import 'package:aitapp/domain/features/get_syllabus.dart';
import 'package:aitapp/presentation/wighets/filter_drawer.dart';
import 'package:aitapp/presentation/wighets/loading/notice_loading.dart';
import 'package:aitapp/presentation/wighets/search_bar.dart';
import 'package:aitapp/presentation/wighets/syllabus_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SyllabusSearchScreen extends HookConsumerWidget {
  SyllabusSearchScreen({
    super.key,
  });
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final getSyllabus = useMemoized(GetSyllabus.new);
    final focusNode = useMemoized(FocusNode.new);
    final useCase = useMemoized(
      () => SyllabusSearchUseCase(
        getSyllabus: getSyllabus,
        controller: controller,
        ref: ref,
      ),
    );
    final content = ref.watch(syllabusSearchNotifierProvider);

    useEffect(
      () {
        focusNode.addListener(() {
          if (!focusNode.hasFocus) {
            controller.text =
                ref.watch(selectSyllabusFilterNotifierProvider)?.word ?? '';
          }
        });
        return focusNode.dispose;
      },
      [],
    );

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: FilterDrawer(
        setFilters: useCase.setFilters,
        getSyllabus: getSyllabus,
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'シラバス検索',
        ),
        actions: const [SizedBox()],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  onSuffixIconPusshed: useCase.onClear,
                  onSubmitted: useCase.onSubmit,
                  focusNode: focusNode,
                  controller: controller,
                  hintText: '教授名、授業名で検索',
                ),
              ),
              IconButton(
                onPressed: () {
                  if (ref.read(syllabusFiltersNotifierProvider) != null) {
                    _scaffoldKey.currentState?.openEndDrawer();
                  }
                },
                icon: const Icon(Icons.filter_alt),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          content.when(
            error: (error, stackTrace) {
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => const Expanded(
              child: NoticeLoadingWidget(
                isCommon: true,
              ),
            ),
            data: (data) {
              if (data.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (c, i) => SyllabusItem(
                      syllabus: data[i],
                      getSyllabus: getSyllabus,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
