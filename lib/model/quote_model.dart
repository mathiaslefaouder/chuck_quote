class Quote {
  final String id;
  final String urlIcon;
  final String value;

  Quote({this.id, this.urlIcon, this.value});

  factory Quote.fromJson(json) {
    print(json);
    return Quote(
        id: json['id'], urlIcon: json['icon_url'], value: json['value']);
  }
}
