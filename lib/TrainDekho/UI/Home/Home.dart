import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api/Model/Station.dart';
import '../../Api/Model/train.dart';
import '../../Api/Services/Station_service.dart';
import '../../Api/Services/train_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final StationService _stationService = StationService();
  final TextEditingController _trainController = TextEditingController();
  final TrainService _trainService = TrainService();
  String? _selectedTrain;
  Train? _train;
  bool _swapped = false;
  String? _selectedFromStation;
  String? _selectedToStation;
  final List<String> savedStationSearches = [];
  final List<String> savedTrainSearches = [];

  @override
  void initState() {
    super.initState();
    _loadSavedSearches();
  }

  void _loadSavedSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedStationSearches.clear();
      savedStationSearches.addAll(prefs.getStringList('savedStationSearches') ?? []);
      print("save train "+savedStationSearches.toString());
      // savedTrainSearches.clear();
      // savedTrainSearches.addAll(prefs.getStringList('savedTrainSearches') ?? []);
    });
  }

  void _saveStationSearch(String from, String to) async {
    final prefs = await SharedPreferences.getInstance();
    final newSearch = '$from to $to';
    savedStationSearches.add(newSearch);
    prefs.setStringList('savedStationSearches', savedStationSearches);
    setState(() {});
  }

  void _saveTrainSearch(String trainName) async {
    final prefs = await SharedPreferences.getInstance();
    savedTrainSearches.add(trainName);
    prefs.setStringList('savedTrainSearches', savedTrainSearches);
    print("saved train details"+prefs.getStringList('savedStationSearches').toString());
    setState(() {});
  }

  void _performSearchbyFromTo() {
    String from = _fromController.text.trim();
    String to = _toController.text.trim();
    if (from.isNotEmpty && to.isNotEmpty) {
      _saveStationSearch(from, to);
    }
  }




  List<String> _stationNames = [
    'Station 1',
    'Station 2',
    'Station 3',
    'Station 4',
    'Station 5',
  ];

  // String? _selectedFromStation;
  // String? _selectedToStation;
  String? _selectedSearchStation;


  void _swapStations() {
    String fromValue = _selectedFromStation ?? '';
    String toValue = _selectedToStation ?? '';

    // Swap values
    setState(() {
      _selectedFromStation = toValue;
      _selectedToStation = fromValue;
      _fromController.text = toValue;
      _toController.text = fromValue;
    });
  }

  void _performSearch() async {
    // Perform search logic here
    // For example, you can print the values or navigate to another screen
    print('Searching from $_selectedFromStation to $_selectedToStation');
    final prefs = await SharedPreferences.getInstance();
    final newSearch = '$_selectedFromStation to $_selectedToStation';
    savedStationSearches.add(newSearch);
    prefs.setStringList('savedStationSearches', savedStationSearches);
    print("saved train details"+prefs.getStringList('savedStationSearches').toString());
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TypeAheadField<Station?>(
                        suggestionsCallback: (pattern) async {
                          print('Searching for: $pattern'); // Debug print
                          if (pattern.isEmpty) {
                            return [];
                          }
                          return await _stationService.searchStation(pattern);
                        },
                        itemBuilder: (context, Station? suggestion) {
                          return ListTile(
                            title: Text(suggestion?.name ?? ''),
                            subtitle: Text('${suggestion?.code} - ${suggestion?.stateName}'),
                          );
                        },
                        onSuggestionSelected: (Station? suggestion) {
                          setState(() {
                            _selectedFromStation = '${suggestion?.code} - ${suggestion?.stateName}' ?? '';
                            _fromController.text = '${suggestion?.code} - ${suggestion?.stateName}' ?? '';
                          });
                        },
                        hideOnEmpty: true,
                        hideOnLoading: true,
                        hideOnError: true,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _fromController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            hintText: 'From',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedFromStation = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TypeAheadField<Station?>(
                        suggestionsCallback: (pattern) async {
                          print('Searching for: $pattern'); // Debug print
                          if (pattern.isEmpty) {
                            return [];
                          }
                          return await _stationService.searchStation(pattern);
                        },
                        itemBuilder: (context, Station? suggestion) {
                          return ListTile(
                            title: Text(suggestion?.name ?? ''),
                            subtitle: Text('${suggestion?.code} - ${suggestion?.stateName}'),
                          );
                        },
                        onSuggestionSelected: (Station? suggestion) {
                          setState(() {
                            _selectedToStation = suggestion?.name;
                            _toController.text = '${suggestion?.code} - ${suggestion?.stateName}' ?? '';
                          });
                        },
                        hideOnEmpty: true,
                        hideOnLoading: true,
                        hideOnError: true,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _toController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            hintText: 'To',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedToStation = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  top: 35, // Adjust the position to overlap between the fields
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _swapped = !_swapped;
                        _swapStations();
                      });
                    },

                    child: Transform.rotate(
                      angle: -1.5708, // -1.5708 radians = -90 degrees
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue, // Background color
                          shape: BoxShape.circle, // Circular shape
                        ),
                        child: Icon(
                          Icons.swap_horiz,
                          size: 30.0, // Adjust icon size within the container
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performSearch,
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: TypeAheadField<Train?>(
                suggestionsCallback: (pattern) async {
                  print('Searching for: $pattern'); // Debug print
                  if (pattern.isEmpty) {
                    return [];
                  }
                  return await _trainService.searchTrain(pattern);
                },
                itemBuilder: (context, Train? suggestion) {
                  return ListTile(
                    title: Text(suggestion?.trainNumber ?? ''),
                    subtitle: Text('${suggestion?.trainNumber} - ${suggestion?.trainName}'),
                  );
                },
                onSuggestionSelected: (Train? suggestion) {
                  setState(() {
                    _selectedTrain = suggestion?.trainName;
                    _trainController.text = '${suggestion?.trainNumber} - ${suggestion?.trainName}' ?? '';
                  });
                },
                hideOnEmpty: true,
                hideOnLoading: true,
                hideOnError: true,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _trainController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    hintText: 'To',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedTrain = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // ListView.builder(
            //   itemCount: savedTrainSearches.length,
            //   itemBuilder: (context, index) {
            //     // Train train = savedTrainSearches[index];
            //     // return ListTile(
            //     //   title: Text(train.trainName),
            //     //   subtitle: Text('${train.trainNumber} - ${train.trainName}'),
            //     // );
            //   },
            // ),
          ],


        ),
      ),
    );
  }
}