class Book {
  int? id;
  String? author;
  String? href;
  String? title;
  String? identifier;
  String? progression;
  String? ext;
  List<int>? cover;

  Book(
      {required this.id,
        required this.author,
        required this.href,
        required this.title,
        required this.identifier,
        required this.progression,
        required this.ext,
        required this.cover});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    href = json['href'];
    title = json['title'];
    identifier = json['identifier'];
    progression = json['progression'];
    ext = json['ext'];
    cover = json['cover'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['author'] = author;
    data['href'] = href;
    data['title'] = title;
    data['identifier'] = identifier;
    data['progression'] = progression;
    data['ext'] = ext;
    data['cover'] = cover;
    return data;
  }
}