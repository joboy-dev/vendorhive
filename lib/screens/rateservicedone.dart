import 'package:flutter/material.dart';

class RateServiceDone extends StatefulWidget {
  const RateServiceDone({Key? key}) : super(key: key);

  @override
  _RateServiceDoneState createState() => _RateServiceDoneState();
}

class _RateServiceDoneState extends State<RateServiceDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.orange.shade100,
                  Colors.green.shade100
                ]
            )
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/3,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Image.asset('assets/vendo.png'),
                        ),
                      ),
                      Container(

                        child: Text('Thanks for your review and ratings',style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepOrange
                        ),),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 10),
                          child: Text('Back',style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
