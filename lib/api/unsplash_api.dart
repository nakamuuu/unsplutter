import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:unsplutter/api/photo.dart';
import 'package:unsplutter/local_variables.dart';

class UnsplashApi {
  static const baseUrl = 'https://api.unsplash.com';
  static const headers = {'Authorization': "Client-ID ${LocalVariables.unsplashAccessKey}"};

  Future<List<Photo>> getPhotos({perPage: 30}) async {
    final Response response = await get("$baseUrl/photos?per_page=$perPage", headers: headers);
    final List decodedBody = json.decode(utf8.decode(response.bodyBytes));
    return decodedBody.map<Photo>((json) => Photo.fromJson(json)).toList();
  }
}
