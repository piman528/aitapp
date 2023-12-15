import 'package:aitapp/models/class_notice.dart';
import 'package:aitapp/models/get_notice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassNoticesNotifier
    extends StateNotifier<AsyncValue<List<ClassNotice>>> {
  ClassNoticesNotifier() : super(const AsyncValue.loading());

  Future<void> reloadNotices(
    GetNotice getNotice,
    Future<void> create,
  ) async {
    await create;
    try {
      final result = await getNotice.getClassNoticelist();
      state = AsyncValue.data(result);
    } on Exception catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}

final classNoticesProvider =
    StateNotifierProvider<ClassNoticesNotifier, AsyncValue<List<ClassNotice>>>(
  (ref) {
    return ClassNoticesNotifier();
  },
);
