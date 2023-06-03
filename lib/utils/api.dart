import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:muralhunt/utils/mural.dart';

class API {
  static Future<List<dynamic>> fetchData() async {
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

    // final client = RetryClient(http.Client());
    // try {
    //   print(await client.read(Uri.http('example.org', '')));
    // } finally {
    //   client.close();
    // }
  }

  static Future<List<Mural>> getMurals() async {
    List<dynamic> data = await fetchData();
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
}
