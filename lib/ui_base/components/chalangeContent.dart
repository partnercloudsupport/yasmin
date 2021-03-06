import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:yasmin/ui_base/components/login.dart';

class bettleChalane extends StatefulWidget {
  bettleChalane({Key key}) : super(key: key);

  @override
  _bettleChalaneState createState() => _bettleChalaneState();
}

class _bettleChalaneState extends State<bettleChalane> {
  Stopwatch watch = new Stopwatch();
  Timer timer;

  String elapsedTime = '';

  updateTime(Timer timers) {
    setState(() {
      elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
    });
  }

  startWatch() {
    watch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 100), updateTime);
  }

  stopWatch() {
    watch.stop();
    setTime();
  }

  resetWatch() {
    watch.reset();
    setTime();
  }

  @override
  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr:$hundredsStr";
  }

  Future<UserInfo> getUser() async {
    Authentiction auth = new Authentiction();
    FirebaseUser user = await auth.getCurrentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder<UserInfo>(
                          future: getUser(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return new CircleAvatar();
                              case ConnectionState.waiting:
                                return new CircleAvatar();
                              default:
                                if (snapshot.hasError) {
                                  return new CircleAvatar();
                                } else {
                                  return new CircleAvatar(
                                    maxRadius: 35.0,
                                    backgroundImage:
                                    NetworkImage(snapshot.data.photoUrl),
                                    backgroundColor: Colors.white,
                                  );
                                }
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<UserInfo>(
                          future: getUser(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return new Text('Name Not Found',
                                    style: TextStyle(color: Colors.white));
                              case ConnectionState.waiting:
                                return new Text('load name..',
                                    style: TextStyle(color: Colors.white));
                              default:
                                if (snapshot.hasError) {
                                  return new Text('Load Errors',
                                      style: TextStyle(color: Colors.white));
                                } else {
                                  return new Text(snapshot.data.displayName,
                                      style: TextStyle(color: Colors.white));
                                }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            'VS',
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          child: CircleAvatar(
                            maxRadius: 35.0,
                            backgroundImage: NetworkImage(
                                'https://cdn3.iconfinder.com/data/icons/business-and-finance-icons/512/Business_Man-512.png'),
                            backgroundColor: Colors.white,
                          ),
                          onTap: () {
                            print('Change User');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Atlet Names',
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new FlatButton(
                          child: Icon(Icons.play_arrow,
                              size: 40.0, color: Colors.green),
                          onPressed: startWatch,
                        ),
                        SizedBox(width: 20.0),
                        new FlatButton(
                          child:
                              Icon(Icons.pause, size: 40.0, color: Colors.red),
                          onPressed: stopWatch,
                        ),
                        SizedBox(width: 20.0),
                        new FlatButton(
                          child: Icon(Icons.refresh,
                              size: 40.0, color: Colors.blue),
                          onPressed: resetWatch,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Text(
                      elapsedTime,
                      style: TextStyle(color: Colors.white, fontSize: 40.0),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}


class atletEnemi extends StatefulWidget {
  @override
  _atletEnemiState createState() => _atletEnemiState();
}

class _atletEnemiState extends State<atletEnemi> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        
      },
    );
  }
}
