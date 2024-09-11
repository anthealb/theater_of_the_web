import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/characters_repository.dart';
import '../models/character.dart';
import 'character_creation_bloc.dart';

sealed class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

class FecthCharactersEvent extends CharacterEvent {}

class AddCharacterEvent extends CharacterEvent {
  final Character character;
  const AddCharacterEvent(this.character);

  @override
  List<Object?> get props => [character];
}

class EditCharacterEvent extends CharacterEvent {
  final String id;
  final Character character;
  const EditCharacterEvent(this.id, this.character);

  @override
  List<Object?> get props => [character];
}

class CharacterListBloc extends Bloc<CharacterEvent, CharacterSnapshotList> {
  final CharactersRepository repository;
  final CharacterCreationBloc listeningBloc;

  CharacterListBloc({required this.repository, required this.listeningBloc}) : super([]) {
    on<FecthCharactersEvent>(fetchCharacters);
    on<AddCharacterEvent>(addCharacter);
    on<EditCharacterEvent>(editCharacter);
  }

  void fetchCharacters(CharacterEvent event, Emitter<CharacterSnapshotList> emit) async {
    await emit.forEach<CharacterSnapshotList>(
      repository.getCharacterList(),
      onData: (list) => list,
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state;
      },
    );
  }

  void addCharacter(AddCharacterEvent event, Emitter<CharacterSnapshotList> emit) async {
    try {
      final id = await repository.addCharacter(event.character);
      listeningBloc.add(CharacterAddedEvent(id));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void editCharacter(EditCharacterEvent event, Emitter<CharacterSnapshotList> emit) async {
    try {
      await repository.editCharacter(event.id, event.character);
      // listeningBloc.add(CharacterAddedEvent(id));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
