import 'package:flutter/material.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/screens/captured_screen.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MuralWidget extends StatelessWidget {
  const MuralWidget({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    Mural mural = context.watch<MuralProvider>().getById(id);
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          ActionButton(
            mural: mural,
            isCapturable: true,
            context: context,
          ),
          DetailsCard(
            mural: mural,
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.mural,
    required this.isCapturable,
    required this.context,
  });

  final Mural mural;
  final bool isCapturable;
  final BuildContext context;

  void onCapture(Mural mural) {
    mural.setCapture().then((Mural mural) {
      context.read<MuralProvider>().updateById(mural);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CapturedScreen(id: mural.id)),
      );
    });
  }

  void onDirection(Mural mural) {
    mural.redirectToMap();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          decoration: BoxDecoration(
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
              borderRadius: BorderRadius.circular(30),
              onTap: isCapturable
                  ? () => onCapture(mural)
                  : () => onDirection(mural),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                          isCapturable ? Icons.camera_alt : Icons.directions),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(isCapturable
                          ? mural.isCaptured
                              ? 'Recapture'
                              : 'Capture'
                          : 'Directions'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.mural,
  });

  final Mural mural;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: mural.isCaptured
                ? FileImage(mural.capturedPhoto)
                : NetworkImage(mural.image) as ImageProvider,
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.9), Colors.transparent],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                child: Text(
                  mural.artiste,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(
                  mural.isCaptured
                      ? 'Captured on ${DateFormat.yMMMMd().format(mural.capturedDate)}'
                      : 'Not captured',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
