import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdPasswordNotifier extends StateNotifier<List<String>> {
  IdPasswordNotifier() : super(['', '']);

  void setIdPassword(String id, String password) {
    state = [id, password];
  }
}

final idPasswordProvider =
    StateNotifierProvider<IdPasswordNotifier, List<String>>(
  (ref) {
    return IdPasswordNotifier();
  },
);
