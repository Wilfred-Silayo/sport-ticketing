// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Prices {
  final String id;
  final double VVIP;
  final double VIPA;
  final double VIPB;
  final double VIPC;
  final double ORANGE;
  final double ROUND;
  final String matchId;
  const Prices({
    required this.id,
    required this.VVIP,
    required this.VIPA,
    required this.VIPB,
    required this.VIPC,
    required this.ORANGE,
    required this.ROUND,
    required this.matchId,
  });

  Prices copyWith({
    String? id,
    double? VVIP,
    double? VIPA,
    double? VIPB,
    double? VIPC,
    double? ORANGE,
    double? ROUND,
    String? matchId,
  }) {
    return Prices(
      id: id ?? this.id,
      VVIP: VVIP ?? this.VVIP,
      VIPA: VIPA ?? this.VIPA,
      VIPB: VIPB ?? this.VIPB,
      VIPC: VIPC ?? this.VIPC,
      ORANGE: ORANGE ?? this.ORANGE,
      ROUND: ROUND ?? this.ROUND,
      matchId: matchId ?? this.matchId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'VVIP': VVIP,
      'VIPA': VIPA,
      'VIPB': VIPB,
      'VIPC': VIPC,
      'ORANGE': ORANGE,
      'ROUND': ROUND,
      'matchId': matchId,
    };
  }

  factory Prices.fromMap(Map<String, dynamic> map) {
    return Prices(
      id: map['id'] as String,
      VVIP: map['VVIP'].toDouble(),
      VIPA: map['VIPA'].toDouble(),
      VIPB: map['VIPB'].toDouble(),
      VIPC: map['VIPC'].toDouble(),
      ORANGE: map['ORANGE'].toDouble(),
      ROUND: map['ROUND'].toDouble(),
      matchId: map['matchId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Prices.fromJson(String source) => Prices.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Prices(id: $id, VVIP: $VVIP, VIPA: $VIPA, VIPB: $VIPB, VIPC: $VIPC, ORANGE: $ORANGE, ROUND: $ROUND, matchId: $matchId)';
  }

  @override
  bool operator ==(covariant Prices other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.VVIP == VVIP &&
      other.VIPA == VIPA &&
      other.VIPB == VIPB &&
      other.VIPC == VIPC &&
      other.ORANGE == ORANGE &&
      other.ROUND == ROUND &&
      other.matchId == matchId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      VVIP.hashCode ^
      VIPA.hashCode ^
      VIPB.hashCode ^
      VIPC.hashCode ^
      ORANGE.hashCode ^
      ROUND.hashCode ^
      matchId.hashCode;
  }
}
