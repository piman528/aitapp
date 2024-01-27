import 'dart:io';

import 'package:aitapp/models/get_syllabus.dart';
import 'package:aitapp/models/select_filter.dart';
import 'package:aitapp/provider/filter_provider.dart';
import 'package:aitapp/wighets/filter_drawer.dart';
import 'package:aitapp/wighets/search_bar.dart';
import 'package:aitapp/wighets/syllabus_search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SyllabusSearchScreen extends HookConsumerWidget {
  SyllabusSearchScreen({
    super.key,
  });
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final syllabusList = useState<Widget>(const SizedBox());
    final searchWord = useRef<String?>(null);

    void onSubmit(
      //検索処理
      String? word,
    ) {
      if (word != searchWord.value) {
        searchWord.value = word;
      }
      syllabusList.value = SyllabusSearchList(
        searchtext: searchWord.value,
      );
    }

    void setFilters({
      required SelectFilters selectFilters,
    }) {
      //フィルターが変化
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectFiltersProvider.notifier).state = selectFilters;
        onSubmit(searchWord.value);
      });
    }

    Future<void> getFilters() async {
      //フィルター取得
      try {
        final getsyllabus = GetSyllabus();
        final syllabusFilters = await getsyllabus.create();
        ref.read(syllabusFiltersProvider.notifier).state = syllabusFilters;
        ref.read(selectFiltersProvider.notifier).state = SelectFilters(
          year: syllabusFilters.year.values.first,
        );
      } on SocketException {
        await Fluttertoast.showToast(msg: 'インターネットに接続できません');
      } on Exception catch (err) {
        await Fluttertoast.showToast(msg: err.toString());
      }
    }

    useEffect(
      () {
        if (ref.read(syllabusFiltersProvider) == null) {
          getFilters();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectFiltersProvider.notifier).state = SelectFilters(
              year: ref.read(syllabusFiltersProvider)!.year.values.first,
            );
          });
        }

        return null;
      },
      [],
    );

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: FilterDrawer(
        setFilters: setFilters,
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'シラバス検索',
          // style: TextStyle(color: Colors.black),
        ),
        actions: const [SizedBox()],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  onSubmitted: onSubmit,
                  controller: controller,
                  hintText: '教授名、授業名で検索',
                ),
              ),
              IconButton(
                onPressed: () {
                  if (ref.read(syllabusFiltersProvider) != null) {
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
          syllabusList.value,
        ],
      ),
    );
  }
}
