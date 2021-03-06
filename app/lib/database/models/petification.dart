class Petification {
  final int id;
  final int petId;
  final String description;
  final int unixTime;

  Petification({
    required this.id,
    required this.petId,
    required this.description,
    required this.unixTime,
  });

  Petification.fromMap(Map<String, dynamic> queryResult)
      : id = queryResult['id'],
        petId = queryResult['petId'],
        description = queryResult['description'],
        unixTime = queryResult['unixTime'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'description': description,
      'unixTime': unixTime,
    };
  }
}
