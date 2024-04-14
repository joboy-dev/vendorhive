import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/buytopupbusiness.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendorandroid/screens/success.dart';

class TopupBusiness extends StatefulWidget {
  String email = "";
  String idname = "";
  TopupBusiness({Key? key,
  required this.email,
  required this.idname}) : super(key: key);

  @override
  _TopupBusinessState createState() => _TopupBusinessState();
}

class _TopupBusinessState extends State<TopupBusiness> {

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

  Future topupfor() async{

    setState(() {
      _selectedpage = 1;
    });

    print(_amount.text);

    currentdate();

    String itemid = "tp "+trfid;

    try{

      var savetransaction = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorsaveinbusinesswallet.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.email,
            'adminemail': widget.email,
            'debit':'0',
            'credit': _amount.text.replaceAll(',', ''),
            'status': 'completed',
            'refno' : trfid,
            'description': 'top up',
            'itemid': itemid
          }
      );

      if(savetransaction.statusCode == 200){
        print(jsonDecode(savetransaction.body));
        if(jsonDecode(savetransaction.body) == 'true'){

          setState(() {
            _selectedpage = 0;
            topup = "0";
            _amount.clear();
            _desc.clear();
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
    catch(e){

      print("Failed"+e.toString());

      var failedtopup = await http.post(
          Uri.https('vendorhive360.com','vendor/failedbusinesstopup.php'),
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

  Future payment() async{

    print('processing paystack payment');

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
            'email':widget.email
          },
          headers: {
            'Authorization':dotenv.env['PAYSTACK_SECRET_KEYS']!
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
                BuyTopupBusiness(
                  topuplink: topupurl,
                  refnumber: initiaterefno,
                  idname: widget.idname,
                  email: widget.email,
                  amount: _amount.text.replaceAll(",", ""),
                  decription: replacing(_desc.text),
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

  String replacing(String word) {
    word = word.replaceAll("'", "");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            child: Container(
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

                            child: Container(
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
                                          fontSize: MediaQuery.of(context).size.width/25
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
                          ),

                          Container(
                            child: Container(
                                margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                                child: TextField(
                                  controller: _desc,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Narration',
                                      hintStyle: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/25
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
                          ),

                          GestureDetector(
                            onTap: (){
                              if(_amount.text.isEmpty || _desc.text.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Fill all fields'))
                                );
                              }else{
                                print('Top up is ongoing');
                                showDialog(context: context, builder: (cxt){
                                  return AlertDialog(
                                    title: Text("Please Note", style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red
                                    ),),
                                    content: Text("The amount that will reflect in your wallet is "
                                        "1.5% of the original amount plus ₦200 "
                                        "will be deducted from the orignal amount deducted from "
                                        "your bank account.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text("Cancel", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black
                                      ),)),
                                      ElevatedButton(
                                          onPressed: (){
                                            payment();
                                          }, child: Text("Proceed", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black
                                      ),))
                                    ],
                                  );
                                });
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
