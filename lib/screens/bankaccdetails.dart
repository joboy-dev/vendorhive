import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:vendorandroid/screens/codeunlock.dart';


class BankAccDetails extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String finalbalance = "";
  BankAccDetails({required this.finalbalance,required this.idname,
  required this.useremail});

  @override
  _BankAccDetailsState createState() => _BankAccDetailsState();
}

class _BankAccDetailsState extends State<BankAccDetails> {
  String drop = "";
  String bankcode = "";
  String bankname = "";
  String bankid = "";
  List raw = [];
  String accountname = "";
  String selectbank = "loading banks...";
  String transfercharges = "";
  String chargetalk = "";
  String charge = "";

  var selected;
  List selectedList = [];

  TextEditingController _accnumber = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _narration = new TextEditingController();

  Future getbanks() async{

    var getbankcodes = await http.get(
        Uri.https('api.flutterwave.com','/v3/banks/NG'),
        headers: {
         'Authorization':'Bearer FLWSECK-83f6e0261859cf218b58863ef9f17adf-18a4ac078a8vt-X'
        }
    );

    final Map<String, dynamic> data = jsonDecode(getbankcodes.body);

    print(jsonDecode(getbankcodes.body));

    print(data['data']);

    setState(() {

      raw = data['data'];

      selectbank = "";

    });

    drop = raw[0]['code'];

    print("Lenght is ${raw.length}");

  }

  Future getname(String accnumber, String bankcode) async{

    print('get bank name');
    final String uri = "https://api.flutterwave.com/v3/accounts/resolve";

    var bankname = await http.post(
        Uri.parse(uri),
        headers: {
          'Authorization':'Bearer FLWSECK-eca998c8baa0cf8656ee844fcb504b71-188b424a7c9vt-X'
        },
        body: {
          'account_number':accnumber,
          'account_bank':bankcode,
        }
    );

    print(jsonDecode(bankname.body));

    print(jsonDecode(bankname.body)['data']);

    print(jsonDecode(bankname.body)['status']);

    if(jsonDecode(bankname.body)['status'] == "success"){

      setState(() {

        accountname = jsonDecode(bankname.body)['data']['account_name'];

      });

      print(jsonDecode(bankname.body)['data']['account_name']);

    }
    else{

      print('Network Issues');

    }
  }

  Future getmybankcharge(String amt) async{

    setState(() {

      charge = "...";

      chargetalk = "";

    });

    print(amt);
    print('getting bank charge');

    var getbankcharges = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorbankcharges.php'),
        body: {
          'amount':amt.replaceAll(",", "")
        }
    );

    print(getbankcharges.statusCode);
    print(jsonDecode(getbankcharges.body));

    if(getbankcharges.statusCode == 200){

      setState(() {

        chargetalk = "Transfer charge: ₦";

        charge = jsonDecode(getbankcharges.body);

      });

    }
    else{

      print('Network Issues');

    }
  }

  @override
  initState(){
    super.initState();
    getbanks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: GestureDetector(
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
                  //withdraw text & back button
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
                              child: Text("Withdraw",style: TextStyle(
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
                        )
                    ),
                  ),

                  //available balance & amount
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

                        //available balance text
                        Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/17),
                          child: Text("Available Balance",textAlign: TextAlign.center,style: TextStyle(
                              fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),),
                        ),

                        //available figure
                        Container(
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/17,top: 10),
                          child: Text("₦"+widget.finalbalance.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),textAlign: TextAlign.center,style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Flexible(
                      child: ListView(
                      padding: EdgeInsets.zero,
                    children: [

                      //loading bank...
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(selectbank,style: TextStyle(
                          color: Color.fromRGBO(246, 123, 55, 1),
                          fontSize: 11
                        ),),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10,),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 0),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                color:Colors.white, //background color of dropdown button
                                border: Border.all(color: Color.fromRGBO(246, 123, 55, 1), width:1), //border of dropdown button
                                borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                              ),

                              child:Padding(
                                  padding: EdgeInsets.only(left:20, right:20,top: 2,bottom: 2),
                                  child:CustomSearchableDropDown(

                                    dropdownHintText: 'Search For bank here... ',
                                    // showLabelInMenu: true,
                                    primaryColor:Color.fromRGBO(246, 123, 55, 1),
                                    menuMode: true,
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                    items: raw,
                                    label: 'Select Bank',
                                    dropDownMenuItems: raw?.map((item) {
                                      return item['name'];
                                    })?.toList() ??
                                        [],
                                    onChanged: (value){
                                      if(value!=null)
                                      {
                                        selected = value['code'].toString();
                                        setState(() {
                                          bankname = value['name'].toString();
                                          bankid = value['id'].toString();
                                          bankcode = selected;
                                        });
                                        print(selected);
                                        print(bankname);
                                        print(bankid);
                                        print(bankcode);
                                      }
                                      else{
                                        selected=null;
                                        print(selected);
                                      }
                                    },
                                  ),
                              )
                          ),
                        ),
                      ),

                      Container(

                        child: Container(
                          margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _accnumber,
                              decoration: InputDecoration(
                                hintText: 'Acc Number',
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
                                if(val.length == 10){
                                  print(val);
                                  setState(() {
                                    accountname = "...";
                                  });
                                  getname(val.toString(), bankcode);
                                }
                              },
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(accountname,textAlign: TextAlign.right,style: TextStyle(
                          color: Colors.black,
                          fontSize: 12
                        ),),
                      ),

                      Container(

                        child: Container(
                            margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                            child: TextField(
                              controller: _amount,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                ThousandsFormatter(allowFraction: true)
                              ],
                              decoration: InputDecoration(
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(
                                      fontSize: 12
                                  ),
                                  prefix: Text('₦'),
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
                                print(val.length);
                                if(val.length > 0 ){
                                  print(val);
                                  getmybankcharge(val);
                                }
                              },
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(chargetalk+''+charge,textAlign: TextAlign.right,style: TextStyle(
                          color: Colors.black,
                        ),),
                      ),

                      Container(
                        child: Container(
                            margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                            child: TextField(
                              controller: _narration,
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
                      ),

                      GestureDetector(
                        onTap: (){
                          if(bankname.isNotEmpty && _amount.text.isNotEmpty &&
                              accountname.isNotEmpty && _narration.text.isNotEmpty &&
                              charge.isNotEmpty && accountname != "..." && charge != "..."){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return CodeUnlock(bankname: bankname,
                                amount: _amount.text,
                                accountname: accountname,
                                narration: _narration.text,
                                charge: charge,
                                useremail: widget.useremail,
                                idname: widget.idname,);
                            }));
                          }
                          else if(bankname.isNotEmpty && _amount.text.isNotEmpty &&
                              accountname.isNotEmpty && _narration.text.isNotEmpty &&
                              charge.isNotEmpty || accountname == "..." || charge == "..."){

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please wait...'))
                            );

                          }
                          else{

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Fill all fields'))
                            );

                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color.fromRGBO(246, 123, 55, 1)),
                              color: Colors.black
                          ),
                          margin: EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 20),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(child: Text('VERIFY',style: TextStyle(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)),
                        ),
                      )

                    ],
                  ))

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
