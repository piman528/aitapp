import 'package:aitapp/application/state/map_shapes/mapshapes_provider.dart';
import 'package:aitapp/application/state/textfield_word/textfield_word_provider.dart';
import 'package:aitapp/application/usecases/search_building_usecase.dart';
import 'package:aitapp/domain/types/building.dart';
import 'package:aitapp/domain/types/building_room_list.dart';
import 'package:aitapp/infrastructure/database/db_helper.dart';
import 'package:aitapp/presentation/wighets/map_building_item.dart';
import 'package:aitapp/presentation/wighets/map_room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuildingInfoSheet extends HookConsumerWidget {
  const BuildingInfoSheet({super.key, required this.controller});
  final DraggableScrollableController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectBuildingint = ref.watch(mapShapesNotifierProvider);
    final typeWord = ref.watch(textfieldWordNotifierProvider);
    final selectBuilding = useState<Building?>(null);
    final usecase = useMemoized(SearchBuildingUsecase.new, []);
    final selectedFloor = useState<String?>(null);

    final searchFuture = useMemoized(
      () {
        return typeWord != ''
            ? usecase.searchBuildingRoom(typeWord)
            : Future<BuildingRoomList?>.value();
      },
      [typeWord],
    );

    final buildingRooms = useFuture(searchFuture);

    useEffect(
      () {
        if (selectBuildingint.selectedShapeId != null) {
          // 最初の選択された建物の情報を表示
          DatabaseHelper()
              .getBuildingById(selectBuildingint.selectedShapeId!)
              .then((building) {
            selectBuilding.value = building;
            if (building?.rooms?.isNotEmpty == true) {
              selectedFloor.value = building!.rooms!.keys.first;
            }
          });
        } else {
          selectBuilding.value = null;
          selectedFloor.value = null;
        }
        return null;
      },
      [selectBuildingint],
    );

    Widget buildHeader(String title, [String? subtitle]) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: 58,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      );
    }

    Widget buildFloorTabs(Map<String, dynamic> rooms) {
      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final floor = rooms.keys.elementAt(index);
            final isSelected = selectedFloor.value == floor;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => selectedFloor.value = floor,
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      floor,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    Widget buildRoomGrid(List<dynamic> rooms) {
      return GridView.builder(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Room tapped
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        room.roomName as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.meeting_room_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '教室',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    late final List<Widget> content;

    if (selectBuilding.value != null) {
      content = [
        buildHeader(
          selectBuilding.value!.name,
          '${selectBuilding.value!.rooms?.values.expand((rooms) => rooms).length ?? 0}部屋',
        ),
        const SizedBox(height: 8),
        if (selectBuilding.value!.rooms != null) ...[
          buildFloorTabs(selectBuilding.value!.rooms!),
          if (selectedFloor.value != null &&
              selectBuilding.value?.rooms?[selectedFloor.value] != null)
            buildRoomGrid(selectBuilding.value!.rooms![selectedFloor.value]!),
        ],
      ];
    } else if (typeWord != '') {
      content = [
        buildHeader('検索結果'),
        if (buildingRooms.hasData &&
            (buildingRooms.data!.buildings.isNotEmpty ||
                buildingRooms.data!.rooms.isNotEmpty)) ...{
          const SizedBox(height: 16),
          ...buildingRooms.data!.buildings
              .map((building) => BuildingItem(building: building)),
          ...buildingRooms.data!.rooms.map((room) => RoomItem(room: room)),
        } else if (buildingRooms.hasData) ...{
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  '検索結果が見つかりませんでした',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        } else if (buildingRooms.hasError) ...{
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text(
                  'エラーが発生しました',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        } else ...{
          const SizedBox(height: 24),
          const Center(
            child: CircularProgressIndicator(),
          ),
        },
        const SizedBox(height: 24),
      ];
    } else {
      content = [
        buildHeader('施設を検索'),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.search_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                '検索キーワードを入力してください',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return DraggableScrollableSheet(
      controller: controller,
      minChildSize: 0.15,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            children: content,
          ),
        );
      },
    );
  }
}
