import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/buyservice.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/servicewalletpayment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/success.dart';

class SelectPayforService extends StatefulWidget {

  String idname = "";
  String useremail = "";
  String adminemail = "";
  String amount = "";
  String desc = "";
  String sidname= "";
  String servicename = "";

  SelectPayforService({Key? key,
    required this.idname,
    required this.useremail,
    required this.adminemail,
    required this.amount,
    required this.desc,
    required this.sidname,
    required this.servicename}) : super(key: key);

  @override
  _SelectPayforServiceState createState() => _SelectPayforServiceState();
}

class _SelectPayforServiceState extends State<SelectPayforService> {

  int _selectedpage = 0;
  String paymentmethod = "wallet";

  String trfid = "";
  String finalbalance = "";
  int itemnumbers = 0;

  void currentdate(){
    print('Timestamp is gotten as refno');
    DateTime now = new DateTime.now();
    print(now.toString());
    timestamp(now.toString());
    trfid = timestamp(now.toString());
    print(trfid);
  }

  String timestamp(String str){
    str = str.replaceAll(":", "");
    str = str.replaceAll("-", "");
    str = str.replaceAll(".", "");
    str = str.replaceAll(" ", "");
    return str;
  }

  Future processpayment() async{

    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();


    print('service payment saved');


    try{

      var savepayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorservicepayment.php'),
          body: {
            'idname': widget.idname,
            'sidname': widget.sidname,
            'useremail':widget.useremail,
            'adminemail': widget.adminemail,
            'servicename':widget.servicename,
            'amount':widget.amount,
            'refNo':trfid,
            'description':widget.desc,
            'status':'complete',
            'refund':'no'
          }
      );

      String itemid = "sv-"+trfid;
      String d = "paid for "+widget.servicename;

      var savetransaction = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorsaveinbusinesswallet.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.useremail,
            'adminemail': widget.adminemail,
            'debit':'0',
            'credit': widget.amount.replaceAll(',', ''),
            'status': 'completed',
            'refno' : trfid,
            'description': d,
            'itemid': itemid
          }
      );

      if(savepayment.statusCode == 200){
        if(jsonDecode(savepayment.body) == 'true'){

          print('service payment saved');

          if(savetransaction.statusCode == 200){

            if(jsonDecode(savetransaction.body)=='true'){

              print('Service is paid for');

              setState(() {
                _selectedpage = 0;
              });

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Success();
              }));

            }
            else{

              setState(() {
                _selectedpage = 0;
              });

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Failed(trfid: trfid);
              }));

            }
          }
          else{

            setState(() {
              _selectedpage = 0;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Failed(trfid: trfid);
            }));

          }
        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
    catch(e){

      print("error is "+e.toString());

      var failedservicepayment = await http.post(
        Uri.https('adeoropelumi.com','vendor/failedservicepayment.php'),
        body: {
          "refno":trfid
        }
      );

      if(failedservicepayment.statusCode == 200){
        if(jsonDecode(failedservicepayment.body) == "true"){

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
  }

  Future process() async{

    setState(() {
      _selectedpage = 1;
    });

    String amt = widget.amount.toString().replaceAll(",", "");
    String amount = double.parse(amt).toStringAsFixed(2);
    double a = double.parse(amount);
    double b = a *100;
    String c = b.toStringAsFixed(0);

    try{

      var paystackpayment = await http.post(
          Uri.https('api.paystack.co','transaction/initialize'),
          body: {
            'amount':c,
            'email':widget.useremail
          },
          headers: {
            'Authorization':'bearer sk_live_399d6462aa7d870cd384139c48709ea9e1ac54f4'
          }
      );

      if(paystackpayment.statusCode == 200){

        print(jsonDecode(paystackpayment.body));
        print(jsonDecode(paystackpayment.body)['status']);
        print(jsonDecode(paystackpayment.body)['data']['authorization_url']);
        print(jsonDecode(paystackpayment.body)['data']['access_code']);
        print(jsonDecode(paystackpayment.body)['data']['reference']);

        String topupurl = jsonDecode(paystackpayment.body)['data']['authorization_url'];
        String initiaterefno = jsonDecode(paystackpayment.body)['data']['reference'];

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>
                BuyService(
                  topuplink: topupurl,
                  refnumber: initiaterefno,
                  idname: widget.idname,
                  useremail: widget.useremail,
                  amount: widget.amount.replaceAll(",", ""),
                  sidname: widget.sidname,
                  adminemail: widget.adminemail,
                  servicename: widget.servicename,
                  desc: widget.desc,
                )
            )
        );

      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out"))
        );

      }

    }
    catch(e){

      setState(() {
        _selectedpage = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request timed out"))
      );

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
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Pay " + widget.adminemail,
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
                  children: [
                    Container(
                      margin:EdgeInsets.only(left: 10,top: 10),
                      child: Text("Choose a payment method",style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/18,
                          fontWeight: FontWeight.w500
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: Text("You will not be charged until you review the payment on the next page",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/27,
                        ),),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10,top: 5,bottom: 5),
                            child: Text("₦"+"${widget.amount}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/27,
                                  color: Colors.grey
                              ),),
                          )
                        ],
                      ),
                    ),

                    //select wallet
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          if(paymentmethod != "wallet"){
                            paymentmethod = "wallet";
                          }
                          print(paymentmethod);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            paymentmethod == "wallet" ?
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 2.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(2),
                                width: 11,
                                height: 11,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.black
                                ),
                              ),
                            )

                                :

                            Container(
                              width: 17,
                              height: 17,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 2.0)
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              child: Text("My Wallet",style: TextStyle(
                                  fontSize: 14
                              ),),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //debit card selection
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          if(paymentmethod != "card"){
                            paymentmethod = "card";
                          }
                          print(paymentmethod);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            paymentmethod == "card" ?
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 2.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(2),
                                width: 11,
                                height: 11,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.black
                                ),
                              ),
                            )

                                :

                            Container(
                              width: 17,
                              height: 17,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 2.0)
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              child: Text("Debit/Credit Card",style: TextStyle(
                                  fontSize: 14
                              ),),
                            )
                          ],
                        ),
                      ),
                    ),

                    //next or pay button
                    GestureDetector(
                      onTap: (){
                        if(paymentmethod == "wallet"){
                          print("Proceed with wallet payment");
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ServiceWalletPayment(
                              idname: widget.idname,
                                useremail: widget.useremail,
                                adminemail: widget.adminemail,
                                amount: widget.amount,
                                description: widget.desc,
                            sidname: widget.sidname,
                            servicename: widget.servicename,);
                          }));
                        }else if(paymentmethod == 'card'){
                          print("Proceed with card payment");
                          process();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10,left: 10,right: 10,top: 30),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.orangeAccent
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green
                        ),
                        child: Center(
                          child: Text(paymentmethod == 'card'?"Pay":"Next",style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width/22,
                            fontWeight: FontWeight.bold
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
          :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  Container(
                    child: Text("Processing payment",style: TextStyle(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width/26
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text('Vendorhive360',
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
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
    );
  }
}
