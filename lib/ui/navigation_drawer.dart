import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';
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
      new DrawerHeader(
        child: new Align(
          alignment: Alignment.bottomLeft,
          child: new Container(
            height: 56.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Row(children: [
                  new Text(
                    UnsplutterLocalizations.of(context).trans("app_name"),
                    style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                  ),
                  new Text(
                    UnsplutterLocalizations.of(context).trans("drawer_app_description"),
                    style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white70),
                  ),
                ]),
                new Container(height: 2.0),
                new FutureBuilder<String>(
                  future: PackageInfo.fromPlatform().then((info) => "version ${info.version}"),
                  builder: (context, snapshot) => new Text(
                        snapshot.hasData ? snapshot.data : "",
                        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                      ),
                ),
              ],
            ),
          ),
        ),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('res/image/drawer_header.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
    drawerChildren.addAll(contents.map((content) {
      final bool isSelected = contents.indexOf(content) == currentIndex;
      return new Container(
        decoration: new BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
        ),
        child: new ListTileTheme(
          style: ListTileStyle.drawer,
          selectedColor: Theme.of(context).accentColor,
          child: new ListTile(
            leading: new Icon(content.icon),
            title: new Text(content.drawerLabel),
            selected: isSelected,
            onTap: () {
              Navigator.pop(context);
              onTap(contents.indexOf(content));
            },
          ),
        ),
      );
    }));
    return new Drawer(child: new ListView(padding: EdgeInsets.zero, children: drawerChildren));
  }
}
