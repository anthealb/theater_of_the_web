import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'services/providers/character_list_bloc.dart';
import 'services/providers/character_creation_bloc.dart';
import 'services/providers/show_grid_cubit.dart';
import 'services/providers/map_list_bloc.dart';
import 'services/repository/characters_repository.dart';
import 'services/repository/map_repository.dart';
import 'ui/screen/current_map_page.dart';
import 'constants/theming.dart';
import 'firebase_options.dart';
import 'services/providers/bloc_observer.dart';
import 'services/providers/hover_cubit.dart';
import 'services/providers/selected_map_bloc.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final creationListener = CharacterCreationBloc();
  final mapRepository = MapRepository();
  @override
  void initState() {
    BrowserContextMenu.disableContextMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theming.themeData,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MapListBloc(repository: mapRepository)..add(FecthMapsEvent()),
          ),
          BlocProvider(
            create: (context) => SelectedMapBloc(repository: mapRepository, listeningBloc: creationListener)..add(FetchSelectedMapEvent()),
          ),
          BlocProvider(
            create: (context) => PreviewCubit(),
          ),
          BlocProvider(
            create: (context) => ShowGridCubit(),
          ),
          BlocProvider(
            create: (context) => CharacterListBloc(listeningBloc: creationListener, repository: CharactersRepository())..add(FecthCharactersEvent()),
          ),
        ],
        child: GestureDetector(
          onTap: () => ContextMenuController.removeAny(),
          child: const CurrentMapPage(),
        ),
      ),
    );
  }
}
