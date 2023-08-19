import 'package:flutter/material.dart';
import 'package:vendorandroid/screens/packagewalletpayment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectPackagePayment extends StatefulWidget {
  String idname = "";
  String email = "";
  String amount = "";
  String package = "";
  SelectPackagePayment({Key? key,
  required this.idname,
  required this.email,
  required this.amount,
  required this.package}) : super(key: key);

  @override
  _SelectPackagePaymentState createState() => _SelectPackagePaymentState();
}

class _SelectPackagePaymentState extends State<SelectPackagePayment> {

  bool one_time_payment = true;
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

  Future pay()async{

    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();

    var upgradepackage = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorupdatepackage.php'),
        body: {
          'email':widget.email,
          'package':widget.package
        }
    );

    if(upgradepackage.statusCode == 200){
      if(jsonDecode(upgradepackage.body) == 'true'){
        print('User is upgraded to '+widget.package);

        var recordpackage = await http.post(
            Uri.https('adeoropelumi.com','vendor/vendorpackagerecord.php'),
            body: {
              'email':widget.email,
              'package':widget.package,
              'refno': trfid
            }
        );

        if(recordpackage.statusCode == 200){
          if(jsonDecode(recordpackage.body) == 'true'){

            setState(() {
              one_time_payment = true;
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('New Package is set'))
            );

            print('package is recorded');

          }
          else{

            setState(() {
              one_time_payment = true;
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed recording pacakage'))
            );

            print('failed recording pacakage');

          }
        }
        else{

          print('Network issue while recording package');

          setState(() {
            one_time_payment = true;
            _selectedpage = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Network issue while recording package'))
          );

        }
      }
      else{
        print('Failed while updating package');

        setState(() {
          _selectedpage = 0;
          one_time_payment = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed while updating package'))
        );
      }
    }
    else{

      print('Network issue while updating package');

      setState(() {
        _selectedpage = 0;
        one_time_payment = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network issue while updating package'))
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
                      "Pay for " + widget.package,
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
                      margin:EdgeInsets.only(left: 10,top: 25),
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
                                  fontSize: MediaQuery.of(context).size.width/25,
                                  color: Colors.grey
                              ),),
                          )
                        ],
                      ),
                    ),
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
                            Expanded(
                              child: Container(
                                child: Text("My Wallet",style: TextStyle(
                                    fontSize: 14
                                ),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                            Expanded(
                                child: Container(
                                  child: Text("Debit/Credit Card",style: TextStyle(
                                      fontSize: 14
                                  ),),
                                ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(paymentmethod == "wallet"){
                          print("Proceed with wallet payment");
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PackageWalletPayment(idname: widget.idname,
                                email: widget.email,
                                amount: widget.amount,
                                package: widget.package);
                          }));
                        }else if(paymentmethod == 'card'){
                          print("Proceed with card payment");
                          if(one_time_payment){
                            setState(() {
                              one_time_payment = false;
                            });
                            pay();
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5,left: 10,right: 10,top: 30),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.orangeAccent
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green
                        ),
                        child: Center(
                          child: Text(one_time_payment ? paymentmethod == "wallet"? "Next" :"Pay":"loading...",style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width/19,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text('Vendorhive 360',style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: MediaQuery.of(context).size.width/25,
                        ),),
                      ),
                    )
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
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
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
