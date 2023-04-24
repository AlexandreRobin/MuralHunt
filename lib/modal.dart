import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Modal extends StatefulWidget {
  const Modal({
    super.key,
    required this.id,
    required this.artiste,
    // required this.organisme,
    required this.adresse,
    required this.annee,
    required this.arrondissement,
    required this.programmeEntente,
    required this.latitude,
    required this.longitude,
    required this.image,
  });

  final String id;
  final String artiste;
  // final String organisme;
  final String adresse;
  final String annee;
  final String arrondissement;
  final String programmeEntente;
  final String latitude;
  final String longitude;
  final String image;

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  void _onCapture() {}

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

  void _onPressCard() {}

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
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.camera_alt),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('Capture'),
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
          child: InkWell(
            onTap: _onPressCard,
            child: Container(
              margin: const EdgeInsets.all(4.0),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(widget.image),
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
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Text(
                        widget.annee,
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
        ),
      ]),
    );
  }
}
