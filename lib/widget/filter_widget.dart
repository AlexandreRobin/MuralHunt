import 'package:flutter/material.dart';
import 'package:muralhunt/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 200,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Toggle(
              onTap: () => context.read<FilterProvider>().filterAll(),
              isSelected: context.watch<FilterProvider>().captured && context.watch<FilterProvider>().notCaptured,
              icon: Icons.directions,
            ),
            Toggle(
              onTap: () => context.read<FilterProvider>().filterCaptured(),
              isSelected: context.watch<FilterProvider>().captured && !context.watch<FilterProvider>().notCaptured,
              icon: Icons.access_alarm,
            ),
            Toggle(
              onTap: () => context.read<FilterProvider>().filterNotCaptured(),
              isSelected: !context.watch<FilterProvider>().captured && context.watch<FilterProvider>().notCaptured,
              icon: Icons.recycling,
            ),
          ],
        ),
      ),
    );
  }
}

class Toggle extends StatelessWidget {
  const Toggle({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.icon,
  });

  final Function() onTap;
  final bool isSelected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color:
                isSelected ? Colors.grey.withOpacity(0.5) : Colors.transparent,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: isSelected ? 24 : 22,
            color: isSelected ? Colors.black : Colors.black.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
