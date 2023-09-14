import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/buyservicepromotion.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/productpromotedone.dart';
import 'package:vendorandroid/screens/promotedonecard.dart';
import 'package:vendorandroid/screens/promotionwalletpayment.dart';
import 'package:vendorandroid/screens/promotionwalletpaymentservice.dart';

class PayForPromotionService extends StatefulWidget {

  String idname = "";
  String sidname = "";
  String servicename = "";
  String serviceimg = "";
  String adminemail = "";
  String amount = "";
  String days = "";

  PayForPromotionService({required this.sidname,
    required this.servicename,
    required this.serviceimg,
    required this.adminemail,
    required this.idname,
    required this.amount,
    required this.days});

  @override
  _PayForPromotionServiceState createState() => _PayForPromotionServiceState();
}

class _PayForPromotionServiceState extends State<PayForPromotionService> {

  double adstats = 0;
  String paymentmethod = "wallet";
  int _selectedpage = 0;
  String trfid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _selectedpage == 0
            ?
        Container(
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
                          child: Text("Payment method",style: TextStyle(
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
                    )
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
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

                Flexible(
                    child: ListView(
                      padding: EdgeInsets.only(top: 10),
                  children: [
                    Container(
                      margin:EdgeInsets.only(left: 10,right: 10),
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.green
                      ),
                      child: Column(
                        children: [
                          Container(

                            child: Row(
                              children: [

                                Container(
                                  child: Text('Amount: ',style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery.of(context).size.width/25
                                  ),),
                                ),

                                Expanded(child: Container(
                                  child: Text("₦"+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery.of(context).size.width/25
                                  ),),
                                ))

                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Container(

                            child: Row(
                              children: [

                                Container(
                                  child: Text('Days: ',style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery.of(context).size.width/25
                                  ),),
                                ),

                                Expanded(child: Container(
                                  child: Text(widget.days,style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery.of(context).size.width/25
                                  ),),
                                ))

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('Select mode of payment',style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/23,
                          fontWeight: FontWeight.w500
                      ),)),
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

                    GestureDetector(
                      onTap: (){

                        if(paymentmethod == 'wallet'){

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return WalletServicePayment(amount: widget.amount,
                              sidname: widget.sidname,
                              adminemail: widget.adminemail,
                              idname: widget.idname,
                              servicename: widget.servicename,
                              serviceimg: widget.serviceimg,
                            days: widget.days,);
                          }));

                        }
                        else if(paymentmethod == 'card'){

                          setState(() {
                            _selectedpage = 1;
                          });

                          payment();

                        }

                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25,left: 10,right: 10,bottom: 5),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.green,
                          border: Border.all(color: Colors.orange)
                        ),
                        child: Center(
                          child: Text(paymentmethod == 'wallet'?'Proceed':'Pay',style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width/20,
                          ),),
                        ),
                      ),
                    ),

                    Container(
                      child: Center(child: Text("Vendorhive 360",
                        style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                      ),)),
                    ),
                  ],
                ))
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
                      child: SpinKitFadingCube(
                        color: Colors.orange,
                        size: 100,
                      ),
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
      ),
    );
  }

  Future payment() async{

    print('processing paystack payment');

    setState(() {
      _selectedpage = 1;
    });

    String amt = widget.amount.replaceAll(",", "");
    String amount = double.parse(amt).toStringAsFixed(2);
    double a = double.parse(amount);
    double b = a *100;
    String c = b.toStringAsFixed(0);

    try{

      var paystackpayment = await http.post(
          Uri.https('api.paystack.co','transaction/initialize'),
          body: {
            'amount':c,
            'email':widget.adminemail
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
                BuyServicePromotion(
                  topuplink: topupurl,
                  refnumber: initiaterefno,
                  amount: widget.amount,
                  days: widget.days,
                  adminemail: widget.adminemail,
                  sidname: widget.sidname,
                  servicename: widget.servicename,
                )
            )
        );

      }
      else{

        setState(() {
          _selectedpage = 0;
        });

      }

    }
    catch(e){

      print(e);
      setState(() {
        _selectedpage = 0;
      });

    }
  }

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

  Future pay()async{

    currentdate();
    try{

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
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PromotedoneCard();
                  }));

                }
                else{

                  setState(() {
                    _selectedpage = 0;
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

              print("failed to update");

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Failed(trfid: trfid);
              }));

            }
          }
          else{

            setState(() {
              _selectedpage = 0;
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
          });

          print("Payment failed");

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        print("Payment issues ${promotionpayment.statusCode}");

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }
    catch(e){

      print("error is "+e.toString());

      var failedpromotionpayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedpromotedservicepayment.php'),
          body: {
            'refno':trfid,
            'sidname':widget.sidname
          }
      );

      if(failedpromotionpayment.statusCode == 200){
        if(jsonDecode(failedpromotionpayment.body)=="true"){

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
}

