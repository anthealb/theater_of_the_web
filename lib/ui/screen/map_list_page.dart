import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../services/providers/hover_cubit.dart';
import '../../services/providers/map_list_bloc.dart';
import '../widgets/app_header.dart';

class MapListPage extends StatelessWidget {
  static const String routeName = '/history';
  const MapListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text('Esplora la cronologia delle mappe...', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 180),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: context.watch<MapListBloc>().state.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => MouseRegion(
                        onEnter: (_) {
                          context.read<PreviewCubit>().setPreview(context.read<MapListBloc>().state[index].data().url);
                        },
                        onExit: (event) {
                          context.read<PreviewCubit>().setPreview(null);
                        },
                        child: ListTile(
                          title: Text(context.watch<MapListBloc>().state[index].data().name),
                          subtitle:
                              Text('Creato il ${DateFormat('d MMM y, HH:mm', 'it_IT').format(context.watch<MapListBloc>().state[index].data().createdOn)}'),
                          trailing: (context.watch<PreviewCubit>().state == context.watch<MapListBloc>().state[index].data().url)
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const FaIcon(FontAwesomeIcons.solidPenToSquare),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<MapListBloc>().add(DeleteMapEvent(context.read<MapListBloc>().state[index].id));
                                      },
                                      icon: const FaIcon(FontAwesomeIcons.trash),
                                    ),
                                  ],
                                )
                              : null,
                          onTap: () {
                            context.read<MapListBloc>().add(AddMapEvent());
                          }, //go to
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Theme.of(context).cardColor, width: 16, strokeAlign: BorderSide.strokeAlignOutside),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        context.watch<PreviewCubit>().state ?? '',
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, _) => Container(),
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.plus),
        onPressed: () {
          print('pressed');
        },
      ),
    );
  }
}
