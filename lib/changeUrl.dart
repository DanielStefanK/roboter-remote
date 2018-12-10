import 'package:flutter/material.dart';

typedef void SaveCallback(String http, String ws);

class ChangeUrl extends StatefulWidget {
  ChangeUrl({Key key, this.httpUrl, this.wsUrl, this.save}) : super(key: key);

  final httpUrl;
  final wsUrl;
  SaveCallback save;

  _ChangeUrlState createState() => _ChangeUrlState();
}

class _ChangeUrlState extends State<ChangeUrl> {
  final _httpC = TextEditingController();
  final _wsC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _httpC.text = widget.httpUrl;
    _wsC.text = widget.wsUrl;

    return Container(
      child: AlertDialog(
        title: Text('Change the url'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: _httpC,
                decoration: InputDecoration(hintText: 'HTTP-URL'),
              ),
              TextField(
                controller: _wsC,
                decoration: InputDecoration(hintText: 'WS-URL'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              widget.save(_httpC.text, _wsC.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
