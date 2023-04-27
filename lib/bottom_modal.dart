import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BottomModal extends StatefulWidget {
  const BottomModal({
    super.key,
    required this.id,
    required this.artiste,
    required this.latitude,
    required this.longitude,
    required this.image,
  });

  final String id;
  final String artiste;
  final String latitude;
  final String longitude;
  final String image;

  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  String _date = '';
  late ImageProvider _photo = NetworkImage(widget.image);

  @override
  void initState() {
    super.initState();
    _getCapture();
  }

  Future<void> _getCapture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String path = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      if (prefs.getString(widget.id) != null) {
        _date = prefs.getString(widget.id) ?? '';
        _photo = FileImage(File('$path/$_date.jpg'));
      }
    });
  }

  Future<void> _onCapture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final String path = (await getApplicationDocumentsDirectory()).path;
      final String fileName = DateTime.now().toIso8601String();
      final File file = File('$path/$fileName.jpg');
      await file.writeAsBytes(await photo.readAsBytes());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(widget.id, fileName);

      // TODO update markers

      _getCapture();
    }
  }

  Future<void> _onDirection() async {
    final googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '${widget.latitude},${widget.longitude}',
      },
    );

    final appleMapsUri = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      path: '/',
      queryParameters: {
        'q': '${widget.latitude},${widget.longitude}',
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
              text: _date == '' ? 'Capture' : 'Recapture',
            ),
            ActionButton(
              onTap: _onDirection,
              icon: Icons.directions,
              text: 'Directions',
            ),
          ],
        ),
        MuralCard(
          image: _photo,
          artiste: widget.artiste,
          date: _date,
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
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
    required this.image,
    required this.artiste,
    required this.date,
  });

  final ImageProvider image;
  final String artiste;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: image,
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
                  artiste,
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
                  date == ''
                      ? 'Not captured'
                      : 'Captured on ${DateFormat.yMMMMd().format(DateTime.parse(date))}',
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
