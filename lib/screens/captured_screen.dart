import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      'lib/assets/close_red.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
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
                        color: Colors.white.withOpacity(0.6),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(color: Color(0xFFEE0100)),
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Color(0xFFEE0100).withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Color(0xFFEE0100)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
