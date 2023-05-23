import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muralhunt/widget/mural_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Mural {
  String id;
  String artiste;
  String organisme;
  String adresse;
  String annee;
  String arrondissement;
  String programmeEntente;
  double latitude;
  double longitude;
  String image;
  bool isCaptured = false;
  late DateTime capturedDate;
  late File capturedPhoto;

  Mural({
    required this.id,
    required this.artiste,
    this.organisme = '',
    this.adresse = '',
    this.annee = '',
    this.arrondissement = '',
    this.programmeEntente = '',
    required this.latitude,
    required this.longitude,
    required this.image,
  });

  Future<Mural> setCapture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String path = (await getApplicationDocumentsDirectory()).path;

    if (photo != null) {
      isCaptured = true;
      capturedDate = DateTime.now();
      final String fileName = DateTime.now().toIso8601String();
      capturedPhoto = File('$path/$fileName.jpg');

      await capturedPhoto.writeAsBytes(await photo.readAsBytes());
      await prefs.setString(id, fileName);
    }

    return this;
  }

  Future<Mural> getCapture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String path = (await getApplicationDocumentsDirectory()).path;

    if (prefs.getString(id) != null) {
      isCaptured = true;
      capturedDate = DateTime.parse(prefs.getString(id) ?? '');
      capturedPhoto = File('$path/${capturedDate.toIso8601String()}.jpg');
    }

    return this;
  }

  Marker createMarker(context, capturedIcon, uncapturedIcon) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(latitude, longitude),
      icon: isCaptured
          ? capturedIcon
          : uncapturedIcon,
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          builder: (builder) {
            return MuralWidget(
              id: id,
            );
          },
        );
      },
    );
  }

  void redirectToMap() async {
    final googleMapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '$latitude,$longitude',
      },
    );

    final appleMapsUri = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      path: '/',
      queryParameters: {
        'q': '$latitude,$longitude',
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
}
