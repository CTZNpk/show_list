import 'package:flutter/material.dart';
import 'package:show_list/shared/constants.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.label,
    required this.labelIcon,
    required this.imageUrl,
    required this.onPressed,
  });

  final String label;
  final IconData? labelIcon;
  final String? imageUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: 25,
                    )
                  : labelIcon != null
                      ? Icon(labelIcon!)
                      : const SizedBox.shrink(),
              const HorizontalSpacing(3),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
