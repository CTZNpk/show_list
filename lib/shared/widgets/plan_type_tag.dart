import 'package:flutter/material.dart';
import 'package:show_list/shared/enums/plan_type.dart';

class PlanTypeTag extends StatelessWidget {
  const PlanTypeTag({super.key, required this.tmdbData});

  final dynamic tmdbData;

  @override
  Widget build(BuildContext context) {
    return tmdbData.planType != null
        ? Positioned(
            left: 2,
            child: Opacity(
              opacity: 0.8,
              child: Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  color: tmdbData.planType == PlanType.planToWatch
                      ? Colors.blue[700]
                      : tmdbData.planType == PlanType.watching
                          ? Colors.teal[400]
                          : Colors.lime[900],
                ),
                child: Icon(
                  tmdbData.planType == PlanType.planToWatch
                      ? Icons.watch_later
                      : tmdbData.planType == PlanType.watching
                          ? Icons.remove_red_eye_sharp
                          : Icons.done,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
