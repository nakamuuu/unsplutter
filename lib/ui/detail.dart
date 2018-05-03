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
      contents.add(new AvatarListItem(imageUrl: profileImage.medium, text: photo.user.name));
    } else {
      contents.add(new DetailListItem(icon: Icons.person, text: photo.user.name));
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
    contents.add(new DetailListItem(
      icon: Icons.photo_size_select_large,
      text: "${photo.width}px x ${photo.height}px",
    ));
    contents.add(new DetailListItem(
      icon: Icons.access_time,
      text: DateFormat('yyyy/MM/dd HH:mm').format(photo.createdAt.toLocal()),
    ));
    contents.add(new Container(height: 8.0));
    return contents;
  }
}

class AvatarListItem extends StatelessWidget {
  final String imageUrl;
  final String text;

  const AvatarListItem({Key key, this.imageUrl, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => new Container(
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              backgroundImage: new NetworkImage(imageUrl),
              radius: 20.0,
            ),
            new Container(
              child: new Text(text, style: Theme.of(context).textTheme.subhead),
              margin: new EdgeInsets.only(left: 16.0),
            )
          ],
        ),
        height: 56.0,
        padding: new EdgeInsets.symmetric(horizontal: 16.0),
      );
}

class DetailListItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailListItem({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => new Container(
        child: new Row(
          children: <Widget>[
            new Icon(icon, color: Colors.black54),
            new Container(
              child: new Text(text, style: Theme.of(context).textTheme.subhead),
              margin: new EdgeInsets.only(left: 32.0),
            )
          ],
        ),
        height: 48.0,
        padding: new EdgeInsets.symmetric(horizontal: 16.0),
      );
}
