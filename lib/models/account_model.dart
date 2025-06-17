import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String id;
  final String userId;
  final double balance;
  final DateTime createdAt;

  AccountModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.createdAt,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] ?? '', // fallback to empty string if null
      userId: map['user_id'] ?? '',
      balance: (map['balance'] ?? 0).toDouble(),
      createdAt: _parseDate(map['created_at']),
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  AccountModel copyWith({double? balance}) {
    return AccountModel(
      id: id,
      userId: userId,
      balance: balance ?? this.balance,
      createdAt: createdAt,
    );
  }
}
