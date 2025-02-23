import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'textfield_word_provider.g.dart';

@riverpod
class TextfieldWordNotifier extends _$TextfieldWordNotifier {
  @override
  String build() {
    return '';
  }

  void clear() {
    state = '';
  }

  void set(String word) {
    state = word;
  }
}
