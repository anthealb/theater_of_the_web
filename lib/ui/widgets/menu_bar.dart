import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:theater_of_the_web/services/providers/character_list_bloc.dart';
import 'package:theater_of_the_web/services/providers/map_list_bloc.dart';
import 'package:theater_of_the_web/services/providers/selected_map_bloc.dart';

import '../../services/models/character.dart';
import '../../services/providers/show_grid_cubit.dart';
import 'add_edit_character_dialog.dart';
import 'reactive_color_picker.dart';

class MapMenuBar extends StatelessWidget {
  const MapMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      children: [
        if (context.watch<SelectedMapBloc>().state == null)
          // SubmenuButton(
          //   menuChildren: [
          MenuItemButton(
            // trailingIcon: const FaIcon(FontAwesomeIcons.upload),

            //child: const Text('Carica una mappa'),
            onPressed: () => context.read<MapListBloc>().add(AddMapEvent()),
            // ),
            //   MenuItemButton(
            //       trailingIcon: const FaIcon(FontAwesomeIcons.clockRotateLeft),
            //       child: const Text('Scegli dallo storico'),
            //       onPressed: () {} //TODO naviga allo storico,
            //       ),
            // ],
            trailingIcon: const FaIcon(FontAwesomeIcons.solidMap),
            child: const Text('Mostra una mappa'),
          ),
        if (context.watch<SelectedMapBloc>().state != null) ...[
          MenuItemButton(
            trailingIcon: const FaIcon(FontAwesomeIcons.rotate),
            child: const Text('Sostituisci mappa'),
            onPressed: () => context.read<MapListBloc>().add(AddMapEvent()),
          ),
          SubmenuButton(
            trailingIcon: context.watch<ShowGridCubit>().state ? const FaIcon(FontAwesomeIcons.borderAll) : const FaIcon(FontAwesomeIcons.borderNone),
            menuChildren: [
              MenuItemButton(
                onPressed: () => context.read<ShowGridCubit>().toggle(),
                trailingIcon: context.watch<ShowGridCubit>().state ? const FaIcon(FontAwesomeIcons.solidEyeSlash) : const FaIcon(FontAwesomeIcons.solidEye),
                child: context.watch<ShowGridCubit>().state ? const Text('Nascondi') : const Text('Mostra'),
              ),
              MenuItemButton(
                onPressed: context.watch<ShowGridCubit>().state ? () => context.read<SelectedMapBloc>().add(const ChangeGridSizeEvent(10)) : null,
                trailingIcon: const FaIcon(FontAwesomeIcons.plus),
                child: const Text('Aumenta dimensioni'),
              ),
              MenuItemButton(
                onPressed: context.watch<ShowGridCubit>().state && context.watch<SelectedMapBloc>().state!.data().gridUnit > 30
                    ? () => context.read<SelectedMapBloc>().add(const ChangeGridSizeEvent(-10))
                    : null,
                trailingIcon: const FaIcon(FontAwesomeIcons.minus),
                child: const Text('Riduci dimensioni'),
              ),
            ],
            child: const Text('Griglia'),
          ),
          SubmenuButton(
            trailingIcon: const FaIcon(FontAwesomeIcons.users),
            menuChildren: [
              MenuItemButton(
                trailingIcon: const FaIcon(FontAwesomeIcons.plus),
                child: const Text('Crea nuovo'),
                onPressed: () => const AddOrEditCharacterDialog().showDialogWithProviders(context),
              ),
              SubmenuButton(
                menuChildren: context
                    .watch<CharacterListBloc>()
                    .state
                    .map(
                      (c) => MenuItemButton(
                        child: Text(c.data().name),
                        onPressed: () => context.read<SelectedMapBloc>().add(AddMarkerEvent(c.reference)),
                      ),
                    )
                    .toList(),
                child: const Text('Aggiungi da lista'),
              ),
            ],
            child: const Text('Personaggi'),
          ),
        ],
      ],
    );
  }
}
