import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muralhunt/utils/mural.dart';

class ToggleFilter extends StatefulWidget {
  const ToggleFilter({
    super.key,
    required this.murals,
    required this.onFilter,
    required this.onTapMarker,
  });

  final Iterable<Mural> murals;
  final Function(Set<Marker>) onFilter;
  final Function(Mural) onTapMarker;

  @override
  State<ToggleFilter> createState() => _ToggleFilterState();
}

class _ToggleFilterState extends State<ToggleFilter> {
  final List<bool> _isSelected = [true, false, false];

  @override
  void initState() {
    super.initState();
    _onFilterAll();
  }

  _onFilterAll() {
    setState(() {
      _isSelected[0] = true;
      _isSelected[1] = false;
      _isSelected[2] = false;
    });

    final Set<Marker> markers = widget.murals.map((Mural mural) {
      return mural.createMarker(widget.onTapMarker);
    }).toSet();

    widget.onFilter(markers);
  }

  _onFilterCaptured() {
    setState(() {
      _isSelected[0] = false;
      _isSelected[1] = true;
      _isSelected[2] = false;
    });

    final Set<Marker> markers =
        widget.murals.where((mural) => mural.isCaptured).map((mural) {
      return mural.createMarker(widget.onTapMarker);
    }).toSet();

    widget.onFilter(markers);
  }

  _onFilterNotCaptured() {
    setState(() {
      _isSelected[0] = false;
      _isSelected[1] = false;
      _isSelected[2] = true;
    });

    final Set<Marker> markers =
        widget.murals.where((mural) => !mural.isCaptured).map((mural) {
      return mural.createMarker(widget.onTapMarker);
    }).toSet();

    widget.onFilter(markers);
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
              onTap: _onFilterAll,
              isSelected: _isSelected[0],
              icon: Icons.directions,
            ),
            Toggle(
              onTap: _onFilterCaptured,
              isSelected: _isSelected[1],
              icon: Icons.access_alarm,
            ),
            Toggle(
              onTap: _onFilterNotCaptured,
              isSelected: _isSelected[2],
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
