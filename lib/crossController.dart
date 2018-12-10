import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CrossController extends StatefulWidget {
  CrossController({Key key, this.url, this.onError}) : super(key: key);
  final String url;
  VoidCallback onError;

  @override
  _CrossControllerState createState() => _CrossControllerState();
}

class _CrossControllerState extends State<CrossController> {
  double _amount = 500;

  void drive(String direction) async {
    Map data = {"direction": direction, "howmuch": _amount.round()};

    http
        .post(Uri.parse(widget.url), body: data.toString())
        .catchError(widget.onError)
        .timeout(Duration(seconds: 3), onTimeout: widget.onError);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  drive('forward');
                },
                child: Text('☝️'),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  drive('left');
                },
                child: Text('👈'),
              ),
              Text(_amount.round().toString()),
              RaisedButton(
                onPressed: () {
                  drive('right');
                },
                child: Text('👉'),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  drive('backward');
                },
                child: Text('👇'),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Slider(
                value: _amount,
                onChanged: (double amount) {
                  setState(() {
                    _amount = amount;
                  });
                },
                min: 1,
                max: 1000,
              )),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
      ),
    );
  }
}
