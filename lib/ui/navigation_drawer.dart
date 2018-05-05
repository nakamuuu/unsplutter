import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/home_content.dart';

class NavigationDrawer extends StatelessWidget {
  final List<HomeContent> contents;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavigationDrawer({
    Key key,
    @required this.contents,
    @required this.currentIndex,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerChildren = [
      // TODO: Create formal header content
      new DrawerHeader(
        child: new Text(
          UnsplutterLocalizations.of(context).trans("app_name"),
          style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white),
        ),
        decoration: new BoxDecoration(
          color: Colors.black,
        ),
      ),
    ];
    drawerChildren.addAll(contents.map((content) => new ListTileTheme(
          style: ListTileStyle.drawer,
          selectedColor: Theme.of(context).accentColor,
          child: new ListTile(
            leading: new Icon(content.icon),
            title: new Text(content.drawerLabel),
            selected: contents.indexOf(content) == currentIndex,
            onTap: () {
              Navigator.pop(context);
              onTap(contents.indexOf(content));
            },
          ),
        )));
    return new Drawer(child: new ListView(padding: EdgeInsets.zero, children: drawerChildren));
  }
}
