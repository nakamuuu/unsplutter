import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unsplutter/api/photo.dart';
import 'package:unsplutter/api/unsplash_api.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/detail.dart';

class HomeWidget extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text(UnsplutterLocalizations.of(context).trans('app_name')),
        ),
        body: new FutureBuilder<List<Photo>>(
          future: UnsplashApi().getPhotos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new PhotosList(photos: snapshot.data)
                : new Center(child: new CircularProgressIndicator());
          },
        ),
      );
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  const PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) => new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return new InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute<Null>(
                  settings: const RouteSettings(name: "/detail"),
                  builder: (BuildContext context) => new DetailWidget(photo: photos[index]),
                ),
              );
            },
            child: new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: photos[index].urls.small,
              fadeInDuration: Duration(milliseconds: 225),
              fit: BoxFit.cover,
            ),
          );
        },
      );
}
