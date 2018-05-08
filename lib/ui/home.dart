import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/collections.dart';
import 'package:unsplutter/ui/home_content.dart';
import 'package:unsplutter/ui/navigation_drawer.dart';
import 'package:unsplutter/ui/photos.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<HomeContent> _contents;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_contents == null) {
      _contents = [
        HomeContent(
          Icons.home,
          UnsplutterLocalizations.of(context).trans('home'),
          UnsplutterLocalizations.of(context).trans('app_name'),
          true,
          (() => PhotosPage()),
        ),
        HomeContent(
          Icons.collections,
          UnsplutterLocalizations.of(context).trans('collections'),
          UnsplutterLocalizations.of(context).trans('collections'),
          true,
          (() => CollectionsPage()),
        ),
      ];
    }

    return Scaffold(
      drawer: NavigationDrawer(
        contents: _contents,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      appBar: AppBar(
        title: Text(_contents[_currentIndex].title),
        elevation: _contents[_currentIndex].hasTab ? 0.0 : 4.0,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: _contents[_currentIndex].body(),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Don't exit the app when pushing back other than the home page.
    if (_currentIndex == 0 || Navigator.canPop(context)) {
      // Make default behaviors when the drawer is open or on the home page.
      return true;
    } else {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
  }
}
