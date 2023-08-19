import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendorandroid/screens/nextpagetimer.dart';

class TestTimer extends StatefulWidget {
  const TestTimer({Key? key}) : super(key: key);

  @override
  _TestTimerState createState() => _TestTimerState();
}

class _TestTimerState extends State<TestTimer> {
  int sec = 0;
  bool cancelTimer = false;

  void calltimer() {
    Timer.periodic(Duration(seconds: 5), (timer) {

      if (mounted) {

        setState(() {
          sec++;
        });

        print(sec);

      }

      if (cancelTimer) {

        timer.cancel();
        print(sec);

        print("timer is done");

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return NextPageTimer();
        }));

      }
    });
  }

  @override
  initState(){
    super.initState();
    calltimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Center(
              child: Text(sec.toString()),
            ),
            GestureDetector(
              onTap: (){

                setState(() {
                  cancelTimer = true;
                });

                print("Stop timer");

              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black
                  )
                ),
                child: Text('Stop timer'),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
