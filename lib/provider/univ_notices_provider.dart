import 'package:aitapp/models/get_notice.dart';
import 'package:aitapp/models/univ_notice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnivNoticesNotifier extends StateNotifier<AsyncValue<List<UnivNotice>>> {
  UnivNoticesNotifier() : super(const AsyncValue.loading());

  Future<void> fetchData() async {
    final getNotice = GetNotice();
    await getNotice.create();
    state = const AsyncValue.loading();
    try {
      final result = await getNotice.getUnivNoticelist();
      state = AsyncValue.data(result);
    } on Exception catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<void> reloadData() async {
    final getNotice = GetNotice();
    await getNotice.create();
    try {
      final result = await getNotice.getUnivNoticelist();
      state = AsyncValue.data(result);
    } on Exception catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}

final univNoticesProvider =
    StateNotifierProvider<UnivNoticesNotifier, AsyncValue<List<UnivNotice>>>(
  (ref) {
    return UnivNoticesNotifier();
  },
);
