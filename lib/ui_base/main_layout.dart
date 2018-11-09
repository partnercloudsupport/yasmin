import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yasmin/menu/article.dart';
import 'package:yasmin/menu/userMain.dart';
import 'package:yasmin/ui_base/components/event_card.dart';
import 'package:date_format/date_format.dart';
import 'package:yasmin/ui_base/components/login.dart';

class MainLayout extends StatefulWidget {
  final FirebaseUser user;
  static final String tag = "/MAIN_LAYOUT";

  const MainLayout({Key key, @required this.user}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Widget> refreshPage() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    getUser();
  }

  Future<UserInfo> getUser() async {
    Authentiction auth = new Authentiction();
    FirebaseUser user = await auth.getCurrentUser();
    return user;
  }

  final List<ArticlesList> article = [];

  GlobalKey<ScaffoldState> _drawer = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawer,
      drawer: Opacity(
        opacity: 0.8,
        child: Drawer(
          elevation: 10.0,
          child: drawerMenu(),
        ),
      ),
      body: Container(
        child: Stack(fit: StackFit.expand, children: <Widget>[
          new Image(
            image: new AssetImage("assets/bg3.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          RefreshIndicator(
            notificationPredicate: defaultScrollNotificationPredicate,
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      child: AppBar(
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: Icon(Icons.sort),
                          onPressed: () => _drawer.currentState.openDrawer(),
                        ),
                        title: Center(child: Text('PTMSI')),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              print(formatDate(
                                  new DateTime.now(), [dd, '-', M, '-', yyyy]));
                            },
                          ),
                          Padding(padding: EdgeInsets.only(right: 4.0))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(0.0),
                            iconSize: 50.0,
                            icon: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                              NetworkImage(widget.user.photoUrl),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => usermain()));
                            },
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 18.0)),
                          Text('Hello, ${widget.user.displayName}',
                              style: TextStyle(
                                  fontSize: 28.0, color: Colors.white)),
                          Text(
                            widget.user.email,
                            style:
                            TextStyle(fontSize: 15.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 300.0,
                      padding: EdgeInsets.only(top: 20.0),
                      child: ArticlesList(),
                    ),
                    Container(
                      color: Colors.white70,
                      alignment: Alignment(1, 2),
                      padding: EdgeInsets.all(5.0),
                      height: 50.0,
                      child: FloatingActionButton(
                        elevation: 5.0,
                        child: Icon(Icons.add),
                        onPressed: () {
                          print('Insert Article');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onRefresh: refreshPage,
          ),
        ]),
      ),
    );
  }
}

class ArticlesList extends StatefulWidget {
  ArticlesList({Key key}) : super(key: key);

  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('articles').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
                child: new Text('Loading...',
                    style: TextStyle(color: Colors.white)));
          default:
            return new ListView(
              scrollDirection: Axis.horizontal,
              children:
              snapshot.data.documents.map((DocumentSnapshot document) {
                return Container(
                  padding: EdgeInsets.only(
                      left: 0.0, right: 0.0, bottom: 10.0, top: 10.0),
                  height: 200.0,
                  width: 250.0,
                  child: new FlatButton(
                    padding: EdgeInsets.all(5.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(8.0),
                      elevation: 3.0,
                      color: Colors.white70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.network(
                                document['photoUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20.0, top: 20.0, bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Post Date : ${document['postdate']}'),
                                Padding(padding: EdgeInsets.only(bottom: 5.0)),
                                Text(
                                  document['title'],
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 20.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 5.0)),
                                Container(
                                  width: 80.0,
                                  height: 5.0,
                                  child: Material(
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  articleView(
                                    photoUrl: document['photoUrl'],
                                    title: document['title'],
                                    postdate: document['postdate'],
                                    content: document['content'],
                                  )));
                    },
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class uploadArticle extends StatefulWidget {
  @override
  _uploadArticleState createState() => _uploadArticleState();
}

class _uploadArticleState extends State<uploadArticle> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

