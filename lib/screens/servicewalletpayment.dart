import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/success.dart';

class ServiceWalletPayment extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String adminemail = "";
  String amount = "";
  String description = "";
  String sidname = "";
  String servicename = "";
  ServiceWalletPayment({Key? key,
    required this.idname,
  required this.useremail,
  required this.adminemail,
  required this.amount,
  required this.description,
  required this.sidname,
  required this.servicename}) : super(key: key);

  @override
  _ServiceWalletPaymentState createState() => _ServiceWalletPaymentState();
}

class _ServiceWalletPaymentState extends State<ServiceWalletPayment> {

  int _selectedpage = 0;

  TextEditingController pin1 = new TextEditingController();
  TextEditingController pin2 = new TextEditingController();
  TextEditingController pin3 = new TextEditingController();
  TextEditingController pin4 = new TextEditingController();

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

    try{
      final procespayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorpinprocess.php'),
          body: {
            'idname':widget.idname,
            'useremail':widget.useremail,
            'pin':pin1.text+pin2.text+pin3.text+pin4.text
          }
      );

      var getbalance = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorcustbalance.php'),
          body: {
            'custemail':widget.useremail,
          }
      );

      if(getbalance.statusCode == 200){

        setState(() {
          finalbalance = jsonDecode(getbalance.body);
        });

        print("Wallet balance is "+finalbalance);
        if(procespayment.statusCode == 200){
          if(jsonDecode(procespayment.body)=='true'){
            if(double.parse(finalbalance) >= double.parse(widget.amount)){

              var debitcustwallet = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorcustupdatewallet.php'),
                  body: {
                    'idname':widget.idname,
                    'email':widget.useremail,
                    'debit':widget.amount.toString(),
                    'credit':'0',
                    'desc':'paid for service',
                    'refno':trfid,
                  }
              );

              if(debitcustwallet.statusCode == 200){

                print(jsonDecode(debitcustwallet.body));
                print('Wallet debited');

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
                      'description':widget.description,
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

                var notifyuser = await http.post(
                    Uri.https('adeoropelumi.com', 'vendor/vendorsendnotification.php'),
                    body: {
                      'message': "₦"+widget.amount+" was paid for "+widget.servicename,
                      'info': widget.adminemail,
                      'tag': 'Service',
                      'quantity' : "1",
                      'refno': trfid,
                    }
                );

                print(savepayment.statusCode);

                if(savepayment.statusCode == 200){
                  if(jsonDecode(savepayment.body) == 'true'){
                    print('service payment saved');

                    if(savetransaction.statusCode == 200){
                      if(jsonDecode(savetransaction.body)=='true'){

                        print('Service is paid for');

                        setState(() {
                          _selectedpage = 0;
                          pin1.clear();
                          pin2.clear();
                          pin3.clear();
                          pin4.clear();
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
                pin1.clear();
                pin2.clear();
                pin3.clear();
                pin4.clear();
                _selectedpage = 0;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Insufficeint balance'))
              );

            }
          }
          else{

            setState(() {
              pin1.clear();
              pin2.clear();
              pin3.clear();
              pin4.clear();
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text('Wrong pin'),
                ));

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
          Uri.https('adeoropelumi.com','vendor/failedwalletservicepayment.php'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
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
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Pay " + widget.adminemail,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
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
                      children:[
                        Container(
                          margin: EdgeInsets.only(left: 10,top: MediaQuery.of(context).size.height/40),
                          child: Text("Please confirm and pay for the service",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/18,
                                fontWeight: FontWeight.w500
                            ),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                          child: Text("By clicking pay, you agree to Vendor Hive 360’s Terms of Use and Privacy Policy",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/27,
                            ),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                          padding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text("Payment",style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/25,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        child: Text("Edit",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/25,
                                              color: Colors.greenAccent,
                                              fontWeight: FontWeight.w500
                                          ),),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Icon(Icons.account_balance_wallet_rounded,
                                              size: MediaQuery.of(context).size.width/12,
                                              color: Color.fromRGBO(5, 102, 8, 1),),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text("My Wallet",style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/25,
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Text("₦"+"${widget.amount}".replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/25,
                                        ),),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(238, 252, 233, 1)
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 30),
                                child: Center(
                                  child: Text("Enter Pin",style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width/23,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 30),
                                child: Center(child: Text("Please enter your PIN to pay",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/25,
                                ),)),
                              ),

                              //pin textfield
                              Container(
                                padding: EdgeInsets.only(top: 30),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Form(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children:[
                                          Container(
                                              height: MediaQuery.of(context).size.width/8,
                                              width: MediaQuery.of(context).size.width/8,
                                              child: TextFormField(
                                                controller: pin1,
                                                onChanged: (value){
                                                  if(value.length == 1){
                                                    FocusScope.of(context).nextFocus();
                                                  }
                                                },
                                                // onSaved: (pin1){},
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(bottom: 0),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    )
                                                ),
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/14,
                                                    fontWeight: FontWeight.w500
                                                ),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(1),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              )
                                          ),
                                          Container(
                                              height: MediaQuery.of(context).size.width/8,
                                              width: MediaQuery.of(context).size.width/8,

                                              child: TextFormField(
                                                controller: pin2,
                                                onChanged: (value){
                                                  if(value.length == 1){
                                                    FocusScope.of(context).nextFocus();
                                                  }
                                                },
                                                // onSaved: (pin2){},
                                                // decoration: InputDecoration(hintText: "0"),
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(bottom: 0),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    )
                                                ),
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/14,
                                                    fontWeight: FontWeight.w500
                                                ),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(1),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              )
                                          ),
                                          Container(
                                              height: MediaQuery.of(context).size.width/8,
                                              width: MediaQuery.of(context).size.width/8,
                                              child: TextFormField(
                                                controller: pin3,
                                                onChanged: (value){
                                                  if(value.length == 1){
                                                    FocusScope.of(context).nextFocus();
                                                  }
                                                },
                                                // onSaved: (pin1){},
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(bottom: 0),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    )
                                                ),
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/14,
                                                    fontWeight: FontWeight.w500
                                                ),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(1),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              )
                                          ),
                                          Container(
                                              height: MediaQuery.of(context).size.width/8,
                                              width: MediaQuery.of(context).size.width/8,
                                              child: TextFormField(
                                                controller: pin4,
                                                onChanged: (value){
                                                  if(value.length == 1){
                                                    FocusScope.of(context).nextFocus();
                                                  }
                                                },
                                                // onSaved: (pin1){},
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(bottom: 0),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    )
                                                ),
                                                style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/14,
                                                    fontWeight: FontWeight.w500
                                                ),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(1),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                              )
                                          ),
                                        ]
                                    )
                                ),
                              ),

                              //pay button
                              GestureDetector(
                                onTap: (){
                                  processpayment();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.orangeAccent
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  margin: EdgeInsets.only(top: 40,bottom: 40,left: 10,right: 10),
                                  child: Center(child: Text("Pay",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width/22,
                                    fontWeight: FontWeight.bold
                                  ),)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]
                  )
              )
            ],
          ),
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
            child: Text("Processing payment", style: TextStyle(
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
    );
  }
}
