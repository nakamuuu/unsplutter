import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unsplutter/api/photo.dart';
import 'package:unsplutter/api/unsplash_api.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/photo_detail.dart';
import 'package:unsplutter/util/color_utils.dart';

class PhotosPage extends StatefulWidget {
  @override
  PhotosPageState createState() => new PhotosPageState();
}

class PhotosPageState extends State<PhotosPage> with TickerProviderStateMixin {
  final String _tabIndexIdentifier = 'photos_tab_index';
  final Key _allTabKey = const PageStorageKey('photos_all');
  final Key _curatedTabKey = const PageStorageKey('photos_curated');

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Workaround for https://github.com/flutter/flutter/issues/10969
    final index = PageStorage.of(context).readState(context, identifier: _tabIndexIdentifier) ?? 0;
    _tabController = new TabController(
      vsync: this,
      length: 2,
      initialIndex: index,
    )..addListener(() {
        PageStorage
            .of(context)
            .writeState(context, _tabController.index, identifier: _tabIndexIdentifier);
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new PreferredSize(
          preferredSize: new Size.fromHeight(kTextTabBarHeight),
          child: new Material(
            color: Theme.of(context).primaryColor,
            elevation: 4.0,
            child: new TabBar(
              controller: _tabController,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              tabs: [
                new Tab(text: UnsplutterLocalizations.of(context).trans('photos_tab_all')),
                new Tab(text: UnsplutterLocalizations.of(context).trans('photos_tab_curated')),
              ],
            ),
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new FutureBuilder<List<Photo>>(
              future: UnsplashApi().getPhotos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new PhotosListView(key: _allTabKey, photos: snapshot.data)
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
            new FutureBuilder<List<Photo>>(
              future: UnsplashApi().getCuratedPhotos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new PhotosListView(key: _curatedTabKey, photos: snapshot.data)
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
          ],
        ),
      );
}

class PhotosListView extends StatelessWidget {
  final List<Photo> photos;

  const PhotosListView({Key key, @required this.photos}) : super(key: key);

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
                              new PhotoDetailPage(photo: photos[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
              fit: StackFit.expand,
            ),
          ));
}
