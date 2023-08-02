import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
