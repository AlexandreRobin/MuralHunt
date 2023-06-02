import 'package:flutter/material.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:provider/provider.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int numberCaptured = context.watch<MuralProvider>().numberCaptured();
    int numberTotal = context.watch<MuralProvider>().murals.length;

    return SafeArea(
      child: Positioned(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFEE0100), // Set the color of the outline
                  width: 1.0, // Set the width of the outline
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
              child: Material(
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  overlayColor: MaterialStateProperty.all<Color>(
                    Color(0xFFEE0100).withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => print('la;sjdf'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    child: Row(
                      children: [
                        Text(
                          numberCaptured.toString().padLeft(3, '0'),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFEE0100),
                            fontWeight: FontWeight.bold,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
