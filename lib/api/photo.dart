class Photo {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int width;
  final int height;
  final String color;
  final String description;
  final Urls urls;
  final User user;

  const Photo(this.id, this.createdAt, this.updatedAt, this.width, this.height, this.color,
      this.description, this.urls, this.user);

  static fromJson(json) => Photo(
        json['id'],
        DateTime.parse(json['created_at']),
        DateTime.parse(json['updated_at']),
        json['width'],
        json['height'],
        json['color'],
        json['description'],
        Urls.fromJson(json['urls']),
        User.fromJson(json['user']),
      );
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

class User {
  final String id;
  final String username;
  final String name;
  final String bio;
  final ProfileImage profileImage;

  const User(this.id, this.username, this.name, this.bio, this.profileImage);

  static fromJson(json) => User(
        json['id'],
        json['username'],
        json['name'],
        json['bio'],
        ProfileImage.fromJson(json['profile_image']),
      );
}

class ProfileImage {
  final String small;
  final String medium;
  final String large;

  const ProfileImage(this.small, this.medium, this.large);

  static fromJson(json) => ProfileImage(
        json['small'],
        json['medium'],
        json['large'],
      );
}
