class Station {
  final String name;
  final String engName;
  final String code;
  final String stateName;

  Station({
    required this.name,
    required this.engName,
    required this.code,
    required this.stateName,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['name'] ?? '',
      engName: json['eng_name'] ?? '',
      code: json['code'] ?? '',
      stateName: json['state_name'] ?? '',
    );
  }
}
