import 'dart:convert';

import 'package:flutter/foundation.dart';

class Stadium {
  final String name;
  final String id;
  final int capacity;
  final Map<String, List<dynamic>>
      seatMap; //VVIP,VIPA,VIPB,VIPC,ORANGE,ROUND(A-F1-A-F4)

  Stadium({
    required this.name,
    required this.id,
    required this.capacity,
    required this.seatMap,
  });

  Stadium copyWith({
    String? name,
    String? id,
    int? capacity,
    Map<String, List<int>>? seatMap,
  }) {
    return Stadium(
      name: name ?? this.name,
      id: id ?? this.id,
      capacity: capacity ?? this.capacity,
      seatMap: seatMap ?? this.seatMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'capacity': capacity,
      'seatMap': seatMap,
    };
  }

  factory Stadium.fromMap(Map<String, dynamic> map) {
    return Stadium(
      name: map['name'] as String,
      id: map['id'] as String,
      capacity: map['capacity'] as int,
      seatMap: Map<String, List<dynamic>>.from(
          map['seatMap'] as Map<String, dynamic>), // Deserialize seatMap
    );
  }

  String toJson() => json.encode(toMap());

  factory Stadium.fromJson(String source) =>
      Stadium.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Stadium(name: $name, id: $id, capacity: $capacity, seatMap: $seatMap)';
  }

  @override
  bool operator ==(covariant Stadium other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.capacity == capacity &&
        mapEquals(other.seatMap, seatMap);
  }

  @override
  int get hashCode {
    return name.hashCode ^ id.hashCode ^ capacity.hashCode ^ seatMap.hashCode;
  }
}
