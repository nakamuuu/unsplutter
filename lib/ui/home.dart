import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unsplutter/api/photo.dart';
import 'package:unsplutter/api/unsplash_api.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/detail.dart';
import 'package:unsplutter/util/color_utils.dart';

class HomeWidget extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) => new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(UnsplutterLocalizations.of(context).trans('app_name')),
            backgroundColor: Colors.grey.shade900,
            bottom: new TabBar(
              tabs: [
                new Tab(text: "PHOTO"),
                new Tab(text: "CURATED"),
              ],
            ),
          ),
          body: new TabBarView(children: <Widget>[
            new FutureBuilder<List<Photo>>(
              future: UnsplashApi().getPhotos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new PhotosList(photos: snapshot.data)
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
            new FutureBuilder<List<Photo>>(
              future: UnsplashApi().getCuratedPhotos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new PhotosList(photos: snapshot.data)
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
          ]),
        ),
      );
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  const PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) => new ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) => new AspectRatio(
              aspectRatio: photos[index].width / photos[index].height,
              child: new Stack(
                children: <Widget>[
                  new Container(
                    color: ColorUtils.colorFromHexString(photos[index].color),
                    child: new FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: photos[index].urls.regular,
                      fadeInDuration: Duration(milliseconds: 225),
                      fit: BoxFit.cover,
                    ),
                  ),
                  new Material(
                    type: MaterialType.transparency,
                    child: new InkWell(
                      splashColor: Colors.white10,
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new DetailWidget(photo: photos[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                fit: StackFit.expand,
              ),
            ),
      );
}
