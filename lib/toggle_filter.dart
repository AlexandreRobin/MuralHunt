import 'package:flutter/material.dart';

class ToggleFilter extends StatefulWidget {
  const ToggleFilter({Key? key}) : super(key: key);

  @override
  _ToggleFilterState createState() => _ToggleFilterState();
}

class _ToggleFilterState extends State<ToggleFilter> {
  List<bool> _isSelected = [true, false, false];

  Future<void> _onFilterAll() async {
    setState(() {
      _isSelected[0] = true;
      _isSelected[1] = false;
      _isSelected[2] = false;
    });
  }

  Future<void> _onFilterCaptured() async {
    setState(() {
      _isSelected[0] = false;
      _isSelected[1] = true;
      _isSelected[2] = false;
    });
  }

  Future<void> _onFilterNotCaptured() async {
    setState(() {
      _isSelected[0] = false;
      _isSelected[1] = false;
      _isSelected[2] = true;
    });
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
            color: isSelected ? Colors.black : Colors.black.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

// class ToggleFilter extends StatefulWidget {
//   const ToggleFilter({Key? key}) : super(key: key);

//   @override
//   _ToggleFilterState createState() => _ToggleFilterState();
// }

// class _ToggleFilterState extends State<ToggleFilter> {
//   List<bool> _isSelected = [true, false, false];

//   Future<void> _onFilterAll() async {
//     setState(() {
//       _isSelected[0] = true;
//       _isSelected[1] = false;
//       _isSelected[2] = false;
//     });
//   }

//   Future<void> _onFilterCaptured() async {
//     setState(() {
//       _isSelected[0] = false;
//       _isSelected[1] = true;
//       _isSelected[2] = false;
//     });
//   }

//   Future<void> _onFilterNotCaptured() async {
//     setState(() {
//       _isSelected[0] = false;
//       _isSelected[1] = false;
//       _isSelected[2] = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 100,
//       right: 0,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: Colors.grey.withOpacity(0.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(0),
//         margin: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Toggle(
//               onTap: _onFilterAll,
//               isSelected: _isSelected[0],
//               icon: Icons.directions,
//             ),
//             Toggle(
//               onTap: _onFilterCaptured,
//               isSelected: _isSelected[1],
//               icon: Icons.access_alarm,
//             ),
//             Toggle(
//               onTap: _onFilterNotCaptured,
//               isSelected: _isSelected[2],
//               icon: Icons.recycling,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Toggle extends StatelessWidget {
//   const Toggle(
//       {super.key,
//       required this.onTap,
//       required this.isSelected,
//       required this.icon});

//   final Function() onTap;
//   final bool isSelected;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       borderRadius: BorderRadius.circular(30),
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(30),
//         onTap: onTap,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: isSelected ? Colors.white : Colors.transparent,
//           ),
//           padding: const EdgeInsets.all(8),
//           child: Icon(
//             icon,
//             color: isSelected ? Colors.black : Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
