import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:theater_of_the_web/services/models/marker_data.dart';

class MapData extends Equatable {
  final String url;
  final String name;
  final double imageScale;
  final double gridUnit;
  final DateTime createdOn;
  final bool selected;
  final List<MarkerData> markerList;

  const MapData(
      {required this.url,
      required this.name,
      required this.imageScale,
      required this.createdOn,
      required this.gridUnit,
      this.selected = true,
      this.markerList = const []});

  factory MapData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MapData(
      url: data?['url'],
      name: data?['name'],
      imageScale: data?['imageScale'],
      gridUnit: data?['gridUnit'],
      createdOn: DateTime.parse(data?['createdOn']),
      selected: data?['selected'] ?? false,
      markerList: (data?['markerList'] as List?)?.map((e) => MarkerData.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'url': url,
      'name': name,
      'imageScale': imageScale,
      'gridUnit': gridUnit,
      'createdOn': createdOn.toIso8601String(),
      'selected': selected,
      'markerList': markerList.map((e) => e.toFirestore()),
    };
  }

  MapData copyWith({String? name, double? imageScale, double? gridUnit, bool? selected, List<MarkerData>? markerList}) => MapData(
        url: url,
        name: name ?? this.name,
        imageScale: imageScale ?? this.imageScale,
        createdOn: createdOn,
        gridUnit: gridUnit ?? this.gridUnit,
        selected: selected ?? this.selected,
        markerList: markerList ?? this.markerList,
      );

  @override
  List<Object?> get props => [url, name, imageScale, gridUnit, createdOn, selected, markerList];
}

typedef MapSnapshotList = List<QueryDocumentSnapshot<MapData>>;
typedef MapSnapshot = QueryDocumentSnapshot<MapData>;
