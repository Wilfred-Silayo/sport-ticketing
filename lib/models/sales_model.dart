// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
@immutable
class Sales {
  final String id;
  final List<String> ticketNo;
  final List<int> seatNo;
  final String seatType;
  final String matchId;
  final String stadiumId;
  const Sales({
    required this.id,
    required this.ticketNo,
    required this.seatNo,
    required this.seatType,
    required this.matchId,
    required this.stadiumId,
  });

  Sales copyWith({
    String? id,
    List<String>? ticketNo,
    List<int>? seatNo,
    String? seatType,
    String? matchId,
    String? stadiumId,
  }) {
    return Sales(
      id: id ?? this.id,
      ticketNo: ticketNo ?? this.ticketNo,
      seatNo: seatNo ?? this.seatNo,
      seatType: seatType ?? this.seatType,
      matchId: matchId ?? this.matchId,
      stadiumId: stadiumId ?? this.stadiumId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ticketNo': ticketNo,
      'seatNo': seatNo,
      'seatType': seatType,
      'matchId': matchId,
      'stadiumId': stadiumId,
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      id: map['id'] as String,
      ticketNo: List<String>.from((map['ticketNo'] as List<String>)),
      seatNo: List<int>.from((map['seatNo'] as List<int>)),
      seatType: map['seatType'] as String,
      matchId: map['matchId'] as String,
      stadiumId: map['stadiumId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sales.fromJson(String source) => Sales.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sales(id: $id, ticketNo: $ticketNo, seatNo: $seatNo, seatType: $seatType, matchId: $matchId, stadiumId: $stadiumId)';
  }

  @override
  bool operator ==(covariant Sales other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      listEquals(other.ticketNo, ticketNo) &&
      listEquals(other.seatNo, seatNo) &&
      other.seatType == seatType &&
      other.matchId == matchId &&
      other.stadiumId == stadiumId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      ticketNo.hashCode ^
      seatNo.hashCode ^
      seatType.hashCode ^
      matchId.hashCode ^
      stadiumId.hashCode;
  }
}
