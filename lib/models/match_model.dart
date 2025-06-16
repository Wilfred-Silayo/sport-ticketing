import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class MatchModel {
  final String matchId;
  final String homeTeam;
  final String awayTeam;
  final String stadiumId;
  final DateTime timestamp;
  const MatchModel({
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    required this.stadiumId,
    required this.timestamp,
  });

  MatchModel copyWith({
    String? matchId,
    String? homeTeam,
    String? awayTeam,
    String? stadiumId,
    DateTime? timestamp,
  }) {
    return MatchModel(
      matchId: matchId ?? this.matchId,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      stadiumId: stadiumId ?? this.stadiumId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchId': matchId,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'stadiumId': stadiumId,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      matchId: map['matchId'] as String,
      homeTeam: map['homeTeam'] as String,
      awayTeam: map['awayTeam'] as String,
      stadiumId: map['stadiumId'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return 'MatchModel(matchId: $matchId, homeTeam: $homeTeam, awayTeam: $awayTeam, stadiumId: $stadiumId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant MatchModel other) {
    if (identical(this, other)) return true;

    return other.matchId == matchId &&
        other.homeTeam == homeTeam &&
        other.awayTeam == awayTeam &&
        other.stadiumId == stadiumId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return matchId.hashCode ^
        homeTeam.hashCode ^
        awayTeam.hashCode ^
        stadiumId.hashCode ^
        timestamp.hashCode;
  }
}
