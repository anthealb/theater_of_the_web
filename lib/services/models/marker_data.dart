import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'character.dart';

enum HealthState { healthy, ko, dead }

class MarkerData extends Equatable {
  final DocumentReference<Character> characterRef;
  final HealthState healthState;
  final double xPos;
  final double yPos;

  const MarkerData({required this.characterRef, this.healthState = HealthState.healthy, this.xPos = 0, this.yPos = 0});

  factory MarkerData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MarkerData(
      characterRef: (data?['characterRef'] as DocumentReference)
          .withConverter<Character>(fromFirestore: Character.fromFirestore, toFirestore: (value, _) => value.toFirestore()), //data?['characterRef'],
      healthState: HealthState.values[data?['healthState'] as int],
      xPos: data?['xPos'] as double,
      yPos: data?['yPos'] as double,
    );
  }

  factory MarkerData.fromJson(Map<String, dynamic> json) => MarkerData(
        characterRef: (json['characterRef'] as DocumentReference)
            .withConverter<Character>(fromFirestore: Character.fromFirestore, toFirestore: (value, _) => value.toFirestore()),
        healthState: HealthState.values[json['healthState'] as int],
        xPos: json['xPos'] as double,
        yPos: json['yPos'] as double,
      );

  Map<String, dynamic> toFirestore() {
    return {
      'characterRef': characterRef,
      'healthState': healthState.index,
      'xPos': xPos,
      'yPos': yPos,
    };
  }

  MarkerData copyWith({DocumentReference<Character>? characterRef, HealthState? healthState, double? xPos, double? yPos}) => MarkerData(
        characterRef: characterRef ?? this.characterRef,
        healthState: healthState ?? this.healthState,
        xPos: xPos ?? this.xPos,
        yPos: yPos ?? this.yPos,
      );

  @override
  List<Object?> get props => [characterRef, healthState, xPos, yPos];
}
