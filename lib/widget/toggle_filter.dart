import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/widget/bottom_card.dart';
import 'package:muralhunt/utils/mural.dart';

class ToggleFilter extends StatefulWidget {
  const ToggleFilter({
    super.key,
    required this.murals,
    required this.onFilter,
  });

  final Iterable<Mural> murals;
  final Function(Set<Marker>) onFilter;

  @override
  State<ToggleFilter> createState() => _ToggleFilterState();
}

class _ToggleFilterState extends State<ToggleFilter> {
  late int _filterType;

  @override
  void initState() {
    super.initState();
    _onFilter(0);
  }

  void _onFilter(int filterType) {
    setState(() {
      _filterType = filterType;
    });

    final Set<Marker> markers = widget.murals
        .where((mural) => filterType == 1
            ? mural.isCaptured
            : filterType == 2
                ? !mural.isCaptured
                : true)
        .map((mural) {
      return mural.createMarker(_onTapMarker);
    }).toSet();

    widget.onFilter(markers);
  }

  void _onTapMarker(Mural mural) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (builder) {
        return BottomCard(
          mural: mural,
          updateMap: () {
            setState(() {
              _onFilter(_filterType);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
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
              onTap: () {
                _onFilter(0);
              },
              isSelected: _filterType == 0,
              icon: Icons.directions,
            ),
            Toggle(
              onTap: () {
                _onFilter(1);
              },
              isSelected: _filterType == 1,
              icon: Icons.access_alarm,
            ),
            Toggle(
              onTap: () {
                _onFilter(2);
              },
              isSelected: _filterType == 2,
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
