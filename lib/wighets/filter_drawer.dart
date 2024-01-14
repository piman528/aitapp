import 'package:aitapp/models/select_filter.dart';
import 'package:aitapp/models/syllabus_filter.dart';
import 'package:aitapp/provider/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterDrawer extends HookConsumerWidget {
  const FilterDrawer({
    super.key,
    required this.setFilters,
  });
  final void Function({
    required SelectFilters selectFilters,
  }) setFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectfilters =
        useRef<SelectFilters?>(ref.read(selectFiltersProvider));
    final filters = useRef<SyllabusFilters?>(ref.read(syllabusFiltersProvider));

    final selectYear = useState<String>(selectfilters.value!.year);
    final selectCampus = useState<String?>(selectfilters.value?.campus);
    final selectFaculty = useState<String?>(selectfilters.value?.folder);
    final selectSemester = useState<String?>(selectfilters.value?.semester);
    final selectWeek = useState<String?>(selectfilters.value?.week);
    final selectHour = useState<String?>(selectfilters.value?.hour);

    useEffect(
      () {
        return () {
          final submitfilter = SelectFilters(
            year: selectYear.value,
            folder: selectFaculty.value,
            campus: selectCampus.value,
            semester: selectSemester.value,
            week: selectWeek.value,
            hour: selectHour.value,
          );
          if (submitfilter != selectfilters.value) {
            setFilters(selectFilters: submitfilter);
          }
        };
      },
      [],
    );

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Text('絞り込み'),
              const Divider(),
              ListTile(
                title: const Text('年度'),
                trailing: DropdownButton(
                  value: selectYear.value,
                  items: [
                    for (final entry in filters.value!.year.entries) ...{
                      DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ),
                    },
                  ],
                  onChanged: (item) {
                    selectYear.value = item!;
                  },
                ),
              ),
              ListTile(
                title: const Text('学部'),
                trailing: DropdownButton(
                  value: selectFaculty.value,
                  items: [
                    for (final entry in filters.value!.folder.entries) ...{
                      DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ),
                    },
                  ],
                  onChanged: (item) {
                    selectFaculty.value = item;
                  },
                ),
              ),
              ListTile(
                title: const Text('キャンパス'),
                trailing: DropdownButton(
                  value: selectCampus.value,
                  items: [
                    for (final entry in filters.value!.campus.entries) ...{
                      DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ),
                    },
                  ],
                  onChanged: (item) {
                    selectCampus.value = item;
                  },
                ),
              ),
              ListTile(
                title: const Text('開講学期'),
                trailing: DropdownButton(
                  value: selectSemester.value,
                  items: [
                    for (final entry in filters.value!.semester.entries) ...{
                      DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ),
                    },
                  ],
                  onChanged: (item) {
                    selectSemester.value = item;
                  },
                ),
              ),
              ListTile(
                title: const Text('曜日'),
                trailing: DropdownButton(
                  value: selectWeek.value,
                  items: [
                    for (final entry in filters.value!.week.entries) ...{
                      DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ),
                    },
                  ],
                  onChanged: (item) {
                    selectWeek.value = item;
                  },
                ),
              ),
              ListTile(
                title: const Text('時限'),
                trailing: DropdownButton(
                  value: selectHour.value,
                  items: [
                    for (final entry in filters.value!.hour.entries) ...{
                      DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ),
                    },
                  ],
                  onChanged: (item) {
                    selectHour.value = item;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
