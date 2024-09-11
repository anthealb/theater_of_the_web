import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Character extends Equatable {
  // final String id;
  final String name;
  final Color color;
  final bool isPC;

  const Character({/*required this.id,*/ required this.name, required this.color, required this.isPC});

  @override
  List<Object?> get props => [/*id, */ name, color, isPC];

  factory Character.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Character(
      // id: snapshot.id,
      name: data?['name'],
      color: Color(data?['color'] as int),
      isPC: data?['isPC'] as bool,
    );
  }

  Character.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        color = json['color'] as Color,
        isPC = json['pc'] as bool;

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'color': color.value,
      'isPC': isPC,
    };
  }
}

typedef CharacterSnapshotList = List<QueryDocumentSnapshot<Character>>;
typedef CharacterSnapshot = QueryDocumentSnapshot<Character>;
