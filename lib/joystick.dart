import 'package:flutter/material.dart';
import 'websocket.dart';
import 'dart:async';

class JoyStick extends StatefulWidget {
  JoyStick({Key key, this.url}) : super(key: key);

  var url;
  _JoyStickState createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick> {
  double _ySpeed = 0;
  double _xSpeed = 0;
  double _xStart = 0;
  double _yStart = 0;
  bool connected = false;
  Timer timer;

  Websocket ws = new Websocket();

  startTimer() {
    timer = new Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      ws.sendData(_xSpeed - _xStart, _yStart - _ySpeed);
    });
  }

  stopTimer() {
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 300,
        child: CustomPaint(
          foregroundPainter: new MyPainter(
            xSpeed: _xSpeed,
            xStart: _xStart,
            ySpeed: _ySpeed,
            yStart: _yStart,
          ),
          child: Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('drag me'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Row(
                  children: <Widget>[
                    Text(
                        connected ? 'connected to the server' : 'not connected')
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'double tap for ${connected ? 'disconnecting' : 'connecting'}')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onVerticalDragStart: (e) {
        RenderBox getBox = context.findRenderObject();
        var local = getBox.globalToLocal(e.globalPosition);
        setState(() {
          _yStart = local.dy;
          _xStart = local.dx;
        });
      },
      onVerticalDragUpdate: (e) {
        RenderBox getBox = context.findRenderObject();
        var local = getBox.globalToLocal(e.globalPosition);
        setState(() {
          _ySpeed = local.dy;
          _xSpeed = local.dx;
        });
        ws.sendData(_xSpeed - _xStart, _yStart - _ySpeed);
      },
      onVerticalDragEnd: (e) {
        setState(() {
          _ySpeed = 0;
          _yStart = 0;
          _xStart = 0;
          _xSpeed = 0;
        });

        ws.sendData(0, 0);
      },
      onDoubleTap: () {
        if (ws.isConnected()) {
          ws.disconnect();
          setState(() {
            connected = false;
          });
          stopTimer();
        } else {
          ws.connect(widget.url, (bl) {
            setState(() {
              connected = bl;
            });
          });
        }
      },
    );
  }
}

class MyPainter extends CustomPainter {
  double ySpeed;
  double xSpeed;
  double xStart;
  double yStart;
  MyPainter({this.xSpeed, this.yStart, this.xStart, this.ySpeed});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    Paint complete = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.5)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    Paint stick = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.5)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Paint outer = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 1)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Offset center = new Offset(xStart, yStart);
    Offset completed = new Offset(xSpeed, ySpeed);

    if (ySpeed != 0 && xSpeed != 0) {
      canvas.drawCircle(completed, 10, complete);
      canvas.drawLine(center, completed, stick);
    }
    if (xStart != 0 && yStart != 0) {
      canvas.drawCircle(center, 100, outer);
      canvas.drawCircle(center, 5, line);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
