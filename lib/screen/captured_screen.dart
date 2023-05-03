import 'package:flutter/material.dart';
import 'package:muralhunt/utils/mural.dart';

class CapturedScreen extends StatelessWidget {
  const CapturedScreen({
    super.key,
    required this.mural,
  });

  final Mural mural;

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 150,
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
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Mural Captured',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  '2/255',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                width: double.infinity,
                child: ElevatedButton(
                  
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(8),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 24,
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
