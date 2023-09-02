import 'dart:convert';

import 'package:vendorandroid/screens/trackservicepayment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class PaidServices extends StatefulWidget {
  String useremail = "";
  String idname = "";
  PaidServices({required this.useremail,required this.idname});

  @override
  _PaidServicesState createState() => _PaidServicesState();
}

class _PaidServicesState extends State<PaidServices> {

  List rawservice = [];
  bool showpaidservices = false;

  Future getpaidservices () async{

    var gettingpaidservices = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorpaidservices.php'),
        body: {
          'useremail':widget.useremail
        }
    );

    if(gettingpaidservices.statusCode == 200){

      setState(() {
        showpaidservices = true;
      });

      print(jsonDecode(gettingpaidservices.body));
      rawservice = jsonDecode(gettingpaidservices.body);

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpaidservices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SafeArea(
          child: Column(
            children: [
              //paid service app bar = paid service text + back button
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, .5),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //paid service text
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Paid Services",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      ),
                    ),
                    //back icon button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Flexible(
                  child:
                showpaidservices ?
                rawservice.length > 0 ?
                RefreshIndicator(
                  onRefresh: getpaidservices,
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                    itemCount: rawservice.length,
                      itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return TrackServicePayment(idname: widget.idname,
                            sidname: rawservice[index]['sidname'],
                          adminemail: rawservice[index]['adminemail'],
                          useremail: rawservice[index]['useremail'],
                          servicename: rawservice[index]['serivename'],
                          amount: rawservice[index]['amount'],
                          date: rawservice[index]['date'],
                          time: rawservice[index]['time'],
                          status: rawservice[index]['status'],
                          description: rawservice[index]['description'],
                          refno: rawservice[index]['refno'],
                          refund: rawservice[index]['refund'],);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                        ),
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              decoration:BoxDecoration(
                                  color:
                                  Color.fromRGBO(2, 176, 9, 1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                              margin: EdgeInsets.only(left: 10),
                              child:
                              Image.asset("assets/topup.png",color: Colors.white,),
                            ),
                            Expanded(
                              child: Container(
                                margin:EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text("Paid to "+rawservice[index]['adminemail'],
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/25,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      child: Text(rawservice[index]['serivename'],style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/26
                                      ),),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      child: Text(rawservice[index]['date']+" "+rawservice[index]["time"],style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/33,
                                        color: Colors.grey
                                      ),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(

                              decoration:BoxDecoration(

                                color: rawservice[index]['status'] == 'pending'?
                                    Colors.yellowAccent
                                    :
                                    Colors.greenAccent,

                                borderRadius: BorderRadius.all(Radius.circular(5))

                              ),

                              margin:EdgeInsets.only(right: 10,left: 10),

                              padding:EdgeInsets.only(left: 15,top:5,right: 15,bottom: 5 ),

                              child: Text("₦"+rawservice[index]['amount'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: rawservice[index]['status'] == 'pending'?
                                    Colors.black
                                    :
                                    Colors.black,
                              ),),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                )
                    :
                Container(
                  child: Center(
                    child: Column(
                      children: [
                        Spacer(),
                        Image.asset("assets/empty.png",
                          width: MediaQuery.of(context).size.width/3,),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text("no paid services",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/30,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                )
                    :
                Container(
                  child: Center(
                    child: Column(
                      children: [
                        Spacer(),
                        // Image.asset("assets/loading.png",
                        //   width: MediaQuery.of(context).size.width/3,),
                        CircularProgressIndicator(
                          color: Colors.orange,
                          backgroundColor: Colors.green,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("loading...",style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/30,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        Spacer(),
                      ],
                    ),
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
