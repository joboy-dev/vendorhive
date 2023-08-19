import 'package:flutter/material.dart';

class NextPageTimer extends StatefulWidget {
  const NextPageTimer({Key? key}) : super(key: key);

  @override
  _NextPageTimerState createState() => _NextPageTimerState();
}

class _NextPageTimerState extends State<NextPageTimer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Center(child: CircularProgressIndicator()),
            Spacer()
          ],
        ),
      ),
    );
  }
}
