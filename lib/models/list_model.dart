import 'dart:convert';

import 'package:flutter/material.dart';

class ListModel {
  final String? id;
  final String? title;
  final String? value;
  final bool? isPaid;

  const ListModel({
    this.id,
    @required this.title,
    @required this.value,
    @required this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'isPaid': value,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      title: map['title'] ?? '',
      value: map['value'] ?? '',
      isPaid: map['isPaid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ListModel.fromJson(String source) =>
      ListModel.fromMap(json.decode(source));
}
