import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/character.dart';

class CharactersRepository {
  CharactersRepository();

  final db = FirebaseFirestore.instance
      .collection('characters')
      .withConverter<Character>(fromFirestore: Character.fromFirestore, toFirestore: (character, options) => character.toFirestore());

  Stream<CharacterSnapshotList> getCharacterList() => db.snapshots().asyncMap((event) => event.docs).asBroadcastStream();
  Future<DocumentReference<Character>> addCharacter(Character data) async {
    return await db.add(data);
  }

  Future<void> editCharacter(String id, Character data) async {
    await db.doc(id).update(data.toFirestore());
  }

  Future<void> delete(String id) async {
    await db.doc(id).delete();
  }
}
