import 'dart:io';
import 'dart:math';

typedef void BoolCB(bool bl);

class Websocket {
  Socket socket;

  void connect(String url, BoolCB cb) async {
    Socket.connect(url, 6969).then((socket) {
      this.socket = socket;
      cb(true);
    }).catchError(() {
      cb(false);
    });
  }

  void disconnect() {
    if (socket != null) {
      socket.destroy();
      socket = null;
    }
  }

  void sendData(double x, double y) {
    if (socket != null) {
      socket.write(this.calcMotorPower(x, y).toString());

      ;
    }
  }

  bool isConnected() {
    return socket != null;
  }

  Map calcMotorPower(double x, double y) {
    double length;
    if (sqrt((x * x) + (y * y)) > 100) {
      length = 1;
    } else {
      length = sqrt((x * x) + (y * y)) / 100;
    }

    double angle = atan2(y, x) * (180 / pi);
    double rightPower;
    double leftPower;

    if (angle >= 0 && angle < 90) {
      rightPower = length;
    } else if (angle >= 90 && angle < (135)) {
      rightPower = length * (1 - ((angle - 90) / ((135 - 90))));
    } else if (angle >= (135) && angle <= 180) {
      rightPower = length * (-((angle - 135) / (180 - 135)));
    } else if (angle >= -180 && angle < -90) {
      rightPower = -length;
    } else if (angle >= -90 && angle < -45) {
      rightPower = length * (-1 - ((angle + 90) / (-90 + 45)));
    } else {
      rightPower = length * (1 + (angle / (45)));
    }

    if (angle >= 0 && angle < 45) {
      leftPower = length * -(1 - (angle / (45)));
    } else if (angle >= 45 && angle < (90)) {
      leftPower = length * (((angle - 45) / (90 - 45)));
    } else if (angle >= 90 && angle <= 180) {
      leftPower = length;
    } else if (angle >= -180 && angle < -135) {
      leftPower = length * -((angle + (135)) / (45));
    } else if (angle >= -135 && angle < -90) {
      leftPower = length * (-1 - ((angle + (90)) / (45)));
    } else {
      leftPower = -length;
    }

    return {'"leftPower"': rightPower, '"rightPower"': leftPower};
  }
}
