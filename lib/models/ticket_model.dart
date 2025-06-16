// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class TicketModel {
  final String ticketNo;
  final String match;
  final DateTime timestamp;
  final double amount;
  final String seatType;
  final int seatNo;
  final bool isCancelled;
  final String uid;
  const TicketModel({
    required this.ticketNo,
    required this.match,
    required this.timestamp,
    required this.amount,
    required this.seatType,
    required this.seatNo,
    required this.isCancelled,
    required this.uid,
  });

  TicketModel copyWith({
    String? ticketNo,
    String? match,
    DateTime? timestamp,
    double? amount,
    String? seatType,
    int? seatNo,
    bool? isCancelled,
    String? uid,
  }) {
    return TicketModel(
      ticketNo: ticketNo ?? this.ticketNo,
      match: match ?? this.match,
      timestamp: timestamp ?? this.timestamp,
      amount: amount ?? this.amount,
      seatType: seatType ?? this.seatType,
      seatNo: seatNo ?? this.seatNo,
      isCancelled: isCancelled ?? this.isCancelled,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ticketNo': ticketNo,
      'match': match,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'amount': amount,
      'seatType': seatType,
      'seatNo': seatNo,
      'isCancelled': isCancelled,
      'uid': uid,
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      ticketNo: map['ticketNo'] as String,
      match: map['match'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      amount: map['amount'].toDouble(),
      seatType: map['seatType'] as String,
      seatNo: map['seatNo'] as int,
      isCancelled: map['isCancelled'] as bool,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketModel.fromJson(String source) =>
      TicketModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TicketModel(ticketNo: $ticketNo, match: $match, timestamp: $timestamp, amount: $amount, seatType: $seatType, seatNo: $seatNo, isCancelled: $isCancelled, uid: $uid)';
  }

  @override
  bool operator ==(covariant TicketModel other) {
    if (identical(this, other)) return true;

    return other.ticketNo == ticketNo &&
        other.match == match &&
        other.timestamp == timestamp &&
        other.amount == amount &&
        other.seatType == seatType &&
        other.seatNo == seatNo &&
        other.isCancelled == isCancelled &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return ticketNo.hashCode ^
        match.hashCode ^
        timestamp.hashCode ^
        amount.hashCode ^
        seatType.hashCode ^
        seatNo.hashCode ^
        isCancelled.hashCode ^
        uid.hashCode;
  }
}
