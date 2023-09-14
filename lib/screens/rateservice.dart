import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/rateservicedone.dart';

class RateService extends StatefulWidget {
  String serviceimage = "";
  String sidname = "";
  String adminemail = "";
  String useremail = "";
  String servicename = "";
  RateService({required this.serviceimage,
    required this.sidname,
    required this.adminemail,
    required this.useremail,
    required this.servicename});

  @override
  _RateServiceState createState() => _RateServiceState();
}

class _RateServiceState extends State<RateService> {
  double ratings = 0.0;
  int _selectedpage = 0;
  bool processingrating = false;
  TextEditingController _name = new TextEditingController();
  TextEditingController _reviews = new TextEditingController();
  TextEditingController _comment = new TextEditingController();

  Future processratings () async{
    print("Processing ratings");
    setState(() {
      _selectedpage = 1;
      processingrating = true;
    });
    var ratingandreviews = await http.post(Uri.https('adeoropelumi.com','vendor/vendorrating.php'),body: {
      'useremail':widget.useremail,
      'adminemail':widget.adminemail,
      'productname':widget.servicename,
      'pidname':widget.sidname,
      'name':_name.text,
      'review':_reviews.text,
      'comments':_comment.text,
      'ratings': ratings.toString(),
    });

    if(ratingandreviews.statusCode == 200){
      if(jsonDecode(ratingandreviews.body)=='true'){
        setState(() {
          processingrating = false;
          _selectedpage = 0;
        });
        _name.clear();
        _reviews.clear();
        _comment.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return RateServiceDone();
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, .5),
              ),
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Rate "+widget.servicename,
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
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        )
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12
                    ),
                    height: MediaQuery.of(context).size.height/3.5,
                    child: Image.asset('assets/vendo.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                    child: Text('Name'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: _name,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(

                          ),
                          focusedBorder: OutlineInputBorder(

                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                    child: Text('Review'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: _reviews,
                      decoration: InputDecoration(
                          hintText: 'I like it',
                          enabledBorder: OutlineInputBorder(

                          ),
                          focusedBorder: OutlineInputBorder(

                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                    child: Text('Comment'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      maxLines: null,
                      controller: _comment,
                      decoration: InputDecoration(
                          hintText: 'I love it, it is one of the best products have used',
                          enabledBorder: OutlineInputBorder(

                          ),
                          focusedBorder: OutlineInputBorder(

                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                    child: Text('Ratings'),
                  ),
                  Container(
                    child: RatingBar.builder(
                      initialRating: 0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                        ratings = rating;
                        print(ratings);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(_name.text.isEmpty || _comment.text.isEmpty||
                          _reviews.text.isEmpty){
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text('Fill all fields'),
                            ));
                      }else{
                        processratings();
                      }

                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 13,bottom: 20),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color:
                          Color.fromRGBO(246, 123, 55, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text(processingrating?'loading...':"Rate Service",style: TextStyle(
                            color: Colors.white,
                            fontStyle: processingrating? FontStyle.italic:FontStyle.normal,
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
      :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height/3,
            child: SpinKitFadingCube(
              color: Colors.orange,
              size: 100,
            ),
          ),
          Container(
            child: Text("Rating service", style: TextStyle(
                color: Color.fromRGBO(246, 123, 55, 1),
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width/26
            ),),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Center(
              child: Text('Vendorhive 360',
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold
                ),),
            ),
          )
        ],
      ),
    );
  }
}
