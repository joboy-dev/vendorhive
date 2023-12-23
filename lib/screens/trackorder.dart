import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/rateproduct.dart';
import 'package:vendorandroid/screens/requestrefund.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrackOrder extends StatefulWidget {

  String productname = "";
  String productid = "";
  String idname = "";
  String useremail = "";
  String amount = "";
  String trackid = "";
  String date = "";
  String adminemail = "";
  String ordershipped = "";
  String orderarrived = "";
  String orderprocessed = "";
  String deliverypayment = "";
  String productpayment = "";
  String timearrived = '';
  String timeshipped = "";
  String timedprelease = "";
  String timepprelease = "";
  String timeordered = "";
  String dateshipped = "";
  String datearrived = "";
  String datedprelease = "";
  String datepprelease = "";
  String productimage = "";
  String deliveryprice = "";
  String tkid = "";
  String quantity = "";
  String username = "";

  TrackOrder({
    required this.username,
    required this.quantity,
    required this.tkid,
    required this.deliveryprice,
    required this.productname,
    required this.idname,
    required this.useremail,
    required this.productid,
    required this.amount,
    required this.trackid,
    required this.date,
    required this.adminemail,
    required this.ordershipped,
    required this.orderarrived,
    required this.orderprocessed,
    required this.deliverypayment,
    required this.productpayment,
    required this.timeshipped,
    required this.timearrived,
    required this.timedprelease,
    required this.timepprelease,
    required this.timeordered,
    required this.datearrived,
    required this.dateshipped,
    required this.datedprelease,
    required this.datepprelease,
    required this.productimage
  });

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  bool rdeliverlypayment = true;
  bool rproductpayment = true;
  String ordershipped = 'undone';
  String orderarrived = 'undone';
  String dpreleased = 'undone';
  String ppreleased = 'undone';
  List rawtracks = [];
  bool ppprocessing = false;
  bool showtracks = true;
  int _selectedPage = 0;

  Future realeasepayment() async{
    setState(() {
      _selectedPage = 1;
    });

    print("processing payment");
    print(widget.productid);
    print(widget.adminemail);
    print(widget.useremail);

    var releasepayment = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorreleasepayment.php'),
        body: {
          'pidname':widget.productid,
          'useremail':widget.useremail,
          'adminemail':widget.adminemail,
          'tkid' : widget.tkid
        }
    );

    var updatebusinesswallet = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorupdatebusinesswallet.php'),
        body: {
          'pidname':widget.productid,
          'useremail':widget.useremail,
          'adminemail':widget.adminemail
        }
    );

    if(releasepayment.statusCode == 200){
      if(jsonDecode(releasepayment.body)=='true'){
        if(updatebusinesswallet.statusCode == 200){
          if(jsonDecode(updatebusinesswallet.body)=='true'){
            print("Wallet is updated");

            setState(() {
              _selectedPage = 0;
              dpreleased = 'done';
              if(dpreleased == 'undone'){
                dpreleased = 'done';
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Congratulations!, Payment is released"))
            );
          }
        }
      }
      else{
        print("no update");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ordershipped = widget.ordershipped;
    orderarrived = widget.orderarrived;
    dpreleased = widget.deliverypayment;
    ppreleased = widget.productpayment;
    showtracks = true;
    print(widget.tkid);
    print(widget.productid);
    print(widget.useremail);
    print(widget.adminemail);
    // gettrackorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedPage ==0 ?
      SafeArea(
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
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Order Status",style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
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
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: showtracks ?
                Text(orderarrived == 'undone' ?
                "Estimated Delivery Time"
                : "Delivered Time",style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/25,
                ),)
                : Icon(Icons.more_horiz),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
              child: Text(widget.datearrived,style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/20,
                fontWeight: FontWeight.w500
              ),),
            ),
            Flexible(
                child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/40,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 252, 233, 1),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  padding: EdgeInsets.only(left: 10,right: 10),
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    children: [
                      //Track order and id
                      Container(
                        padding:EdgeInsets.only(bottom: 20,top: 20),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: .5,
                              color: Colors.black
                            )
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Container(
                              margin:EdgeInsets.only(right: 10),
                              child: Text("Track Order",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/25,
                              ),),
                            ),

                            Expanded(
                              child: Container(
                                child: Text("ID: "+widget.trackid,textAlign: TextAlign.end,style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/25,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500
                                ),),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [

                            Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.check,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width/16,),
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    child: Text("Order Processed",style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/24
                                    ),),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [

                                        Container(
                                          child: Icon(Icons.access_time,
                                            size: 10,
                                          color: Colors.grey,),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.date,style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey
                                          ),),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.timeordered,style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey
                                          ),),
                                        )

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/40,
                      ),
                      Container(
                        child: Row(
                          children: [
                            showtracks ?
                            ordershipped == 'undone' ?
                            Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.more_horiz,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.check,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : CircularProgressIndicator(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              backgroundColor: Colors.white,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Order Shipped",style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/24
                                    ),),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [

                                        ordershipped == 'undone' ?
                                        Container()
                                        : Container(
                                          child: Icon(Icons.access_time,
                                            size: 10,
                                            color: Colors.grey,),
                                        ),

                                        ordershipped == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.dateshipped,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        ),

                                        ordershipped == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.timeshipped,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/40,
                      ),
                      Container(
                        child: Row(
                          children: [
                            showtracks ?
                            orderarrived == 'undone' ?
                            Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.more_horiz,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.check,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : CircularProgressIndicator(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              backgroundColor: Colors.white,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    child: Text("Order Arrived",style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/24,
                                    ),),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [

                                        orderarrived == 'undone' ?
                                        Container()
                                        : Container(
                                          child: Icon(Icons.access_time,
                                            size: 10,
                                            color: Colors.grey,),
                                        ),

                                        orderarrived == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.datearrived,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        ),

                                        orderarrived == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.timearrived,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/40,
                      ),
                      Container(
                        child: Row(
                          children: [

                            showtracks ?
                            dpreleased == 'undone' ?
                            Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.more_horiz,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.check,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : CircularProgressIndicator(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              backgroundColor: Colors.white,
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    child: Text("Product Payment Released",style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/24,
                                    ),),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [

                                        dpreleased == 'undone' ?
                                        Container()
                                        : Container(
                                          child: Icon(Icons.access_time,
                                            size: 10,
                                            color: Colors.grey,),
                                        ),

                                        dpreleased == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.datedprelease,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        ),

                                        dpreleased == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.timedprelease,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/40,
                      ),
                      Container(
                        child: Row(
                          children: [
                            showtracks ?
                            ppreleased == 'undone' ?
                            Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.more_horiz,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : Container(
                              padding:EdgeInsets.all(MediaQuery.of(context).size.width/35),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/10)
                              ),
                              child: Icon(Icons.check,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width/16,),
                            )
                            : CircularProgressIndicator(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              backgroundColor: Colors.white,
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    child: Text("Fund request",style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/24,
                                    ),),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [

                                        ppreleased == 'undone' ?
                                        Container()
                                        : Container(
                                          child: Icon(Icons.access_time,
                                            size: 10,
                                            color: Colors.grey,),
                                        ),

                                        ppreleased == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.datepprelease,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        ),

                                        ppreleased == 'undone' ?
                                        Container()
                                        : Container(
                                          margin: EdgeInsets.only(left: 2),
                                          child: Text(widget.timepprelease,style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey
                                          ),),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/40,
                      ),
                    ],
                  ),
                ),
                
                GestureDetector(
                  onTap: () async {
                    double total = double.parse(widget.amount) + double.parse(widget.deliveryprice);
                    if(dpreleased == 'undone' && widget.ordershipped == 'done' && widget.orderarrived == 'done'){
                      await showDialog(
                        context: context,
                        builder: (cxt) {
                          return AlertDialog(
                            title: Center(
                                child: Text('₦'+total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),)),
                            content: Text('Are you sure want to release the delivery payment?',textAlign: TextAlign.center,),
                            actionsAlignment: MainAxisAlignment.spaceAround,
                            actions: <Widget>[

                              LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.of(cxt).pop();
                                        realeasepayment();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Color.fromRGBO(246, 123, 55, 1)
                                        ),
                                        width: constraints.maxWidth/3,
                                        child: Center(child: Text("Yes",style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),)),
                                      ),
                                    );
                                  }
                              ),
                              LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          ppprocessing = true;
                                          Navigator.of(cxt).pop();
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color.fromRGBO(14, 44, 3, 1),
                                        ),
                                        width: constraints.maxWidth/3,
                                        child: Center(child: Text("No",style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white
                                        ),)),
                                      ),
                                    );
                                  }
                              ),

                            ],
                          );
                        },
                      );
                    }
                    else if(dpreleased == 'done'){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Payment has being released "))
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Can't release payment because order has not arrived"))
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 30),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: dpreleased == 'undone' ?Color.fromRGBO(246, 123, 55, 1):
                        Color.fromRGBO(211, 211, 211, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(dpreleased == 'undone' ?
                      "Release product payment"
                      : "Product payment is released",style: TextStyle(
                          color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/24,
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    if(dpreleased == 'undone'){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return RequestRefund(idname: widget.idname,
                          email: widget.useremail,
                          refno: widget.trackid,
                          amount: widget.amount,
                          adminemail: widget.adminemail,
                          quantity: widget.quantity,
                          username: widget.username,
                          product_name: widget.productname,
                          trackid: widget.trackid,
                        );
                      }));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Opps! Cannot refund. Payment is already released"))
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 10,),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        // color: dpreleased == 'undone' ?Color.fromRGBO(211, 211, 211, 1) :
                        // Color.fromRGBO(14, 44, 3, 1),
                        color: Color.fromRGBO(14, 44, 3, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text("Request refund",style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/24,
                          fontWeight: FontWeight.w500
                      ),),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    if(dpreleased == 'done'){
                      print('Rate product');
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return Rateproduct(productimage: widget.productimage,
                            pidname: widget.productid,
                            adminemail: widget.adminemail,
                            useremail: widget.useremail,
                            productname: widget.productname);
                      }));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opps! Rate when you have released payment'))
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: dpreleased == 'undone' ?Color.fromRGBO(211, 211, 211, 1):
                        Color.fromRGBO(246, 123, 55, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text("Rate Product",textAlign:TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/24,
                          fontWeight: FontWeight.w500
                      ),),
                    ),
                  ),
                ),

              ],
            )
            )
          ],
        ),
      )
      :Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Processing",
                      style: TextStyle(
                          color: Color.fromRGBO(246, 123, 55, 1),
                          fontWeight: FontWeight.bold,
                          fontSize:
                          MediaQuery.of(context).size.width / 26),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        'Vendorhive360',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
