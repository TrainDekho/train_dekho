// lib/api/services/station_service.dart

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Core/api_constant/api_constants.dart';
import '../Model/Station.dart';


class StationService {
  Future<List<Station>> searchStation(String query) async {
    try {
      // Load JSON file from assets
      String jsonString = await rootBundle.loadString('assets/station.json');
      Map<String, dynamic> data = json.decode(jsonString);

      // Print the loaded JSON data for debugging
      print('Loaded JSON data: $data');

      // Extract data from JSON
      List<Station> stations = (data['data'] as List)
          .map((stationJson) => Station.fromJson(stationJson))
          .toList();

      // Print the stations for debugging
      print('Stations: $stations');

      // Filter stations by query
      List<Station> filteredStations = stations.where((station) =>
      station.name.toLowerCase().contains(query.toLowerCase()) ||
          station.code.toLowerCase().contains(query.toLowerCase())).toList();

      // Print the filtered stations for debugging
      print('Filtered stations: $filteredStations');

      return filteredStations;
    } catch (e) {
      throw Exception('Failed to load stations: $e');
    }
  }
}
// class StationService {
//   Future<List<Station>> searchStation(String query) async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/searchStation?query=$query');
//     final response = await http.get(
//       url,
//       headers: {
//         'x-rapidapi-host': ApiConstants.apiHost,
//         'x-rapidapi-key': ApiConstants.apiKey,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<Station> stations = (data['data'] as List)
//           .map((station) => Station.fromJson(station))
//           .toList();
//       return stations;
//     } else {
//       throw Exception('Failed to load stations');
//     }
//   }
// }
