import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Modal extends StatefulWidget {
  const Modal({
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
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  String _captureDate = '';
  String _photoPath = '';

  @override
  void initState() {
    super.initState();
    _getCapture();
  }

  Future<void> _getCapture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String path = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      _captureDate = prefs.getString(widget.id) ?? '';
      _photoPath = '$path/$_captureDate.jpg';
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

      setState(() {
        _captureDate = fileName;
        _photoPath = '$path/$fileName.jpg';
      });
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

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else {
      throw 'Could not launch ${googleMapsUri.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(12.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _onCapture,
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.camera_alt),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:
                            Text(_captureDate == '' ? 'Capture' : 'Recapture'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: _onDirection,
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.directions),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('Directions'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4.0),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(widget.image),
                // ? NetworkImage(widget.image)
                // : FileImage(File(_photoPath)),
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
                borderRadius: BorderRadius.circular(10.0),
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
                    padding:
                        const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                    child: Text(
                      widget.artiste,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Text(
                      _captureDate == ''
                          ? 'Not captured'
                          : 'Captured on ${DateFormat.yMMMMd().format(DateTime.parse(_captureDate))}',
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
        ),
      ]),
    );
  }
}
