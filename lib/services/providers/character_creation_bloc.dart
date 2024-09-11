import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theater_of_the_web/services/models/character.dart';

import 'selected_map_bloc.dart';

sealed class CharacterCreationEvent extends Equatable {
  const CharacterCreationEvent();

  @override
  List<Object?> get props => [];
}

class CharacterAddedEvent extends CharacterCreationEvent {
  final DocumentReference<Character> ref;
  const CharacterAddedEvent(this.ref);

  @override
  List<Object?> get props => [ref];
}

class CharacterDeletedEvent extends CharacterCreationEvent {
  final String id;
  const CharacterDeletedEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CharacterCreationBloc extends Bloc<CharacterCreationEvent, MapEvent?> {
  CharacterCreationBloc() : super(null) {
    on<CharacterAddedEvent>((event, emit) => emit(AddMarkerEvent(event.ref)));
    // on<CharacterDeletedEvent>((event, emit) => emit(AddRemoveMarkerToMapEvent(event.id)));
  }
}
