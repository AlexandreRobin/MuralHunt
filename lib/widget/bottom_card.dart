import 'package:flutter/material.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../screen/captured_screen.dart';

class BottomCard extends StatefulWidget {
  const BottomCard({
    super.key,
    required this.mural,
    required this.updateMap,
  });

  final Mural mural;
  final Function updateMap;

  @override
  State<BottomCard> createState() => _BottomCardState();
}

class _BottomCardState extends State<BottomCard> {
  void _onCapture() {
    widget.mural.setCapture().then((Mural mural) {
      Navigator.pop(context);
      widget.updateMap();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CapturedScreen(mural: widget.mural)),
      );
    });
  }

  void _onDirection() async {
    final googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '${widget.mural.latitude},${widget.mural.longitude}',
      },
    );

    final appleMapsUri = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      path: '/',
      queryParameters: {
        'q': '${widget.mural.latitude},${widget.mural.longitude}',
      },
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else if (await canLaunchUrl(appleMapsUri)) {
      await launchUrl(appleMapsUri);
    } else {
      throw 'Could not launch map';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(children: [
        Row(
          children: [
            ActionButton(
              onTap: _onCapture,
              icon: Icons.camera_alt,
              text: widget.mural.isCaptured ? 'Recapture' : 'Capture',
            ),
            ActionButton(
              onTap: _onDirection,
              icon: Icons.directions,
              text: 'Directions',
            ),
          ],
        ),
        MuralCard(
          mural: widget.mural,
        ),
      ]),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  final Function() onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.camera_alt),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MuralCard extends StatelessWidget {
  const MuralCard({
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
