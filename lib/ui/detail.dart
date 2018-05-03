import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unsplutter/api/photo.dart';

class DetailWidget extends StatelessWidget {
  final Photo photo;

  const DetailWidget({Key key, this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Move the color parsing process to another layer
    final normalizedColorString = "FF${photo.color.substring(photo.color.length - 6)}";
    final imageColor = new Color(int.parse(normalizedColorString, radix: 16));
    return new Scaffold(
      body: new CustomScrollView(
        primary: true,
        slivers: <Widget>[
          new SliverAppBar(
            backgroundColor: imageColor,
            expandedHeight: MediaQuery.of(context).size.width / photo.width * photo.height,
            pinned: true,
            flexibleSpace: new FlexibleSpaceBar(
              background: new FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: photo.urls.regular,
                fadeInDuration: Duration(milliseconds: 225),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new SliverSafeArea(
            top: false,
            sliver: new SliverList(
              delegate: new SliverChildListDelegate(createListContent(context)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> createListContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profileImage = photo.user.profileImage;
    final description = photo.description ?? "Photo by ${photo.user.name}";

    final List<Widget> contents = [];
    contents.add(new Container(
      decoration: new BoxDecoration(color: Colors.grey.shade100),
      padding: new EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: new Text(
        description,
        style: textTheme.title.copyWith(letterSpacing: 1.2, height: 1.2),
      ),
    ));
    contents.add(new Container(height: 8.0));
    if (photo.user.profileImage != null) {
      contents.add(new ListTile(
        leading: new CircleAvatar(
          backgroundImage: new NetworkImage(profileImage.medium),
          radius: 20.0,
        ),
        title: new Text(photo.user.name),
      ));
    } else {
      contents.add(new ListTile(
        leading: new Icon(Icons.person, color: Colors.black54),
        title: new Text(photo.user.name),
      ));
    }
    if (photo.user.bio != null) {
      contents.add(new Padding(
        padding: new EdgeInsets.only(left: 72.0, right: 16.0),
        child: new Text(photo.user.bio, style: textTheme.body1.copyWith(color: Colors.black54)),
      ));
    }
    contents.add(new Container(height: 16.0));
    contents.add(new Divider(height: 0.0, indent: 72.0));
    contents.add(new Container(height: 8.0));
    contents.add(new ListTile(
      leading: new Icon(Icons.photo_size_select_large, color: Colors.black54),
      title: new Text("${photo.width}px x ${photo.height}px"),
    ));
    contents.add(new ListTile(
      leading: new Icon(Icons.access_time, color: Colors.black54),
      title: new Text(DateFormat('yyyy/MM/dd HH:mm').format(photo.createdAt.toLocal())),
    ));
    contents.add(new Container(height: 8.0));
    return contents;
  }
}
