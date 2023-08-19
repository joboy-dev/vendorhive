import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  String email = "";
  Notifications({required this.email});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List rawnotes = [];
  bool shownotes = false;

  Future getnotes() async{
    print(widget.email);

    var getnote = await http.post(Uri.https('adeoropelumi.com','vendor/vendornotes.php'),body: {
      'email': widget.email
    });

    if(getnote.statusCode == 200){
      setState((){
        rawnotes = jsonDecode(getnote.body);
        shownotes = true;
      });
      print(jsonDecode(getnote.body));
    }
  }

  @override
  initState(){
    super.initState();
    getnotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    child: Text("Notifications",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),),
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
                child:
              shownotes ?
              ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                   itemCount: rawnotes.length,
                   itemBuilder: (context,index){
                    return Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 252, 233, 1),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey,
                                  width: .5
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10,bottom: 10,left: 20,right: 15),
                            child: CircleAvatar(
                                radius: MediaQuery.of(context).size.width/15,
                                backgroundColor: Colors.black,
                                child:
                                Image.asset(
                                  rawnotes[index]['tag'] == 'product' ?
                                "assets/shopping-bag.png"
                                  :
                                  rawnotes[index]['tag'] == 'product promotion' ?
                                "assets/product-promote.png"
                                  :
                                  rawnotes[index]['tag'] == 'topup' ?
                                  "assets/banknote.png"
                                  :
                                  "assets/money-withdrawal.png",
                                  width: MediaQuery.of(context).size.width/13,
                                  color: Colors.white,)
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(child: Text(rawnotes[index]['notifymsg'],style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                  ),)),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(rawnotes[index]['date']+" "+rawnotes[index]['secondtime'],style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                   },
                )
                  :
              Container(
                    child: Center(
                      child: Text('loading...',style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14
                      ),),
                    ),
                  )
            )
          ],
        ),
      ),
    );
  }
}
