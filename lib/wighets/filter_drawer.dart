import 'package:aitapp/models/select_filter.dart';
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
    final selectfilters = useMemoized(() => ref.read(selectFiltersProvider));
    final filters = useMemoized(() => ref.read(syllabusFiltersProvider));

    final selectYear = useState<String>(selectfilters!.year);
    final selectCampus = useState<String?>(selectfilters.campus);
    final selectFaculty = useState<String?>(selectfilters.folder);
    final selectSemester = useState<String?>(selectfilters.semester);
    final selectWeek = useState<String?>(selectfilters.week);
    final selectHour = useState<String?>(selectfilters.hour);

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
          if (submitfilter != selectfilters) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      selectFaculty.value = null;
                      selectCampus.value = null;
                      selectSemester.value = null;
                      selectWeek.value = null;
                      selectHour.value = null;
                    },
                    child: const Text('クリア'),
                  ),
                  Text(
                    '絞り込み',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                title: const Text('年度'),
                trailing: DropdownButton(
                  value: selectYear.value,
                  items: [
                    for (final entry in filters!.year.entries) ...{
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
                    for (final entry in filters.folder.entries) ...{
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
                    for (final entry in filters.campus.entries) ...{
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
                    for (final entry in filters.semester.entries) ...{
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
                    for (final entry in filters.week.entries) ...{
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
                    for (final entry in filters.hour.entries) ...{
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
