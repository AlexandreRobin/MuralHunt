import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              isSelected: context.watch<FilterProvider>().captured &&
                  context.watch<FilterProvider>().notCaptured,
              icon: 'marker',
            ),
            Toggle(
              onTap: () => context.read<FilterProvider>().filterCaptured(),
              isSelected: context.watch<FilterProvider>().captured &&
                  !context.watch<FilterProvider>().notCaptured,
              icon: 'captured_marker',
            ),
            Toggle(
              onTap: () => context.read<FilterProvider>().filterNotCaptured(),
              isSelected: !context.watch<FilterProvider>().captured &&
                  context.watch<FilterProvider>().notCaptured,
              icon: 'uncaptured_marker',
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
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
          child: SvgPicture.asset(
            'lib/assets/${icon}_${isSelected ? 'red' : 'grey'}.svg',
            width: isSelected ? 24 : 22,
            height: isSelected ? 24 : 22,
          ),
        ),
      ),
    );
  }
}
