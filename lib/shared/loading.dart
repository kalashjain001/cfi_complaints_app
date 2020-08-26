import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  String process;

  Loading(this.process);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              padding: EdgeInsets.all(20),
              child: Text(process),
            ),
            SpinKitChasingDots(
              color: Colors.brown,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
