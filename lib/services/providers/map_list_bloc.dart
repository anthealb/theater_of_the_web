import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theater_of_the_web/services/models/map_data.dart';
import 'package:theater_of_the_web/services/repository/map_repository.dart';

sealed class MapListEvent extends Equatable {
  const MapListEvent();

  @override
  List<Object?> get props => [];
}

class FecthMapsEvent extends MapListEvent {}

class AddMapEvent extends MapListEvent {}

class SelectMapEvent extends MapListEvent {
  final String id;
  const SelectMapEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteMapEvent extends MapListEvent {
  final String id;
  const DeleteMapEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MapListBloc extends Bloc<MapListEvent, MapSnapshotList> {
  final MapRepository repository;

  MapListBloc({required this.repository}) : super([]) {
    on<FecthMapsEvent>(fetchMaps);
    on<AddMapEvent>(addMap);
    on<DeleteMapEvent>(deleteMap);
    on<SelectMapEvent>(selectMap);
  }

  void fetchMaps(MapListEvent event, Emitter<MapSnapshotList> emit) async {
    await emit.forEach<MapSnapshotList>(
      repository.getMapList(),
      onData: (snapshot) => snapshot,
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state;
      },
    );
  }

  void addMap(AddMapEvent event, Emitter<MapSnapshotList> emit) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes == null) return;
      String fileName = result.files.first.name;

      try {
        final task = await FirebaseStorage.instance.ref().child('maps/$fileName').putData(fileBytes, SettableMetadata(contentType: "image/jpeg"));
        final url = await task.ref.getDownloadURL();
        final newMap = MapData(url: url, name: fileName, imageScale: 1, createdOn: DateTime.timestamp(), gridUnit: 50);
        for (var map in state) {
          repository.editMap(map.id, map.data().copyWith(selected: false));
        }
        repository.addMap(newMap);
      } catch (e, st) {
        addError(e, st);
      }
    }
  }

  void selectMap(SelectMapEvent event, Emitter<MapSnapshotList> emit) async {
    MapData? mapDataToEdit;
    for (var map in state) {
      if (map.id == event.id) {
        mapDataToEdit = map.data();
      } else if (map.data().selected) {
        repository.editMap(map.id, map.data().copyWith(selected: false));
      }
    }
    if (mapDataToEdit == null) {
      addError(Exception('Map not found'), StackTrace.current);
      return;
    }
    try {
      repository.editMap(event.id, mapDataToEdit.copyWith(selected: true));
    } catch (e, st) {
      addError(e, st);
    }
  }

  void deleteMap(DeleteMapEvent event, Emitter<MapSnapshotList> emit) async {
    try {
      repository.delete(event.id);
    } catch (e, st) {
      addError(e, st);
    }
  }
}
