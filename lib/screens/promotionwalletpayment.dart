import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/productpromotedone.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletPayment extends StatefulWidget {

  String idname = "";
  String adminemail = "";
  String pidname = "";
  String productname = "";
  String productimg = "";
  String amount = "";
  String days = "";

  WalletPayment({required this.idname,
  required this.adminemail,
  required this.pidname,
  required this.productname,
  required this.productimg,
  required this.amount,
  required this.days});

  @override
  _WalletPaymentState createState() => _WalletPaymentState();

}

class _WalletPaymentState extends State<WalletPayment> {

  int _selectedpage = 0;
  double adstats = 0;
  String finalbalance = "";
  String trfid = "";

  TextEditingController pin1 = new TextEditingController();
  TextEditingController pin2 = new TextEditingController();
  TextEditingController pin3 = new TextEditingController();
  TextEditingController pin4 = new TextEditingController();

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

    print("processing pin");

    currentdate();

    try{

      final procespayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorpinprocess.php'),
          body: {
            'idname':widget.idname,
            'useremail':widget.adminemail,
            'pin':pin1.text+pin2.text+pin3.text+pin4.text
          }
      );

      var getbalance = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorbusinessavailablebalance.php'),
          body: {
            'adminemail':widget.adminemail
          }
      );

      if(procespayment.statusCode == 200){
        if(jsonDecode(procespayment.body)=='true'){

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
                    'itemid': widget.pidname
                  }
              );

              var promotionpayment = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorpromotionpayment.php'),
                  body: {
                    'adminemail':widget.adminemail,
                    'amount':widget.amount,
                    'days':widget.days,
                    'itemid':widget.pidname,
                    'adstats': adstats.toString(),
                    'refno': trfid,
                  }
              );

              var updateproducts = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorupdateproductads.php'),
                  body: {
                    'itemid':widget.pidname,
                    'ads':adstats.toString()
                  }
              );

              var notifyuser = await http.post(
                  Uri.https('adeoropelumi.com','vendor/vendorsendnotification.php'),
                  body: {
                    'message': widget.productname+" advertisment has started",
                    'info': widget.adminemail,
                    'tag': 'product promotion',
                    'refno': trfid
                  }
              );


              if(savetransaction.statusCode == 200){
                if(jsonDecode(savetransaction.body) == "true"){
                  if(promotionpayment.statusCode == 200){
                    if(jsonDecode(promotionpayment.body) == "true"){
                      if(updateproducts.statusCode == 200){
                        if(jsonDecode(updateproducts.body) == "true"){
                          if(notifyuser.statusCode == 200){
                            if(jsonDecode(notifyuser.body) == "true"){

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return Productpromotedone();
                              }));

                            }
                            else{

                              print("failed to notify");

                              setState(() {
                                _selectedpage = 0;
                              });

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return Failed(trfid: trfid);
                              }));

                            }
                          }
                          else{

                            print("Notify user issues ${notifyuser.statusCode}");

                            setState(() {
                              _selectedpage = 0;
                            });

                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return Failed(trfid: trfid);
                            }));

                          }
                        }
                        else{

                          print("promotion failed to start");

                          setState(() {
                            _selectedpage = 0;
                          });

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return Failed(trfid: trfid);
                          }));

                        }
                      }
                      else{

                        print("Update product issues ${updateproducts.statusCode}");

                        setState(() {
                          _selectedpage = 0;
                        });

                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Failed(trfid: trfid);
                        }));

                      }
                    }
                    else{

                      print("Payment failed");

                      setState(() {
                        _selectedpage = 0;
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return Failed(trfid: trfid);
                      }));

                    }
                  }
                  else{

                    print("payment issues ${promotionpayment.statusCode}");

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

                  print("Failed to debit transaction");

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Failed(trfid: trfid);
                  }));

                }
              }
              else{

                setState(() {
                  _selectedpage = 0;
                });

                print("Save transaction issues ${savetransaction.statusCode}");

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Failed(trfid: trfid);
                }));

              }

            }
            else{

              print("Insufficient Balance");

              setState(() {
                _selectedpage = 0;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Insufficient Balance'))
              );

            }
          }
          else{

            setState(() {
              _selectedpage =0;
            });

            print('Network Issues ${getbalance.statusCode}');

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Failed(trfid: trfid);
            }));

          }
        }
        else{

          setState(() {
            _selectedpage = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Wrong pin'))
          );
        }
      }
      else{

        setState(() {

          _selectedpage = 0;

        });

        print("Payment issues ${procespayment.statusCode}");

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }
    catch(e){

      print("Error is "+e.toString());

      setState(() {
        _selectedpage = 0;
        pin1.clear();
        pin2.clear();
        pin3.clear();
        pin4.clear();
      });

      var failedpromotionproductpayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedwalletpromotionproductpayment.php'),
          body: {
            'refno':trfid,
            'pidname': widget.pidname
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
  void initState() {
    // TODO: implement initState
    super.initState();
    adstats = double.parse(widget.amount) / double.parse(widget.days);
    print(adstats);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _selectedpage == 0?
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
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
                            child: Text("Product",style: TextStyle(
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
                      child:  FadeInImage(
                        image: NetworkImage("https://adeoropelumi.com/vendor/productimage/"+widget.productimg),
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
                      margin: EdgeInsets.only(top: 10),
                      child: Text('Amount: ₦'+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/24,
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text('Days: '+widget.days.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/24,
                          fontWeight: FontWeight.w500
                      ),),
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
                            if(pin1.text.isNotEmpty && pin2.text.isNotEmpty &&
                            pin3.text.isNotEmpty && pin4.text.isNotEmpty){
                              processpinpayment();

                              setState(() {
                                _selectedpage = 1;
                              }); 
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Enter complete pin'))
                              );
                            }

                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 5),
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
                          child: Center(
                            child: Text('Vendorhive 360',style: TextStyle(
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
