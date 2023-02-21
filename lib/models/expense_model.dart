import 'dart:convert';

import 'package:flutter/material.dart';

class ExpenseModel {
  final String? id;
  final String? title;
  final String? value;
  final bool? isPaid;

  const ExpenseModel({
    this.id,
    @required this.title,
    @required this.value,
    @required this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value,
      'isPaid': isPaid,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      title: map['title'] ?? '',
      value: map['value'] ?? '',
      isPaid: map['isPaid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) =>
      ExpenseModel.fromMap(json.decode(source));
}
