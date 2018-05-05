import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:unsplutter/api/collection.dart';
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

  Future<List<Photo>> getCuratedPhotos({perPage: 30}) async {
    final Response response = await get("$baseUrl/photos/curated?per_page=$perPage", headers: headers);
    final List decodedBody = json.decode(utf8.decode(response.bodyBytes));
    return decodedBody.map<Photo>((json) => Photo.fromJson(json)).toList();
  }

  Future<List<Collection>> getCollections({perPage: 30}) async {
    final Response response = await get(
      "$baseUrl/collections?per_page=$perPage",
      headers: headers,
    );
    final List decodedBody = json.decode(utf8.decode(response.bodyBytes));
    return decodedBody.map<Collection>((json) => Collection.fromJson(json)).toList();
  }

  Future<List<Collection>> getFeaturedCollections({perPage: 30}) async {
    final Response response = await get(
      "$baseUrl/collections/featured?per_page=$perPage",
      headers: headers,
    );
    final List decodedBody = json.decode(utf8.decode(response.bodyBytes));
    return decodedBody.map<Collection>((json) => Collection.fromJson(json)).toList();
  }

  Future<List<Collection>> getCuratedCollections({perPage: 30}) async {
    final Response response = await get(
      "$baseUrl/collections/curated?per_page=$perPage",
      headers: headers,
    );
    final List decodedBody = json.decode(utf8.decode(response.bodyBytes));
    return decodedBody.map<Collection>((json) => Collection.fromJson(json)).toList();
  }
}
