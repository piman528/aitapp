import 'package:aitapp/models/select_filter.dart';
import 'package:aitapp/models/syllabus_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectFiltersProvider = StateProvider<SelectFilters?>((ref) => null);

final syllabusFiltersProvider = StateProvider<SyllabusFilters?>((ref) => null);
