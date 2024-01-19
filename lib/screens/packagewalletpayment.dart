import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackageWalletPayment extends StatefulWidget {
  String idname = "";
  String email = "";
  String package = "";
  String amount = "";
  PackageWalletPayment({Key? key,
  required this.idname,
  required this.email,
  required this.amount,
  required this.package}) : super(key: key);

  @override
  _PackageWalletPaymentState createState() => _PackageWalletPaymentState();
}

class _PackageWalletPaymentState extends State<PackageWalletPayment> {

  bool one_time_payment = true;
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

  Future pay()async{

    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();

    final procespayment = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorpinprocess.php'),
        body: {
      'idname':widget.idname,
      'useremail':widget.email,
      'pin':pin1.text+pin2.text+pin3.text+pin4.text
    }
    );

    var getbalance = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorcustbalance.php'),
        body: {
          'custemail':widget.email,
        }
    );

    if(getbalance.statusCode == 200){
      setState(() {
        finalbalance = jsonDecode(getbalance.body);
      });
      print("Wallet balance is "+finalbalance);
      if(procespayment.statusCode == 200) {
        if (jsonDecode(procespayment.body) == 'true') {
          print('correct pin');

          if (double.parse(finalbalance) >= double.parse(widget.amount)) {

            String desc = 'purchaced '+widget.package+' package.';

            var debitcustwallet = await http.post(
                Uri.https('vendorhive360.com','vendor/vendorcustupdatewallet.php'),
                body: {
                  'idname':widget.idname,
                  'email':widget.email,
                  'debit':widget.amount.toString(),
                  'credit':'0',
                  'desc':desc,
                  'refno':trfid,
                }
            );

            if(debitcustwallet.statusCode == 200){
              if(jsonDecode(debitcustwallet.body) == 'true'){

                var upgradepackage = await http.post(
                    Uri.https('vendorhive360.com','vendor/vendorupdatepackage.php'),
                    body: {
                      'email':widget.email,
                      'package':widget.package
                    }
                );

                if(upgradepackage.statusCode == 200){
                  if(jsonDecode(upgradepackage.body) == 'true'){

                    print('User is upgraded to '+widget.package);

                    var recordpackage = await http.post(
                        Uri.https('vendorhive360.com','vendor/vendorpackagerecord.php'),
                        body: {
                          'email':widget.email,
                          'package':widget.package,
                          'refno': trfid
                        }
                    );

                    if(recordpackage.statusCode == 200){
                      if(jsonDecode(recordpackage.body) == 'true'){

                        setState(() {
                          _selectedpage = 0;
                          one_time_payment = true;
                          pin1.clear();
                          pin2.clear();
                          pin3.clear();
                          pin4.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('New Package is set'))
                        );

                        print('package is recorded');

                      }
                      else{

                        setState(() {
                          _selectedpage = 0;
                          one_time_payment = true;
                          pin1.clear();
                          pin2.clear();
                          pin3.clear();
                          pin4.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed'))
                        );

                        print('failed processing package');

                      }
                    }
                    else{

                      setState(() {
                        _selectedpage = 0;
                        one_time_payment = true;
                        pin1.clear();
                        pin2.clear();
                        pin3.clear();
                        pin4.clear();
                      });

                      print('Network Issues');

                    }
                  }
                  else{

                    setState(() {
                      _selectedpage = 0;
                      one_time_payment = true;
                      pin1.clear();
                      pin2.clear();
                      pin3.clear();
                      pin4.clear();
                    });

                    print('Failed while updating package');

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed while updating package'))
                    );

                  }
                }
                else{

                  setState(() {
                    _selectedpage = 0;
                    one_time_payment = true;
                    pin1.clear();
                    pin2.clear();
                    pin3.clear();
                    pin4.clear();
                  });

                  print('Network issue while updating package');

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Network issue while updating package'))
                  );

                }

              }
              else{

                print('Failed Debiting account');

                setState(() {
                  _selectedpage = 0;
                  one_time_payment = true;
                  pin1.clear();
                  pin2.clear();
                  pin3.clear();
                  pin4.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed Debiting account'))
                );

              }
            }
            else{
              print('Network Issues');
              setState(() {
                _selectedpage = 0;
                one_time_payment = true;
                pin1.clear();
                pin2.clear();
                pin3.clear();
                pin4.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Network Issues'))
              );
            }

          }
          else{
            print('Insufficient balance');
            setState(() {
              _selectedpage = 0;
              one_time_payment = true;
              pin1.clear();
              pin2.clear();
              pin3.clear();
              pin4.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Insufficient balance'))
            );
          }
        }
        else{
          print('Wrong pin');
          setState(() {
            _selectedpage = 0;
            one_time_payment = true;
            pin1.clear();
            pin2.clear();
            pin3.clear();
            pin4.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Wrong pin'))
          );
        }
      }
      else{
        print('Network Issues');
        setState(() {
          _selectedpage = 0;
          one_time_payment = true;
          pin1.clear();
          pin2.clear();
          pin3.clear();
          pin4.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Network Issues'))
        );
      }
    }
    else{
      print('Customer balance was not gotten');
      setState(() {
        _selectedpage = 0;
        one_time_payment = true;
        pin1.clear();
        pin2.clear();
        pin3.clear();
        pin4.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request time out'))
      );
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
                          "Pay for " + widget.package,
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
                          child: Text("Please confirm and pay for "+widget.package,
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
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
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
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
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
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
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
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6,)
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
                                  if(pin1.text.isNotEmpty && pin2.text.isNotEmpty && pin3.text.isNotEmpty
                                  && pin4.text.isNotEmpty){
                                    if(one_time_payment){
                                      setState(() {
                                        one_time_payment = false;
                                      });
                                      pay();
                                    }
                                  }else{
                                    print('Enter pin');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please enter pin'))
                                    );
                                  }
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
                                  margin: EdgeInsets.only(top: 40,bottom: 5,left: 10,right: 10),
                                  child: Center(child: Text(one_time_payment ? "Pay":"loading...",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width/22,
                                      fontWeight: FontWeight.bold
                                  ),)),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/6),
                                child: Center(
                                  child: Text('Vendorhive360',style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width/25,
                                  ),textAlign: TextAlign.center,),
                                ),
                              ),
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
                      child: Text('Vendorhive360',style: TextStyle(
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
