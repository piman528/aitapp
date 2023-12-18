import 'package:aitapp/models/class_notice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassNoticesNotifier extends StateNotifier<List<ClassNotice>?> {
  ClassNoticesNotifier() : super(null);

  // ignore: use_setters_to_change_properties
  void reloadNotices(List<ClassNotice> list) {
    state = list;
  }
}

final classNoticesProvider =
    StateNotifierProvider<ClassNoticesNotifier, List<ClassNotice>?>(
  (ref) {
    return ClassNoticesNotifier();
  },
);
