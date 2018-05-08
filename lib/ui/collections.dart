import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unsplutter/api/collection.dart';
import 'package:unsplutter/api/unsplash_api.dart';
import 'package:unsplutter/localizations.dart';
import 'package:unsplutter/ui/photo_detail.dart';
import 'package:unsplutter/util/color_utils.dart';

class CollectionsPage extends StatefulWidget {
  @override
  CollectionsPageState createState() => CollectionsPageState();
}

class CollectionsPageState extends State<CollectionsPage> with TickerProviderStateMixin {
  final String _tabIndexIdentifier = 'collections_tab_index';
  final Key _allTabKey = const PageStorageKey('collections_all');
  final Key _featuredTabKey = const PageStorageKey('collections_featured');
  final Key _curatedTabKey = const PageStorageKey('collections_curated');

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Workaround for https://github.com/flutter/flutter/issues/10969
    final index = PageStorage.of(context).readState(context, identifier: _tabIndexIdentifier) ?? 0;
    _tabController = TabController(
      vsync: this,
      length: 3,
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
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kTextTabBarHeight),
          child: Material(
            color: Theme.of(context).primaryColor,
            elevation: 4.0,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(text: UnsplutterLocalizations.of(context).trans('collections_tab_all')),
                Tab(text: UnsplutterLocalizations.of(context).trans('collections_tab_featured')),
                Tab(text: UnsplutterLocalizations.of(context).trans('collections_tab_curated')),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            FutureBuilder<List<Collection>>(
              future: UnsplashApi().getCollections().then((collections) =>
                  collections.where((collection) => collection?.coverPhoto != null).toList()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? CollectionsListView(key: _allTabKey, collections: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder<List<Collection>>(
              future: UnsplashApi().getFeaturedCollections().then((collections) =>
                  collections.where((collection) => collection?.coverPhoto != null).toList()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? CollectionsListView(key: _featuredTabKey, collections: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder<List<Collection>>(
              future: UnsplashApi().getCuratedCollections().then((collections) =>
                  collections.where((collection) => collection?.coverPhoto != null).toList()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? CollectionsListView(key: _curatedTabKey, collections: snapshot.data)
                    : Center(child: CircularProgressIndicator());
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
  Widget build(BuildContext context) => ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final Collection collection = collections[index];

          final List<Widget> overlayTexts = [];
          overlayTexts.add(Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(collection.user.profileImage.medium),
                radius: 12.0,
              ),
              Container(width: 16.0),
              Text(
                collection.user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
              ),
            ],
          ));
          overlayTexts.add(Container(height: 16.0));
          overlayTexts.add(Text(
            collection.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ));
          overlayTexts.add(Container(height: 8.0));
          final String description = collection.description != null
              ? "${collection.totalPhotos} Photos | ${collection.description}"
              : "${collection.totalPhotos} Photos";
          overlayTexts.add(Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
          ));

          return AspectRatio(
            aspectRatio: collection.coverPhoto.width / collection.coverPhoto.height,
            child: Stack(
              children: <Widget>[
                Container(
                  color: ColorUtils.colorFromHexString(collection.coverPhoto.color),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: collection.coverPhoto.urls.regular,
                    fadeInDuration: Duration(milliseconds: 225),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black45, Colors.black26, Colors.black12, Colors.transparent],
                    ),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: overlayTexts,
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    splashColor: Colors.white10,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // TODO: Create the collection detail page.
                          builder: (BuildContext context) =>
                              PhotoDetailPage(photo: collection.coverPhoto),
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
