import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/ratingdone.dart';

class Rateproduct extends StatefulWidget {
  String productimage = "";
  String pidname = "";
  String adminemail = "";
  String useremail = "";
  String productname = "";
  Rateproduct({required this.productimage,
  required this.pidname,
  required this.adminemail,
  required this.useremail,
  required this.productname});

  @override
  _RateproductState createState() => _RateproductState();
}

class _RateproductState extends State<Rateproduct> {
  double ratings = 0.0;
  bool processingrating = false;
  TextEditingController _name = new TextEditingController();
  TextEditingController _reviews = new TextEditingController();
  TextEditingController _comment = new TextEditingController();

  Future processratings () async{
    print("Processing ratings");

    setState(() {
      processingrating = true;
    });

    var ratingandreviews = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorrating.php'),
        body: {
          'useremail':widget.useremail,
          'adminemail':widget.adminemail,
          'productname':widget.productname,
          'pidname':widget.pidname,
          'name':_name.text,
          'review':_reviews.text,
          'comments':_comment.text,
          'ratings': ratings.toString(),
        }
    );

    if(ratingandreviews.statusCode == 200){
      if(jsonDecode(ratingandreviews.body)=='true'){
        setState(() {
          processingrating = false;
        });
        _name.clear();
        _reviews.clear();
        _comment.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Ratingsdone();
        }));
      }
    }
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
                padding: EdgeInsets.only(top: 15, bottom: 15),
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
                          color: Colors.grey
                      ),
                      height: MediaQuery.of(context).size.height/2.5,
                      child: FadeInImage(
                        image: NetworkImage("https://adeoropelumi.com/vendor/productimage/"+
                            widget.productimage),
                        placeholder: AssetImage(
                            "assets/image.png"),
                        imageErrorBuilder:
                            (context, error, stackTrace) {
                          return Image.asset(
                              'assets/error.png',
                              fit: BoxFit.fitWidth);
                        },

                      ),
                    ),
                    Container(
                      child: Text(widget.productname,textAlign: TextAlign.center,style: TextStyle(
                          fontStyle: FontStyle.italic
                      ),),
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
                          child: Text(processingrating?'loading...':"Rate Product",style: TextStyle(
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
        ),
      ),
    );
  }
}
