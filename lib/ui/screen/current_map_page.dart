import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:theater_of_the_web/services/providers/selected_map_bloc.dart';

import '../../services/models/map_data.dart';
import '../../services/providers/hover_cubit.dart';
import '../widgets/app_header.dart';
import '../widgets/battle_map.dart';

class CurrentMapPage extends StatelessWidget {
  const CurrentMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapSettingsCubit>(
      lazy: false,
      create: (context) => MapSettingsCubit(),
      child: BlocBuilder<SelectedMapBloc, MapSnapshot?>(
        builder: (context, state) => Scaffold(
          appBar: const AppHeader(),
          body: state != null ? const BattleMap() : emptyState(),
          floatingActionButton: state != null ? const MapFloatingTools() : null,
        ),
      ),
    );
  }

  Widget emptyState() => const Center(child: Text('Non hai ancora caricato nessuna mappa'));
}

class MapFloatingTools extends StatelessWidget {
  const MapFloatingTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          child: const FaIcon(FontAwesomeIcons.magnifyingGlassPlus),
          onPressed: () {
            context.read<MapSettingsCubit>().setZoom(0.1);
          },
        ),
        const SizedBox(height: 12),
        FloatingActionButton.small(
          child: const FaIcon(FontAwesomeIcons.magnifyingGlassMinus),
          onPressed: () {
            context.read<MapSettingsCubit>().setZoom(-0.1);
          },
        ),
        //SizedBox(height: 12),
        //TODO alert to edit scale + other things about maps
        // FloatingActionButton(
        //   child: FaIcon(FontAwesomeIcons.gear),
        //   onPressed: () {},
        // ),
      ],
    );
  }
}
