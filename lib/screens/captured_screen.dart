import 'package:flutter/material.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:provider/provider.dart';

class CapturedScreen extends StatelessWidget {
  const CapturedScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    Mural mural = context.watch<MuralProvider>().getById(id);
    int numberCaptured = context.watch<MuralProvider>().numberCaptured();
    int numberTotal = context.watch<MuralProvider>().murals.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Congrats!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 125,
                      backgroundImage: FileImage(mural.capturedPhoto),
                    ),
                    Positioned.fill(
                      child: Icon(
                        Icons.check,
                        color: Colors.grey.withOpacity(0.6),
                        size: 200,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Mural Captured',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Text(
                  '${numberCaptured.toString().padLeft(3, '0')}/$numberTotal',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
