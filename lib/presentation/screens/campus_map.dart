import 'package:aitapp/application/state/map_shapes/mapshapes_provider.dart';
import 'package:aitapp/application/state/textfield_word/textfield_word_provider.dart';
import 'package:aitapp/presentation/wighets/map_body.dart';
import 'package:aitapp/presentation/wighets/map_info_sheet.dart';
import 'package:aitapp/presentation/wighets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CampusMap extends HookConsumerWidget {
  const CampusMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(DraggableScrollableController.new);
    final textController = useTextEditingController();

    final initialMatrix = useMemoized(
      () => Matrix4.translationValues(-250, -800, 0).scaled(2.6),
    );
    final transformationController = useMemoized(
      () => TransformationController(initialMatrix),
    );

    final pixel = useState<double>(200);
    final previousScale = useRef<double>(initialMatrix.getMaxScaleOnAxis());
    final currentScale = useState<double>(previousScale.value);
    final controllerReset = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );
    Animation<Matrix4>? animationReset;

    void onAnimateReset() {
      transformationController.value = animationReset!.value;
      if (!controllerReset.isAnimating) {
        animationReset!.removeListener(onAnimateReset);
        animationReset = null;
        controllerReset.reset();
      }
    }

    void onTransformChanged() {
      final currentScale = transformationController.value.getMaxScaleOnAxis();
      if (previousScale.value != currentScale) {
        previousScale.value = currentScale;
      }
    }

    void textOnChange() {
      ref.read(textfieldWordNotifierProvider.notifier).set(textController.text);
    }

    useEffect(
      () {
        controller.addListener(() {
          pixel.value = controller.pixels + 10;
        });
        textController.addListener(textOnChange);
        transformationController.addListener(onTransformChanged);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(mapShapesNotifierProvider.notifier).selectShape(null);
          pixel.value = controller.pixels + 10;
        });
        return null;
      },
      [],
    );

    void bottomSheetSizeInitialize(double size) {
      controller.animateTo(
        size,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    }

    void animateResetInitialize(Matrix4 destination) {
      if (!controllerReset.isAnimating) {
        controllerReset.reset();
        animationReset = Matrix4Tween(
          begin: transformationController.value,
          end: destination,
        ).chain(CurveTween(curve: Curves.easeInOut)).animate(controllerReset);
        animationReset!.addListener(onAnimateReset);
        controllerReset.forward();
        bottomSheetSizeInitialize(0.45);
      }
    }

    ref.listen(mapShapesNotifierProvider, (previous, next) {
      final selectedShapes = next.getSelectedShapes();
      if (selectedShapes.isNotEmpty) {
        // 最初の選択された建物のバウンドを使用
        final bounds = selectedShapes.first.transformedPath!.getBounds();
        // 選択された建物が複数ある場合は、全ての建物のバウンドを合成
        for (var i = 1; i < selectedShapes.length; i++) {
          bounds
              .expandToInclude(selectedShapes[i].transformedPath!.getBounds());
        }
        final centerX = bounds.left + bounds.width / 2;
        final centerY = bounds.top + bounds.height / 2;
        final scale = (100 / bounds.width + 100 / bounds.height) / 2;
        animateResetInitialize(
          Matrix4.translationValues(
            -centerX * scale + 200,
            -centerY * scale + 250,
            0,
          ).scaled(scale),
        );
      }
    });

    // キーボードの表示状態を監視
    useEffect(
      () {
        final observer = _KeyboardVisibilityObserver(
          ({required bool visible}) {
            if (visible) {
              bottomSheetSizeInitialize(0.8); // キーボード表示時にシートを広げる
            }
          },
          context,
        );
        WidgetsBinding.instance.addObserver(observer);
        return () => WidgetsBinding.instance.removeObserver(observer);
      },
      [],
    );

    Widget buildFloatingActionButton({
      required VoidCallback onPressed,
      required IconData icon,
      EdgeInsetsGeometry? margin,
    }) {
      return Container(
        margin: margin,
        child: FloatingActionButton(
          heroTag: null,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            transformationController: transformationController,
            maxScale: 15,
            minScale: 2,
            child: SVGMap(
              scale: currentScale.value,
            ),
          ),
          // 戻るボタンとサーチバー
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                buildFloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.arrow_back_rounded,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Hero(
                    tag: 'searchBar',
                    child: SearchBarWidget(
                      hintText: '施設を検索',
                      controller: textController,
                      onSubmitted: (_) {
                        ref
                            .read(mapShapesNotifierProvider.notifier)
                            .selectShape(null);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ホームボタン
          Positioned(
            right: 16,
            bottom: pixel.value,
            child: buildFloatingActionButton(
              onPressed: () {
                ref.read(mapShapesNotifierProvider.notifier).selectShape(null);
                animateResetInitialize(initialMatrix);
              },
              icon: Icons.home_rounded,
            ),
          ),
          // 情報シート
          Positioned(
            child: BuildingInfoSheet(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyboardVisibilityObserver with WidgetsBindingObserver {
  _KeyboardVisibilityObserver(this.onChange, this.context);
  final void Function({required bool visible}) onChange;
  final BuildContext context;

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    onChange(visible: bottomInset > 0);
  }
}
