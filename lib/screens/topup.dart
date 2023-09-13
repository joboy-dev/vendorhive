import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/success.dart';
import 'package:vendorandroid/screens/testtimer.dart';
import 'package:vendorandroid/screens/webview.dart';

class Topup extends StatefulWidget {
  String email = "";
  String idname = "";
  Topup({
    Key? key,
  required this.email,required this.idname}) : super(key: key);

  @override
  _TopupState createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  String topup = "0";
  String trfid = "";
  int _selectedpage = 0;

  TextEditingController _amount = new TextEditingController();
  TextEditingController _desc = new TextEditingController();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(238, 252, 233, 1)
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, .5),
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Topup",style: TextStyle(
                              color: Colors.black,
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
                                backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                                child: Icon(Icons.arrow_back,color: Colors.black,),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Color.fromRGBO(255,215,0, 1)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white, //New
                          blurRadius: 25.0,
                          offset: Offset(0, -10))
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/17),
                        child: Text("Top up Amount",textAlign: TextAlign.center,style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height/40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/17,top: 10),
                        child: Text("₦"+topup.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),textAlign: TextAlign.center,style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height/20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    child: ListView(
                      children: [

                        Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/25,left: 10,right: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _amount,
                              inputFormatters: [
                                ThousandsFormatter(allowFraction: true)
                              ],
                              decoration: InputDecoration(
                                  prefix: Text('₦'),
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(
                                      fontSize: 12
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(246, 123, 55, 1))
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(246, 123, 55, 1))
                                  )
                              ),
                              onChanged: (val){
                                print(val);
                                setState(() {
                                  topup = val;
                                });
                              },
                            )
                        ),

                        Container(
                            margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                            child: TextField(
                              controller: _desc,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Narration',
                                  hintStyle: TextStyle(
                                      fontSize: 12
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(246, 123, 55, 1))
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(246, 123, 55, 1))
                                  )
                              ),
                            )
                        ),

                        GestureDetector(
                          onTap: (){
                            if(_amount.text.isEmpty || _desc.text.isEmpty){

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fill all fields'))
                              );

                            }else{

                              print('Top up is ongoing');

                              payment();

                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color.fromRGBO(246, 123, 55, 1)),
                                color: Colors.black
                            ),
                            margin: EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 20),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(child: Text('PAY',style: TextStyle(
                                color: Color.fromRGBO(246, 123, 55, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),)),
                          ),
                        )
                      ],
                    )
                )
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    )
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
                      child: Text('Vendorhive 360',
                        style: TextStyle(
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
    );
  }

  void testtimer(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return TestTimer();
    }));
  }

  Future creditwallet() async{

    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();

    print('crediting wallet');

    try{

      var creditcustwallet = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorcustupdatewallet.php'),
          body: {
            'idname':widget.idname,
            'email':widget.email,
            'debit':'0',
            'credit':_amount.text.replaceAll(",", ""),
            'desc':_desc.text.toString(),
            'refno':trfid,
          }
      );

      if(creditcustwallet.statusCode == 200){
        print(jsonDecode(creditcustwallet.body));

        if(jsonDecode(creditcustwallet.body) == 'true'){

          setState(() {
            _selectedpage = 0;
            topup = "0";
            _amount.clear();
            _desc.clear();
          });

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Success();
          }));

          print('Wallet credited');

        }
        else{

          setState(() {
            _selectedpage = 0;
            _amount.clear();
            _desc.clear();
          });

          print('Failed to credit wallet');

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        setState(() {
          _selectedpage =0;
          _amount.clear();
          _desc.clear();
        });

        print('Network Issues');

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }

    }
    catch(e){

      print("Failed"+e.toString());

      var failedtopup = await http.post(
          Uri.https('adeoropelumi.com','vendor/failedtopup.php'),
          body: {
            'refno':trfid
          }
      );

      if(failedtopup.statusCode == 200){
        if(jsonDecode(failedtopup.body) == "true"){

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
        else{

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));


        }
      }
      else{

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));


      }

    }
  }

  void correctamount(){
    String amt = _amount.text.replaceAll(",", "");
    String amount = double.parse(amt).toStringAsFixed(2);
    double a = double.parse(amount);
    double b = a *100;
    String c = b.toStringAsFixed(0);
    print(c);
  }

  String replacing(String word) {
    word = word.replaceAll("'", "");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }
  
  String initiaterefno = "";

  Future payment() async{

    setState(() {
      _selectedpage = 1;
    });

    String amt = _amount.text.replaceAll(",", "");
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
        initiaterefno = jsonDecode(paystackpayment.body)['data']['reference'];

        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>
                TopupPaystack(
                  topuplink: topupurl,
                  refnumber: initiaterefno,
                  desription: replacing(_desc.text),
                  idname: widget.idname,
                  email: widget.email,
                  amount: _amount.text.replaceAll(",", ""),
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

      setState(() {
        _selectedpage = 0;
      });

    }
  }
  
}
