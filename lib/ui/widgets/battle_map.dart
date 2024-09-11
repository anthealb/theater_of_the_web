import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:theater_of_the_web/services/models/marker_data.dart';
import 'package:theater_of_the_web/services/providers/character_list_bloc.dart';
import 'package:theater_of_the_web/services/providers/selected_map_bloc.dart';
import 'package:theater_of_the_web/ui/widgets/add_edit_character_dialog.dart';

import '../../services/providers/hover_cubit.dart';
import '../../services/providers/show_grid_cubit.dart';

class BattleMap extends StatelessWidget {
  const BattleMap({super.key});

  @override
  Widget build(BuildContext context) {
    final map = context.watch<SelectedMapBloc>().state!;
    final gridIsShown = context.watch<ShowGridCubit>().state;
    return InteractiveViewer(
      scaleEnabled: false,
      constrained: false,
      alignment: Alignment(-1, -1 * context.watch<MapSettingsCubit>().state.zoom),
      boundaryMargin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width - 10,
        bottom: MediaQuery.of(context).size.width - 100,
      ),
      transformationController: TransformationController(Matrix4.identity()
        ..scale(context.watch<MapSettingsCubit>().state.zoom, context.watch<MapSettingsCubit>().state.zoom, context.watch<MapSettingsCubit>().state.zoom)),
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height - 40,
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            gridIsShown
                ? GridPaper(
                    divisions: 1,
                    subdivisions: 1,
                    interval: map.data().gridUnit,
                    child: Image.network(map.data().url, fit: BoxFit.none, scale: map.data().imageScale),
                  )
                : Image.network(map.data().url, fit: BoxFit.none, scale: map.data().imageScale),
            ...map.data().markerList.map(
                  (m) => Positioned(
                      top: (m.yPos * map.data().gridUnit) - map.data().gridUnit * 0.55,
                      left: (m.xPos * map.data().gridUnit) - map.data().gridUnit * 0.55,
                      child: PcMarkerWidget(marker: m)),
                )
          ],
        ),
      ),
    );
  }
}

class PcMarkerWidget extends StatelessWidget {
  final MarkerData marker;
  const PcMarkerWidget({required this.marker, super.key});

  @override
  Widget build(BuildContext context) {
    final map = context.watch<SelectedMapBloc>().state!;
    final char = context.watch<CharacterListBloc>().state.firstWhereOrNull((c) => c.id == marker.characterRef.id);
    if (char == null) return Container();
    return MouseRegion(
      onEnter: (event) => context.read<MapSettingsCubit>().setHover(marker.characterRef.id),
      onExit: (event) => context.read<MapSettingsCubit>().setHover(null),
      child: GestureDetector(
        onSecondaryTapDown: (details) => showContextMenu(context, marker, details),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(map.data().gridUnit * 0.55),
              height: map.data().gridUnit,
              width: map.data().gridUnit,
              decoration: BoxDecoration(shape: BoxShape.circle, color: char.data().color),
              alignment: Alignment.center,
              child: showHealthState(marker.healthState, map.data().gridUnit * 0.5, ThemeData.estimateBrightnessForColor(char.data().color)),
            ),
            if (context.watch<MapSettingsCubit>().state.hovered == marker.characterRef.id) ...[
              Positioned(
                bottom: map.data().gridUnit * 0.5,
                left: map.data().gridUnit * 0.5,
                right: map.data().gridUnit * 0.5,
                child: Card(
                  color: Colors.white54,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FittedBox(child: Text(char.data().name, maxLines: 1, overflow: TextOverflow.clip)),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: map.data().gridUnit * 0.55,
                right: map.data().gridUnit * 0.55,
                child: MaterialButton(
                  minWidth: map.data().gridUnit * 0.75,
                  height: map.data().gridUnit * 0.7,
                  visualDensity: VisualDensity.compact,
                  color: Colors.white54,
                  child: FaIcon(FontAwesomeIcons.chevronUp, size: map.data().gridUnit * 0.3),
                  onPressed: () {
                    context.read<SelectedMapBloc>().add(EditMarkerEvent(ref: marker.characterRef, yMovement: -1));
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: map.data().gridUnit * 0.55,
                right: map.data().gridUnit * 0.55,
                child: MaterialButton(
                  minWidth: map.data().gridUnit * 0.75,
                  height: map.data().gridUnit * 0.7,
                  visualDensity: VisualDensity.compact,
                  color: Colors.white54,
                  child: FaIcon(FontAwesomeIcons.chevronDown, size: map.data().gridUnit * 0.3),
                  onPressed: () {
                    context.read<SelectedMapBloc>().add(EditMarkerEvent(ref: marker.characterRef, yMovement: 1));
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: map.data().gridUnit * 0.55,
                bottom: map.data().gridUnit * 0.55,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: MaterialButton(
                    minWidth: map.data().gridUnit * 0.75,
                    height: map.data().gridUnit * 0.7,
                    visualDensity: VisualDensity.compact,
                    color: Colors.white54,
                    child: FaIcon(FontAwesomeIcons.chevronUp, size: map.data().gridUnit * 0.3),
                    onPressed: () {
                      context.read<SelectedMapBloc>().add(EditMarkerEvent(ref: marker.characterRef, xMovement: 1));
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: map.data().gridUnit * 0.55,
                bottom: map.data().gridUnit * 0.55,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: MaterialButton(
                    minWidth: map.data().gridUnit * 0.75,
                    height: map.data().gridUnit * 0.7,
                    visualDensity: VisualDensity.compact,
                    color: Colors.white54,
                    child: FaIcon(FontAwesomeIcons.chevronDown, size: map.data().gridUnit * 0.3),
                    onPressed: () {
                      context.read<SelectedMapBloc>().add(EditMarkerEvent(ref: marker.characterRef, xMovement: -1));
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? showHealthState(HealthState state, double size, Brightness backgroundBrightness) {
    switch (state) {
      case HealthState.dead:
        return FaIcon(FontAwesomeIcons.skull,
            size: size, color: backgroundBrightness == Brightness.dark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5));
      case HealthState.ko:
        return FaIcon(FontAwesomeIcons.heartPulse,
            size: size, color: backgroundBrightness == Brightness.dark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5));
      default:
        return null;
    }
  }

  void showContextMenu(BuildContext context, MarkerData marker, TapDownDetails details) {
    final char = context.read<CharacterListBloc>().state.firstWhereOrNull((c) => c.id == marker.characterRef.id);
    if (char == null) return;
    ContextMenuController().show(
      context: context,
      contextMenuBuilder: (ctx) => AdaptiveTextSelectionToolbar.buttonItems(
        anchors: TextSelectionToolbarAnchors(primaryAnchor: details.globalPosition),
        buttonItems: <ContextMenuButtonItem>[
          if (char.data().isPC && marker.healthState.index < HealthState.ko.index)
            ContextMenuButtonItem(
              onPressed: () {
                context.read<SelectedMapBloc>().add(EditMarkerEvent(ref: marker.characterRef, healthState: HealthState.ko));
                ContextMenuController.removeAny();
              },
              label: 'Segna come KO',
            ),
          if (!char.data().isPC || marker.healthState == HealthState.ko)
            ContextMenuButtonItem(
              onPressed: () {
                context.read<SelectedMapBloc>().add(EditMarkerEvent(ref: marker.characterRef, healthState: HealthState.dead));
                ContextMenuController.removeAny();
              },
              label: 'Segna come morto',
            ),
          if (marker.healthState != HealthState.healthy)
            ContextMenuButtonItem(
              onPressed: () {
                context.read<SelectedMapBloc>().add(EditMarkerEvent(ref: marker.characterRef, healthState: HealthState.healthy));
                ContextMenuController.removeAny();
              },
              label: 'Segna come in salute',
            ),
          ContextMenuButtonItem(
            onPressed: () {
              ContextMenuController.removeAny();
              AddOrEditCharacterDialog(characterRef: char.reference).showDialogWithProviders(context);
            },
            label: 'Modifica',
          ),
          ContextMenuButtonItem(
            onPressed: () {
              context.read<SelectedMapBloc>().add(RemoveMarkerEvent(marker.characterRef));
              ContextMenuController.removeAny();
            },
            label: 'Rimuovi',
          ),
        ],
      ),
    );
  }
}
