import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/productpromotedone.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/promotedonecard.dart';

class WalletServicePayment extends StatefulWidget {
  String idname = "";
  String adminemail = "";
  String sidname = "";
  String servicename = "";
  String serviceimg = "";
  String amount = "";
  String days = "";

  WalletServicePayment({required this.idname,
    required this.adminemail,
    required this.sidname,
    required this.servicename,
    required this.serviceimg,
    required this.amount,
    required this.days});

  @override
  _WalletPaymentServiceState createState() => _WalletPaymentServiceState();
}

class _WalletPaymentServiceState extends State<WalletServicePayment> {

  TextEditingController pin1 = new TextEditingController();
  TextEditingController pin2 = new TextEditingController();
  TextEditingController pin3 = new TextEditingController();
  TextEditingController pin4 = new TextEditingController();

  double adstats = 0;
  int _selectedpage = 0;
  String trfid = "";

  String finalbalance = "";

  void currentdate(){
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

  Future processpinpayment() async{

    currentdate();

    print(widget.idname);
    print(widget.adminemail);

    try{
      final procespayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorpinprocess.php'),
          body: {
            'idname':widget.idname,
            'useremail':widget.adminemail,
            'pin':pin1.text+pin2.text+pin3.text+pin4.text
          }
      );

      if(procespayment.statusCode == 200){
        if(jsonDecode(procespayment.body)=='true'){

          var getbalance = await http.post(
              Uri.https('adeoropelumi.com','vendor/vendorbusinessavailablebalance.php'),
              body: {
                'adminemail':widget.adminemail
              }
          );

          if(getbalance.statusCode == 200){

            setState(() {
              finalbalance = jsonDecode(getbalance.body);
            });

            print("final balance is "+finalbalance);

            if(double.parse(finalbalance) >= double.parse(widget.amount.replaceAll(',', ''))){


              String desc = "bought "+widget.amount+" for "+widget.days;

              var savetransaction = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorsaveinbusinesswallet.php'),
                  body: {
                    'idname': widget.idname,
                    'useremail': widget.adminemail,
                    'adminemail': widget.adminemail,
                    'debit':widget.amount.replaceAll(',', ''),
                    'credit': '0',
                    'status': 'completed',
                    'refno' : trfid,
                    'description': desc,
                    'itemid': widget.sidname
                  }
              );

              var promotionpayment = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorpromotionpayment.php'),
                  body: {
                    'adminemail':widget.adminemail,
                    'amount':widget.amount,
                    'days':widget.days,
                    'itemid':widget.sidname,
                    'adstats': adstats.toString(),
                    'refno': trfid
                  }
              );

              var updateproducts = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorupdateserviceads.php'),
                  body: {
                    'itemid':widget.sidname,
                    'ads':adstats.toString()
                  }
              );

              var notifyuser = await http.post(
                  Uri.https('adeoropelumi.com', 'vendor/vendorsendnotification.php'),
                  body: {
                    'message': widget.servicename+" advertisment has started",
                    'info': widget.adminemail,
                    'tag': 'service promotion',
                    'refno': trfid
                  }
              );

              if(savetransaction.statusCode == 200){
                if(jsonDecode(savetransaction.body) == "true"){
                  if(promotionpayment.statusCode == 200){
                    print('User promotion payment is in progress');
                    if(jsonDecode(promotionpayment.body)=='true'){
                      print('User promotion is registereed');
                      if(updateproducts.statusCode == 200){
                        print('Admin products promotion is in progress');
                        if(jsonDecode(updateproducts.body)=='true'){
                          if(notifyuser.statusCode == 200){
                            print('User notification is in progress');
                            if(jsonDecode(notifyuser.body)=='true'){

                              print('User is notified');
                              print('Admin products promotion is done');

                              setState(() {
                                _selectedpage = 0;
                                pin1.clear();
                                pin2.clear();
                                pin3.clear();
                                pin4.clear();
                              });

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return Productpromotedone();
                              }));

                            }
                            else{

                              setState(() {
                                _selectedpage = 0;
                                pin1.clear();
                                pin2.clear();
                                pin3.clear();
                                pin4.clear();
                              });

                              print("failed to notify");

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return Failed(trfid: trfid);
                              }));

                            }
                          }
                          else{

                            setState(() {
                              _selectedpage = 0;
                              pin1.clear();
                              pin2.clear();
                              pin3.clear();
                              pin4.clear();
                            });

                            print("Notify issues ${notifyuser.statusCode}");

                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return Failed(trfid: trfid);
                            }));

                          }
                        }
                        else{

                          setState(() {
                            _selectedpage = 0;
                            pin1.clear();
                            pin2.clear();
                            pin3.clear();
                            pin4.clear();
                          });

                          print("failed to update");

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return Failed(trfid: trfid);
                          }));

                        }
                      }
                      else{

                        setState(() {
                          _selectedpage = 0;
                          pin1.clear();
                          pin2.clear();
                          pin3.clear();
                          pin4.clear();
                        });

                        print("update product issues ${updateproducts.statusCode}");

                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Failed(trfid: trfid);
                        }));

                      }
                    }
                    else{

                      setState(() {
                        _selectedpage = 0;
                        pin1.clear();
                        pin2.clear();
                        pin3.clear();
                        pin4.clear();
                      });

                      print("Payment failed");
                    }
                  }
                  else{

                    setState(() {
                      _selectedpage = 0;
                      pin1.clear();
                      pin2.clear();
                      pin3.clear();
                      pin4.clear();
                    });

                    print("Payment issues ${promotionpayment.statusCode}");

                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Failed(trfid: trfid);
                    }));

                  }
                }
                else{

                  setState(() {
                    _selectedpage = 0;
                    pin1.clear();
                    pin2.clear();
                    pin3.clear();
                    pin4.clear();
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Failed(trfid: trfid);
                  }));

                }
              }
              else{

                setState(() {
                  _selectedpage = 0;
                  pin1.clear();
                  pin2.clear();
                  pin3.clear();
                  pin4.clear();
                });

                print("debit wallet issues ${savetransaction.statusCode}");

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Failed(trfid: trfid);
                }));

              }
            }
            else{

              setState(() {
                _selectedpage = 0;
                pin1.clear();
                pin2.clear();
                pin3.clear();
                pin4.clear();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Insufficient Balance"))
              );

            }
          }
          else{

            setState(() {
              _selectedpage = 0;
              pin1.clear();
              pin2.clear();
              pin3.clear();
              pin4.clear();
            });

            print("getting balance issue ${getbalance.statusCode}");

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Failed(trfid: trfid);
            }));
          }
        }
        else{

          setState(() {
            _selectedpage = 0;
            pin1.clear();
            pin2.clear();
            pin3.clear();
            pin4.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Wrong pin"))
          );

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
          pin1.clear();
          pin2.clear();
          pin3.clear();
          pin4.clear();
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
    catch(e){

      setState(() {
        _selectedpage = 0;
        pin1.clear();
        pin2.clear();
        pin3.clear();
        pin4.clear();
      });

      print("Error is "+e.toString());

      var failedpromotionproductpayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedwalletpromotionservicepayment.php'),
          body: {
            'refno':trfid,
            'sidname': widget.sidname
          }
      );

      if(failedpromotionproductpayment.statusCode == 200){
        if(jsonDecode(failedpromotionproductpayment.body) == "true"){

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
  initState(){
    super.initState();
    adstats = double.parse(widget.amount) / double.parse(widget.days);
    print(adstats);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _selectedpage == 0 ?
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
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
                          child: Text("Wallet payment",style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.arrow_back,color: Colors.white,)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    child:  Center(
                      child: FadeInImage(
                        image: NetworkImage("https://adeoropelumi.com/vendor/serviceimage/"+widget.serviceimg),
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
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('Amount: ₦'+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/24,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text('Days: '+widget.days.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/24,
                        fontWeight: FontWeight.w500
                    ),textAlign: TextAlign.center,),
                  ),

                  Flexible(
                      child: ListView(
                    children: [

                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(child: Text("Please enter your PIN to pay for your order",style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/26,
                        ),)),
                      ),

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

                      GestureDetector(
                        onTap: (){
                          if(pin1.text.isNotEmpty && pin2.text.isNotEmpty
                          && pin3.text.isNotEmpty && pin4.text.isNotEmpty){
                            setState(() {
                              _selectedpage = 1;
                            });

                            processpinpayment();

                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter Complete pin'))
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 5),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.orange
                              ),
                              color: Colors.green
                          ),
                          child: Center(child: Text('Pay',style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),)),
                        ),
                      ),

                      Container(
                        child: Center(child: Text("Vendorhive 360",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/26,
                              fontStyle: FontStyle.italic
                          ),)),
                      ),

                    ],
                  ))
                ],
              ),
            ),
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
                      child: Image.asset("assets/processing.png",color: Color.fromRGBO(14, 44, 3, 1),),
                    ),
                    Container(
                      child: Text("Processing payment",style: TextStyle(
                        color: Color.fromRGBO(246, 123, 55, 1),
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text('Vendorhive 360',style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
