import 'package:flutter/material.dart';

class Ratingsdone extends StatefulWidget {
  const Ratingsdone({Key? key}) : super(key: key);

  @override
  _RatingsdoneState createState() => _RatingsdoneState();
}

class _RatingsdoneState extends State<Ratingsdone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
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
                            margin: EdgeInsets.only(top: 10),
                            child: Center(child:
                            Text('Back',style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),),
                            ),
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
      ),
    );
  }
}
