class Photo {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int width;
  final int height;
  final String color;
  final String description;
  final Urls urls;

  Photo(this.id, this.createdAt, this.updatedAt, this.width, this.height, this.color,
      this.description, this.urls);

  static fromJson(json) => Photo(
      json['id'],
      DateTime.parse(json['created_at']),
      DateTime.parse(json['updated_at']),
      json['width'],
      json['height'],
      json['color'],
      json['description'],
      Urls.fromJson(json['urls']));
}

class Urls {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  const Urls(this.raw, this.full, this.regular, this.small, this.thumb);

  static fromJson(json) => Urls(
        json['raw'],
        json['full'],
        json['regular'],
        json['small'],
        json['thumb'],
      );
}
