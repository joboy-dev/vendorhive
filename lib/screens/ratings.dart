import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class Ratings extends StatefulWidget {
  String pidname = "";
  double finalratings = 0;
  Ratings({required this.pidname,
  required this.finalratings});

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  double lilo = 3.5;
  List rawratings = [];
  bool showratings = false;

  Future getratings() async{

    setState(() {
      showratings = false;
    });

    var getratings = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorviewallratings.php'),
        body: {
          'pidname': widget.pidname
        }
    );

    if(getratings.statusCode == 200){

      setState(() {

        rawratings = jsonDecode(getratings.body);
        showratings = true;

      });

      print(jsonDecode(getratings.body));

    }
    else{

      print("get rattings ${getratings.statusCode}");

    }
  }

  @override
  initState(){
    super.initState();

    getratings();

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: [

              Container(

                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, .5),
                ),

                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                            child: Icon(Icons.arrow_back,
                              color: Colors.black,size: 20,),
                          )
                      ),
                    )
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text('${widget.finalratings}/5.0'),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: RatingBarIndicator(
                        rating: widget.finalratings,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text('${rawratings.length} Verfied ratings'),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20,left: 10),
                child: Text('Comments from verified purchases'),
              ),

              Flexible(
                child:
                showratings ?
                ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: rawratings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black54)
                            )
                        ),
                        margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: RatingBarIndicator(
                                rating: double.parse(rawratings[index]['ratings']),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ),

                            // Container(
                            //   margin: EdgeInsets.only(top: 5),
                            //   child: Text(rawratings[index]['review'],style: TextStyle(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.w500
                            //   ),),
                            // ),

                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(rawratings[index]['comments'],style: TextStyle(
                                fontSize: 14,
                              ),),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(rawratings[index]['dating']+' by '+rawratings[index]['name'],style: TextStyle(
                                  color: Colors.grey,
                                fontSize: 14
                              ),),
                            )

                          ],
                        ),
                      );
                    },
                  )
                  :
                ListView(
                    children: [
                      Container(
                        child: Center(
                          child: Text('loading...',style: TextStyle(
                            fontStyle: FontStyle.italic
                          ),),
                        ),
                      )
                    ],
                  )
              )

            ],
          ),
        ),
      ),
    );
  }
}
