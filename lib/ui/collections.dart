import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unsplutter/api/collection.dart';
import 'package:unsplutter/api/unsplash_api.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/detail.dart';
import 'package:unsplutter/util/color_utils.dart';

class CollectionsPage extends StatefulWidget {
  @override
  CollectionsPageState createState() => new CollectionsPageState();
}

class CollectionsPageState extends State<CollectionsPage> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
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
              tabs: [
                new Tab(text: UnsplutterLocalizations.of(context).trans('collections_tab_all')),
                new Tab(
                  text: UnsplutterLocalizations.of(context).trans('collections_tab_featured'),
                ),
                new Tab(text: UnsplutterLocalizations.of(context).trans('collections_tab_curated')),
              ],
            ),
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new FutureBuilder<List<Collection>>(
              future: UnsplashApi().getCollections().then((collections) =>
                  collections.where((collection) => collection?.coverPhoto != null).toList()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new CollectionsListView(collections: snapshot.data)
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
            new FutureBuilder<List<Collection>>(
              future: UnsplashApi().getFeaturedCollections().then((collections) =>
                  collections.where((collection) => collection?.coverPhoto != null).toList()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new CollectionsListView(collections: snapshot.data)
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
            new FutureBuilder<List<Collection>>(
              future: UnsplashApi().getCuratedCollections().then((collections) =>
                  collections.where((collection) => collection?.coverPhoto != null).toList()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new CollectionsListView(collections: snapshot.data)
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
          ],
        ),
      );
}

class CollectionsListView extends StatelessWidget {
  final List<Collection> collections;

  const CollectionsListView({Key key, @required this.collections}) : super(key: key);

  @override
  Widget build(BuildContext context) => new ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final Collection collection = collections[index];

          final List<Widget> overlayTexts = [];
          overlayTexts.add(new Row(
            children: [
              new CircleAvatar(
                backgroundImage: new NetworkImage(collection.user.profileImage.medium),
                radius: 12.0,
              ),
              new Container(width: 16.0),
              new Text(
                collection.user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
              ),
            ],
          ));
          overlayTexts.add(new Container(height: 16.0));
          overlayTexts.add(new Text(
            collection.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ));
          overlayTexts.add(new Container(height: 8.0));
          final String description = collection.description != null
              ? "${collection.totalPhotos} Photos | ${collection.description}"
              : "${collection.totalPhotos} Photos";
          overlayTexts.add(new Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
          ));

          return new AspectRatio(
            aspectRatio: collection.coverPhoto.width / collection.coverPhoto.height,
            child: new Stack(
              children: <Widget>[
                new Container(
                  color: ColorUtils.colorFromHexString(collection.coverPhoto.color),
                  child: new FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: collection.coverPhoto.urls.regular,
                    fadeInDuration: Duration(milliseconds: 225),
                    fit: BoxFit.cover,
                  ),
                ),
                new Container(
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black45, Colors.black26, Colors.black12, Colors.transparent],
                    ),
                  ),
                  padding: new EdgeInsets.all(16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: overlayTexts,
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
                          // TODO: Create the collection detail page.
                          builder: (BuildContext context) =>
                              new DetailWidget(photo: collection.coverPhoto),
                        ),
                      );
                    },
                  ),
                ),
              ],
              fit: StackFit.expand,
            ),
          );
        },
      );
}
