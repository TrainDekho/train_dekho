class Train {
  final String trainNumber;
  final String trainName;
  final String engTrainName;
  final String newTrainNumber;

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.engTrainName,
    required this.newTrainNumber,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainNumber: json['train_number'],
      trainName: json['train_name'],
      engTrainName: json['eng_train_name'],
      newTrainNumber: json['new_train_number'] ?? '',
    );
  }
}
