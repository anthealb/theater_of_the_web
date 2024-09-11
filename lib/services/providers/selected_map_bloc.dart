import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theater_of_the_web/services/models/character.dart';
import 'package:theater_of_the_web/services/models/map_data.dart';
import 'package:theater_of_the_web/services/models/marker_data.dart';

import '../repository/map_repository.dart';
import 'character_creation_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class FetchSelectedMapEvent extends MapEvent {}

class ChangeGridSizeEvent extends MapEvent {
  final double change;
  const ChangeGridSizeEvent(this.change);

  @override
  List<Object?> get props => [change];
}

class AddMarkerEvent extends MapEvent {
  final DocumentReference<Character> ref;
  const AddMarkerEvent(this.ref);

  @override
  List<Object?> get props => [ref];
}

class RemoveMarkerEvent extends MapEvent {
  final DocumentReference<Character> ref;
  const RemoveMarkerEvent(this.ref);

  @override
  List<Object?> get props => [ref];
}

class EditMarkerEvent extends MapEvent {
  final DocumentReference<Character> ref;
  final double xMovement;
  final double yMovement;
  final HealthState? healthState;
  const EditMarkerEvent({required this.ref, this.xMovement = 0, this.yMovement = 0, this.healthState});

  @override
  List<Object?> get props => [ref];
}

class SelectedMapBloc extends Bloc<MapEvent, MapSnapshot?> {
  final MapRepository repository;
  final CharacterCreationBloc listeningBloc;
  late final StreamSubscription _streamSubscription;

  SelectedMapBloc({required this.repository, required this.listeningBloc}) : super(null) {
    _streamSubscription = listeningBloc.stream.listen((event) => event != null ? add(event) : null);
    on<FetchSelectedMapEvent>(fetchMap);
    on<ChangeGridSizeEvent>(changeGridSize);
    on<AddMarkerEvent>(addMarker);
    on<EditMarkerEvent>(editMarker);
    on<RemoveMarkerEvent>(removeMarker);
  }

  void fetchMap(MapEvent event, Emitter<MapSnapshot?> emit) async {
    await emit.forEach<MapSnapshot?>(
      repository.getSelectedMap(),
      onData: (snapshot) => snapshot,
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state;
      },
    );
  }

  void changeGridSize(ChangeGridSizeEvent event, Emitter<MapSnapshot?> emit) async {
    try {
      if (state == null) throw Exception('No map selected');
      repository.editMap(state!.id, state!.data().copyWith(gridUnit: state!.data().gridUnit + event.change));
    } catch (e, st) {
      addError(e, st);
    }
  }

  void addMarker(AddMarkerEvent event, Emitter<MapSnapshot?> emit) async {
    try {
      if (state == null) throw Exception('No map selected');
      if (state!.data().markerList.any((marker) => marker.characterRef.id == event.ref.id)) throw Exception('Marker already added');
      repository.editMap(state!.id, state!.data().copyWith(markerList: [...state!.data().markerList, MarkerData(characterRef: event.ref)]));
    } catch (e, st) {
      addError(e, st);
    }
  }

  void editMarker(EditMarkerEvent event, Emitter<MapSnapshot?> emit) async {
    try {
      if (state == null) throw Exception('No map selected');
      final markerIndex = state!.data().markerList.indexWhere((marker) => marker.characterRef.id == event.ref.id);
      if (markerIndex != -1) {
        final newList = List<MarkerData>.from(state!.data().markerList);
        final markerToEdit = newList.removeAt(markerIndex);
        newList.insert(markerIndex,
            markerToEdit.copyWith(xPos: markerToEdit.xPos + event.xMovement, yPos: markerToEdit.yPos + event.yMovement, healthState: event.healthState));
        repository.editMap(state!.id, state!.data().copyWith(markerList: newList));
      } else {
        throw Exception('Marker not found');
      }
    } catch (e, st) {
      addError(e, st);
    }
  }

  void removeMarker(RemoveMarkerEvent event, Emitter<MapSnapshot?> emit) async {
    try {
      if (state == null) throw Exception('No map selected');
      final newList = List<MarkerData>.from(state!.data().markerList);
      newList.removeWhere((marker) => marker.characterRef.id == event.ref.id);
      repository.editMap(state!.id, state!.data().copyWith(markerList: newList));
    } catch (e, st) {
      addError(e, st);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
