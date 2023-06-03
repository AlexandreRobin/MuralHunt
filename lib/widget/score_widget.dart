import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/screens/gallery_screen.dart';
import 'package:provider/provider.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFEE0100),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: OpenContainer(
              openShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              transitionDuration: const Duration(milliseconds: 500),
              openBuilder: (BuildContext context, void Function() action) {
                return const GalleryScreen();
              },
              closedBuilder: (BuildContext context, void Function() action) {
                return DetailsScore(action: action);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsScore extends StatelessWidget {
  const DetailsScore({
    super.key,
    required this.action,
  });

  final Function action;

  @override
  Widget build(BuildContext context) {
    int numberCaptured = context.watch<MuralProvider>().numberCaptured();
    int numberTotal = context.watch<MuralProvider>().murals.length;

    return Material(
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        overlayColor: MaterialStateProperty.all<Color>(
          const Color(0xFFEE0100).withOpacity(0.1),
        ),
        onTap: numberCaptured == 0 ? () {} : () => action.call(),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            children: [
              Text(
                numberCaptured.toString().padLeft(3, '0'),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFEE0100),
                ),
              ),
              Text(
                '/$numberTotal',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA1A2A1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
