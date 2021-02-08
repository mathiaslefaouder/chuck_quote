class Categorie {
  final String name;

  Categorie({this.name});

  factory Categorie.fromJson(json) {
    print(json);
    return Categorie(name: json);
  }
}
