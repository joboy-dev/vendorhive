import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/buyproductpromotion.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/promotedonecard.dart';
import 'package:vendorandroid/screens/promotionwalletpayment.dart';

class PayForPromotion extends StatefulWidget {
  String idname = "";
  String pidname = "";
  String prodname = "";
  String prodimg = "";
  String adminemail = "";
  String amount = "";
  String days = "";
  PayForPromotion({required this.pidname,
    required this.prodname,
    required this.prodimg,
    required this.adminemail,
    required this.idname,
  required this.amount,
  required this.days});

  @override
  _PayForPromotionState createState() => _PayForPromotionState();
}

class _PayForPromotionState extends State<PayForPromotion> {


  String paymentmethod = "wallet";
  int _selectedpage = 0;
  String trfid = "";

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
            'email':'abel.ayinde@gmail.com'
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
                BuyProductPromotion(
                  topuplink: topupurl,
                  refnumber: initiaterefno,
                  amount: widget.amount,
                  days: widget.days,
                  adminemail: widget.adminemail,
                  pidname: widget.pidname,
                  prodname: widget.prodname,
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

  Future pay()async{

   double adstats = double.parse(widget.amount) / double.parse(widget.days);

    currentdate();

    try{

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


      String notifymsg = widget.prodname+" advertisment has started";

      var notifyuser = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorsendnotification.php'),
          body: {
            'message': notifymsg,
            'info': widget.adminemail,
            'tag': 'product promotion',
            'refno': trfid
          }
      );


      if(promotionpayment.statusCode == 200){
        if(jsonDecode(promotionpayment.body) == "true"){
          if(updateproducts.statusCode == 200){
            if(jsonDecode(updateproducts.body) == "true"){
              if(notifyuser.statusCode == 200){
                if(jsonDecode(notifyuser.body) == "true"){

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PromotedoneCard();
                  }));

                }
                else{

                  print("failed to notify");

                  setState(() {
                    _selectedpage = 0;
                  });

                }
              }
              else{

                print("Notify user issues ${notifyuser.statusCode}");

                setState(() {
                  _selectedpage = 0;
                });

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
    catch(e){

      print("error is "+e.toString());

      var failedpromotionpayment = await http.post(
        Uri.https('adeoropelumi.com','vendor/failedpromotedproductpayment.php'),
        body: {
          'refno':trfid,
          'pidname':widget.pidname
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _selectedpage == 0
            ?
        SafeArea(
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
                          child: Text("Payment method",style: TextStyle(
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
                    )
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width/3,
                  child:  Center(
                    child: FadeInImage(
                      image: NetworkImage("https://adeoropelumi.com/vendor/productimage/"+widget.prodimg),
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

                                    Expanded(
                                        child: Container(
                                          child: Text("₦"+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context).size.width/25
                                          ),),
                                        )
                                    )
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
                                return WalletPayment(amount: widget.amount,
                                  pidname: widget.pidname,
                                  adminemail: widget.adminemail,
                                  idname: widget.idname,
                                  productname: widget.prodname,
                                  productimg: widget.prodimg,
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
                            margin: EdgeInsets.only(left: 10,right: 10,top: 25,bottom: 5),
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
                          child: Center(
                            child: Text('Vendorhive 360',style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/26,
                                fontStyle: FontStyle.italic
                            ),),
                          ),
                        )

                      ],
                    ))
              ],
            ),
          ),
        )
            :
        Center(
          child: Column(
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
        )
    );
  }
}
