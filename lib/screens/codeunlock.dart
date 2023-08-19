import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/keypad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/success.dart';


class CodeUnlock extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String bankname = "";
  String accountname = "";
  String amount = "";
  String narration = "";
  String charge = "";

  CodeUnlock({required this.bankname, required this.accountname,
  required this.amount, required this.narration,required this.charge,
  required this.idname,required this.useremail});

  @override
  _CodeUnlockState createState() => _CodeUnlockState();

}

class _CodeUnlockState extends State<CodeUnlock> {

  int _selectedpage = 0;

  // text controller
  final TextEditingController _myController = TextEditingController();

  void init(){
    print(widget.bankname);
    print(widget.accountname);
    print(widget.amount);
    print(widget.narration);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _selectedpage == 0 ?
      GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(238, 252, 233, 1)
          ),
          child: SafeArea(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                        child: Text("Enter pin",style: TextStyle(
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

                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width/20,
                      bottom: MediaQuery.of(context).size.width/15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white, //New
                          blurRadius: 25.0,
                          offset: Offset(0, -10))
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:EdgeInsets.only(left: 10),
                              child: Text('Amount:',style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),textAlign: TextAlign.right,),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: Text('₦'+widget.amount,style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                ),textAlign: TextAlign.left,),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:EdgeInsets.only(left: 10),
                              child: Text('Charge:',style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),textAlign: TextAlign.right,),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: Text('₦'+widget.charge,style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                ),textAlign: TextAlign.left,),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:EdgeInsets.only(left: 10),
                              child: Text('Beneficiary:',style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),textAlign: TextAlign.right,),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Container(
                                  child: Text(widget.accountname,style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.left,),
                                )
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:EdgeInsets.only(left: 10),
                              child: Text('Bank:',style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),textAlign: TextAlign.right,),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Container(
                                  child: Text(widget.bankname,style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.left,),
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // display the entered numbers
                Container(
                  child: Column(
                    children: [
                      Container(
                          child: TextField(
                            controller: _myController,
                            textAlign: TextAlign.center,
                            showCursor: false,
                            obscureText: true,
                            style: TextStyle(
                                fontSize: 35,
                              color: Colors.black
                            ),
                            // Disable the default soft keybaord
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          )),
                      // implement the custom NumPad
                      Container(
                        child: NumPad(
                          buttonSize: MediaQuery.of(context).size.height/15,
                          buttonColor: Color.fromRGBO(2, 48, 32, 1),
                          iconColor: Colors.black,
                          controller: _myController,
                          delete: () {
                            _myController.text = _myController.text
                                .substring(0, _myController.text.length - 1);
                          },
                          // do something with the input numbers
                          onSubmit: () {
                            print('Your code: ${_myController.text}');
                            debitcust();
                          },
                        ),
                      ),
                    ],
                  ),
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
                  child: Image.asset("assets/processing.png",
                    color: Color.fromRGBO(14, 44, 3, 1),),
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

  String trfid = "";

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

  String finalbalance = "";

  Future debitcust()async{

    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();
    try{

      double total = double.parse(widget.amount.replaceAll(",", "")) + double.parse(widget.charge);
      print(total);

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

      }

      final procespayment = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorpinprocess.php'),
          body: {
            'idname':widget.idname,
            'useremail':widget.useremail,
            'pin':_myController.text.toString()
          }
      );


      if(procespayment.statusCode == 200){
        if(jsonDecode(procespayment.body)=='true'){
          if(double.parse(finalbalance) >= total){
            String desc = 'to '+widget.accountname+' for '+widget.narration;

            var debitcustwallet = await http.post(
                Uri.https('adeoropelumi.com','vendor/vendorcustupdatewallet.php'),
                body: {
                  'idname':widget.idname,
                  'email':widget.useremail,
                  'debit':total.toString(),
                  'credit':'0',
                  'desc':desc,
                  'refno':trfid,
                }
            );

            if(debitcustwallet.statusCode == 200){
              if(jsonDecode(debitcustwallet.body) == 'true'){

                setState(() {

                  _selectedpage = 0;

                  _myController.clear();

                });

                print('cust wallet is debited');

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Success();
                }));

              }
              else{

                setState(() {
                  _selectedpage = 0;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed'))
                );
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

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Insufficient Balance'))
            );

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

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
    catch(e){

      print("error "+e.toString());

      var failedwithdrawal = await http.post(
        Uri.https('adeoropelumi.com','vendor/failedwithdrawal.php'),
        body: {
          'refno':trfid
        }
      );

      if(failedwithdrawal.statusCode == 200){
        if(jsonDecode(failedwithdrawal.body) == "true"){

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