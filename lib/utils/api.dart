import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart';
import 'package:muralhunt/utils/mural.dart';

class API {
  static Future<List<dynamic>> fetchMontrealData() async {
    var url = Uri.https(
        'donnees.montreal.ca', '/api/3/action/datastore_search', {
      'resource_id': 'f02401c2-8336-4086-9955-4c5592ace72e',
      'limit': '500'
    });

    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['result']['records'];
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<XmlDocument> fetchMuralFestivalData() async {
    var url = Uri.https(
        'www.google.com', '/maps/d/kml', {
      'forcekml': '1',
      'mid': '1oKlF5bEL1Boq1qKjpNmcgBE5jenYdP4'
    });

    var response = await http.get(url);
    if (response.statusCode == 200) {
      return XmlDocument.parse(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<List<Mural>> getMontrealMurals() async {
    List<dynamic> data = await fetchMontrealData();
    List<Future<Mural>> futureMurals = data.map((record) async {
      Mural mural = Mural(
          id: record['id'],
          artiste: record['artiste'],
          organisme: record['organisme'] ?? '',
          adresse: record['adresse'] ?? '',
          annee: record['annee'] ?? '',
          arrondissement: record['arrondissement'] ?? '',
          programmeEntente: record['programme_entente'] ?? '',
          latitude: double.parse(record['latitude']),
          longitude: double.parse(record['longitude']),
          image: record['image']);
      return await mural.getCapture();
    }).toList();
    List<Mural> murals = await Future.wait(futureMurals);
    return murals;
  }

  static getFestivalMurals() async {
    XmlDocument data = await fetchMuralFestivalData();
    List<Future<Mural>> futureMurals = data.findAllElements('Placemark').map((placemark) async {
      String image = placemark.getElement('ExtendedData')!.findAllElements('Data')
        .where((element) => element.attributes.any((attribute) => attribute.name.local == 'name' && attribute.value == 'gx_media_links'))
        .first.innerText.replaceAll(' ', '').replaceAll('\n', '');
      List<String> coordinates = placemark.getElement('Point')!.getElement('coordinates')!.innerText.split(',');
      Mural mural = Mural(
          id: image.substring(image.length - 16),
          artiste: placemark.getElement('name')!.innerText,
          latitude: double.parse(coordinates[1]),
          longitude: double.parse(coordinates[0].replaceAll(' ', '').replaceAll('\n', '')),
          image: image);
      return await mural.getCapture();
    }).toList();
    List<Mural> murals = await Future.wait(futureMurals);
    return murals;
  }

  static Future<List<Mural>> getMurals() async {
    List<Mural> montrealMurals = await getMontrealMurals();
    List<Mural> festivalMurals = await getFestivalMurals();
    List<Mural> murals = montrealMurals + festivalMurals;
    return murals;
  }
}
