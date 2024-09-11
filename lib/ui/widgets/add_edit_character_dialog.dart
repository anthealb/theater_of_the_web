import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../services/models/character.dart';
import '../../services/providers/selected_map_bloc.dart';
import '../../services/providers/character_list_bloc.dart';
import 'reactive_color_picker.dart';

class AddOrEditCharacterDialog extends StatelessWidget {
  final DocumentReference<Character>? characterRef;
  const AddOrEditCharacterDialog({this.characterRef, super.key});

  @override
  Widget build(BuildContext context) {
    final marker = context.watch<SelectedMapBloc>().state?.data().markerList.firstWhereOrNull((marker) => marker.characterRef.id == characterRef?.id);
    final character = context.watch<CharacterListBloc>().state.firstWhereOrNull((character) => character.id == characterRef?.id)?.data();
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: ReactiveFormBuilder(
          form: () => FormGroup({
            'name': FormControl<String>(value: character?.name, validators: [Validators.required]),
            'pc': FormControl<bool>(value: character?.isPC ?? false, validators: [Validators.required]),
            'color': FormControl<Color?>(value: character?.color, validators: [Validators.required]),
          }),
          builder: (context, formGroup, child) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                marker == null ? 'Crea nuovo personaggio' : 'Modifica il personaggio',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ReactiveTextField(
                formControlName: 'name',
                decoration: const InputDecoration(label: Text('Nome'), floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 12),
              ReactiveSwitchListTile(
                formControlName: 'pc',
                contentPadding: EdgeInsets.zero,
                title: Text('Player Character?', style: Theme.of(context).textTheme.labelSmall),
              ),
              const SizedBox(height: 12),
              const ReactiveColorPicker(formControlName: 'color'),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    formGroup.markAllAsTouched();
                    if (formGroup.hasErrors) return;
                    final newChar = Character.fromJson(formGroup.value);
                    if (characterRef == null) {
                      context.read<CharacterListBloc>().add(AddCharacterEvent(newChar));
                    } else {
                      context.read<CharacterListBloc>().add(EditCharacterEvent(characterRef!.id, Character.fromJson(formGroup.value)));
                    }
                    Navigator.of(context).pop();
                  },
                  child: marker == null ? const Text('Aggiungi') : const Text('Modifica'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDialogWithProviders(BuildContext context) => showDialog(
        context: context,
        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<SelectedMapBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CharacterListBloc>(context)),
          ],
          child: this,
        ),
      );
}
