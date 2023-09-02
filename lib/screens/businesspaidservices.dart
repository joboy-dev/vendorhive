import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/trackbusinessservicepayment.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/trackservicepayment.dart';

class BusinessPaidServices extends StatefulWidget {
  String useremail = "";
  String idname = "";
  BusinessPaidServices({Key? key,
    required this.useremail,required this.idname}) : super(key: key);

  @override
  _BusinessPaidServicesState createState() => _BusinessPaidServicesState();
}

class _BusinessPaidServicesState extends State<BusinessPaidServices> {

  List raw = [];
  bool showpaidservices = false;

  Future paidservices()async{
    var gettingpaidservices = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorbussinesspaidservice.php'),
        body: {
          'adminemail':widget.useremail
        }
    );

    if(gettingpaidservices.statusCode == 200) {

      print(jsonDecode(gettingpaidservices.body));

      setState(() {
        showpaidservices = true;
        raw = jsonDecode(gettingpaidservices.body);
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paidservices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //vendor paid service app bar
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, .5),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Paid Services",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),),
                    ),
                  ),
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
            //list of all paid services to vendor
            Flexible(
                child:
                showpaidservices ?
                raw.length > 0 ?
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: RefreshIndicator(
                    onRefresh: paidservices,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: raw.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return TrackBusinessServicePayment(idname: widget.idname,
                                  sidname: raw[index]['sidname'],
                                  adminemail: raw[index]['adminemail'],
                                  useremail: raw[index]['useremail'],
                                  servicename: raw[index]['serivename'],
                                  amount: raw[index]['amount'],
                                  date: raw[index]['date'],
                                  time: raw[index]['time'],
                                  status: raw[index]['status'],
                                  description: raw[index]['description'],
                                  refno: raw[index]['refno'],
                                  refund: raw[index]['refund'],);
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Container(
                                    width: MediaQuery.of(context).size.width/7,
                                    decoration:BoxDecoration(
                                        color:
                                        Color.fromRGBO(2, 176, 9, 1),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding:EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                                    margin: EdgeInsets.only(left: 10),
                                    child:
                                    Image.asset("assets/paid.png",color: Colors.white,),
                                  ),

                                  Expanded(
                                    child: Container(
                                      margin:EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [

                                          Container(
                                            child: Text("Payment from "+raw[index]['useremail'],
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width/28,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                          ),

                                          SizedBox(height: 2,),

                                          Container(
                                            child: Text(raw[index]['description'],style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width/31
                                            ),),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [

                                        Container(
                                          decoration:BoxDecoration(

                                              color: raw[index]['status'] == 'pending'?
                                              Colors.yellowAccent : Colors.greenAccent,

                                              borderRadius: BorderRadius.all(Radius.circular(5))

                                          ),

                                          margin:EdgeInsets.only(right: 10,left: 20),

                                          padding:EdgeInsets.only(left: 15,top:5,right: 15,bottom: 5 ),

                                          child: Text("₦"+raw[index]['amount']
                                              .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                  (Match m) => '${m[1]},'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:  raw[index]['status'] == 'pending' ?
                                                Colors.black : Colors.black,
                                                fontSize: MediaQuery.of(context).size.width/25
                                            ),),

                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
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
                        CircularProgressIndicator(
                          color: Colors.orange,
                          backgroundColor: Colors.green,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("loading.....",style: TextStyle(
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
            )
          ],
        ),
      ),
    );
  }
}
