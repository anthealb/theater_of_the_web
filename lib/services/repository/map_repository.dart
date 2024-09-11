import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/map_data.dart';

//TODO separate map list from currently selected map
class MapRepository {
  MapRepository();

  final db = FirebaseFirestore.instance
      .collection('maps')
      .withConverter<MapData>(fromFirestore: MapData.fromFirestore, toFirestore: (character, options) => character.toFirestore());

  Stream<MapSnapshotList> getMapList() => db.orderBy('createdOn', descending: true).snapshots().asyncMap((event) => event.docs).asBroadcastStream();
  Stream<MapSnapshot?> getSelectedMap() => db.where('selected', isEqualTo: true).snapshots().asyncMap((event) => event.docs.firstOrNull).asBroadcastStream();

  Future<void> addMap(MapData data) async {
    await db.add(data);
  }

  Future<void> editMap(String id, MapData data) async {
    await db.doc(id).update(data.toFirestore());
  }

  Future<void> delete(String id) async {
    final mapToDelete = await db.doc('id').get();
    if (mapToDelete.data()?.url != null) {
      final imgRef = FirebaseStorage.instance.refFromURL(mapToDelete.data()!.url);
      await imgRef.delete();
    }
    await db.doc(id).delete();
  }
}
