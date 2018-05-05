import 'package:flutter/material.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/collections.dart';
import 'package:unsplutter/ui/home_content.dart';
import 'package:unsplutter/ui/navigation_drawer.dart';
import 'package:unsplutter/ui/photos.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List<HomeContent> _contents;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_contents == null) {
      _contents = [
        new HomeContent(
          Icons.home,
          UnsplutterLocalizations.of(context).trans('home'),
          UnsplutterLocalizations.of(context).trans('app_name'),
          true,
          (() => new PhotosPage()),
        ),
        new HomeContent(
          Icons.collections,
          UnsplutterLocalizations.of(context).trans('collections'),
          UnsplutterLocalizations.of(context).trans('collections'),
          true,
          (() => new CollectionsPage()),
        ),
      ];
    }

    return new Scaffold(
      drawer: new NavigationDrawer(
        contents: _contents,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      appBar: new AppBar(
        title: new Text(_contents[_currentIndex].title),
        elevation: _contents[_currentIndex].hasTab ? 0.0 : 4.0,
      ),
      body: _contents[_currentIndex].body(),
    );
  }
}
