import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unsplutter/api/photo.dart';
import 'package:unsplutter/local_variables.dart';

class UnsplashApi {
  static const baseUrl = 'https://api.unsplash.com';
  static const headers = {'Authorization': "Client-ID ${LocalVariables.unsplashAccessKey}"};

  Future<List<Photo>> getPhotos({perPage: 30}) async {
    final response = await http.get("$baseUrl/photos?per_page=$perPage", headers: headers);
    final List<Photo> photos = [];
    for (var json in json.decode(utf8.decode(response.bodyBytes))) {
      photos.add(Photo.fromJson(json));
    }
    return photos;
  }
}
