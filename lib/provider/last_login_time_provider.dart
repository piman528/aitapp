import 'package:aitapp/provider/link_tap_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LastLoginTimeNotifier extends StateNotifier<DateTime?>
    with WidgetsBindingObserver {
  LastLoginTimeNotifier({required this.ref}) : super(null) {
    WidgetsBinding.instance.addObserver(this);
  }
  final StateNotifierProviderRef<LastLoginTimeNotifier, DateTime?> ref;
  void updateLastLoginTime() {
    state = DateTime.now();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    super.didChangeAppLifecycleState(state);
    if (this.state != null &&
        state == AppLifecycleState.resumed &&
        (DateTime.now().difference(this.state!) >=
                const Duration(minutes: 10) ||
            ref.read(linkTapProvider))) {
      this.state = DateTime.now();
      ref.read(linkTapProvider.notifier).state = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

final lastLoginTimeProvider =
    StateNotifierProvider<LastLoginTimeNotifier, DateTime?>(
  (ref) {
    return LastLoginTimeNotifier(ref: ref);
  },
);
