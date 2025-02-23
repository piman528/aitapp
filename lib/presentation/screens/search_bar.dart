import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchBarWidget extends HookWidget {
  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.onSubmitted,
    this.focusNode,
    this.onSuffixIconPusshed,
  });
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  final void Function()? onSuffixIconPusshed;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final isEmpty = useState(controller.text.isEmpty);
    final isFocused = useState(false);

    useEffect(
      () {
        void listener() {
          isEmpty.value = controller.text.isEmpty;
        }

        controller.addListener(listener);
        return () {
          controller.removeListener(listener);
        };
      },
      [controller],
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isFocused.value
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: isFocused.value ? 2 : 0,
          ),
        ],
      ),
      child: Focus(
        onFocusChange: (focused) => isFocused.value = focused,
        child: TextField(
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          controller: controller,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Icon(
                Icons.search_rounded,
                color: isFocused.value
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            suffixIcon: !isEmpty.value
                ? AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      onPressed: () {
                        controller.clear();
                        if (onSuffixIconPusshed != null) {
                          onSuffixIconPusshed!();
                        }
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
