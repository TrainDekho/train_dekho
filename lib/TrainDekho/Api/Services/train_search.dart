// lib/api/services/train_service.dart

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Core/api_constant/api_constants.dart';
import '../Model/train.dart';

class TrainService {
  Future<List<Train>> searchTrain(String query) async {
    try {
      // Load JSON file from assets
      String jsonString = await rootBundle.loadString('assets/stations.json');
      Map<String, dynamic> data = json.decode(jsonString);// Parse as List<dynamic>

      // Print the loaded JSON data for debugging
      print('Loaded JSON data: $data');

      // Extract data from JSON
      List<Train> trains = (data['data'] as List)
          .map((stationJson) => Train.fromJson(stationJson))
          .toList();

      // Print the trains for debugging
      print('Trains: $trains');

      // Filter trains by query
      List<Train> filteredTrains = trains.where((train) =>
      train.trainName.toLowerCase().contains(query.toLowerCase()) ||
          train.trainNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Print the filtered trains for debugging
      print('Filtered trains: $filteredTrains');

      return filteredTrains;
    } catch (e) {
      print('Failed to load trains: $e'); // Print the error for debugging
      return [];
    }
  }

}
// class TrainService {
//   Future<List<Train>> searchTrain(String query) async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/searchTrain?query=$query');
//     final response = await http.get(
//       url,
//       headers: {
//         'x-rapidapi-host': ApiConstants.apiHost,
//         'x-rapidapi-key': ApiConstants.apiKey,
//       },
//     );
//     print("response" +response.toString());
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<Train> trains = (data['data'] as List)
//           .map((train) => Train.fromJson(train))
//           .toList();
//       return trains;
//     } else {
//       throw Exception('Failed to load trains');
//     }
//   }
// }
