import 'package:aitapp/models/univ_notice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnivNoticesNotifier extends StateNotifier<List<UnivNotice>?> {
  UnivNoticesNotifier() : super(null);

  void reloadNotices(List<UnivNotice> list) {
    state = list;
  }
}

final univNoticesProvider =
    StateNotifierProvider<UnivNoticesNotifier, List<UnivNotice>?>(
  (ref) {
    return UnivNoticesNotifier();
  },
);
