import 'package:flutter/material.dart';

import 'crossController.dart';
import 'changeUrl.dart';
import 'joystick.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  BuildContext _scaffoldContext;
  String _httpUrl = "http://10.0.2.2:10001";
  String _wsUrl = "ws://10.0.2.2:10001";

  set httpUrl(String url) {
    _httpUrl = url;
  }

  set wsUrl(String url) {
    _wsUrl = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return ChangeUrl(
                    httpUrl: _httpUrl,
                    wsUrl: _wsUrl,
                    save: (String http, String ws) {
                      setState(() {
                        this._httpUrl = http;
                        this._wsUrl = ws;
                      });
                      Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
                        content: Text('URLs saved'),
                      ));
                    },
                  );
                },
              );
            },
          )
        ],
      ),
      body: new Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CrossController(
                url: _httpUrl,
                onError: () {
                  Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Could not reach server'),
                  ));
                },
              ),
              JoyStick(
                url: _wsUrl,
              ),
            ],
          );
        },
      ),
    );
  }
}
