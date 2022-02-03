class Pet {
  final int id;
  final String name;
  final int unixBirthdate;

  Pet({
    required this.id,
    required this.name,
    this.unixBirthdate = 0,
  });

  bool hasBirthdate() => unixBirthdate > 0;

  Pet.fromMap(Map<String, dynamic> queryResult)
      : id = queryResult["id"],
        name = queryResult["name"],
        unixBirthdate = queryResult["unixBirthdate"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unixBirthdate': unixBirthdate,
    };
  }
}
