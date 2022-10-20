import 'package:flutter/material.dart';

void showSnackBar(context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}
