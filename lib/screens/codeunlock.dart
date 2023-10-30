import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/withdrawsuccess.dart';

class CodeUnlock extends StatefulWidget {
  String idname = "";
  String useremail = "";
  String bankname = "";
  String accountname = "";
  String amount = "";
  String narration = "";
  String charge = "";
  String account_number = "";

  CodeUnlock(
      {required this.bankname,
      required this.accountname,
      required this.amount,
      required this.narration,
      required this.charge,
      required this.idname,
      required this.useremail,
      required this.account_number});

  @override
  _CodeUnlockState createState() => _CodeUnlockState();
}

class _CodeUnlockState extends State<CodeUnlock> {
  int _selectedpage = 0;

  // text controller
  final TextEditingController pin1 = TextEditingController();
  final TextEditingController pin2 = TextEditingController();
  final TextEditingController pin3 = TextEditingController();
  final TextEditingController pin4 = TextEditingController();

  void init() {
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
      body: _selectedpage == 0
          ? GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(238, 252, 233, 1)),
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
                              child: Text(
                                "Enter pin",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(217, 217, 217, 1),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width / 20,
                            bottom: MediaQuery.of(context).size.width / 15),
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
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Amount:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        '₦' + widget.amount,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
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
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Charge:',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        '₦' + widget.charge,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
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
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Beneficiary:',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Container(
                                    child: Text(
                                      widget.accountname,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Bank:',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Container(
                                    child: Text(
                                      widget.bankname,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // display the entered numbers
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                            child: Text(
                          "Please enter your PIN",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 25,
                          ),
                        )),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                              Container(
                                  height: MediaQuery.of(context).size.width / 8,
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: TextFormField(
                                    controller: pin1,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    // onSaved: (pin1){},
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100))),
                                    // style: Theme.of(context).textTheme.titleLarge,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                14,
                                        fontWeight: FontWeight.w500),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )),
                              Container(
                                  height: MediaQuery.of(context).size.width / 8,
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: TextFormField(
                                    controller: pin2,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    // onSaved: (pin2){},
                                    // decoration: InputDecoration(hintText: "0"),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100))),
                                    // style: Theme.of(context).textTheme.titleLarge,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                14,
                                        fontWeight: FontWeight.w500),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )),
                              Container(
                                  height: MediaQuery.of(context).size.width / 8,
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: TextFormField(
                                    controller: pin3,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    // onSaved: (pin1){},
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100))),
                                    // style: Theme.of(context).textTheme.titleLarge,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                14,
                                        fontWeight: FontWeight.w500),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )),
                              Container(
                                  height: MediaQuery.of(context).size.width / 8,
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: TextFormField(
                                    controller: pin4,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    // onSaved: (pin1){},
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100))),
                                    // style: Theme.of(context).textTheme.titleLarge,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                14,
                                        fontWeight: FontWeight.w500),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  )),
                            ])),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (pin1.text.isNotEmpty &&
                              pin2.text.isNotEmpty &&
                              pin3.text.isNotEmpty &&
                              pin4.text.isNotEmpty) {
                            debitcust();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Enter Complete pin')));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 123, 55, 1),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          margin: EdgeInsets.only(
                              top: 40, bottom: 40, left: 10, right: 10),
                          child: Center(
                              child: Text(
                            "Request Withdraw",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 22,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: SpinKitFadingCube(
                            color: Colors.orange,
                            size: 100,
                          ),
                        ),
                        Container(
                          child: Text(
                            "Processing payment",
                            style: TextStyle(
                                color: Color.fromRGBO(246, 123, 55, 1),
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 26),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Center(
                            child: Text(
                              'Vendorhive360',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
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

  void currentdate() {
    print('Timestamp is gotten as refno');
    DateTime now = new DateTime.now();
    print(now.toString());
    timestamp(now.toString());
    trfid = timestamp(now.toString());
    print(trfid);
  }

  String timestamp(String str) {
    str = str.replaceAll(":", "");
    str = str.replaceAll("-", "");
    str = str.replaceAll(".", "");
    str = str.replaceAll(" ", "");
    return str;
  }

  String finalbalance = "";

  Future debitcust() async {
    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();
    try {
      double total = double.parse(widget.amount.replaceAll(",", "")) +
          double.parse(widget.charge);
      print(total);

      var getbalance = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorcustbalance.php'),
          body: {
            'custemail': widget.useremail,
          });

      if (getbalance.statusCode == 200) {
        setState(() {
          finalbalance = jsonDecode(getbalance.body);
        });

        print("Wallet balance is " + finalbalance);
      }

      final procespayment = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorpinprocess.php'),
          body: {
            'idname': widget.idname,
            'useremail': widget.useremail,
            'pin': pin1.text + pin2.text + pin3.text + pin4.text
          });

      if (procespayment.statusCode == 200) {
        if (jsonDecode(procespayment.body) == 'true') {
          if (double.parse(finalbalance) >= total) {
            String desc =
                'to ' + widget.accountname + ' for ' + widget.narration;

            var debitcustwallet = await http.post(
                Uri.https(
                    'adeoropelumi.com', 'vendor/vendorcustupdatewallet.php'),
                body: {
                  'idname': widget.idname,
                  'email': widget.useremail,
                  'debit': total.toString(),
                  'credit': '0',
                  'desc': desc,
                  'refno': trfid,
                });

            if (debitcustwallet.statusCode == 200) {
              if (jsonDecode(debitcustwallet.body) == 'true') {
                print('cust wallet is debited');

                var sendinstruction = await http.post(
                    Uri.https('adeoropelumi.com',
                        'vendor/withdrawal_instruction.php'),
                    body: {
                      'idname': widget.idname,
                      'email': widget.useremail,
                      'debit': widget.amount,
                      'desc': desc,
                      'refno': trfid,
                      'account_name': widget.accountname,
                      'bank_name': widget.bankname,
                      'transfer_charge': widget.charge,
                      'account_number': widget.account_number
                    });

                if (jsonDecode(sendinstruction.body) == 'true') {
                  setState(() {
                    _selectedpage = 0;

                    pin1.clear();
                    pin2.clear();
                    pin3.clear();
                    pin4.clear();
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WithdrawSuccess();
                  }));
                } else {
                  setState(() {
                    _selectedpage = 0;
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Failed(trfid: trfid);
                  }));
                }
              } else {
                setState(() {
                  _selectedpage = 0;
                });

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Failed')));
              }
            } else {
              setState(() {
                _selectedpage = 0;
              });

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Failed(trfid: trfid);
              }));
            }
          } else {
            setState(() {
              _selectedpage = 0;
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Insufficient Balance')));
          }
        } else {
          setState(() {
            _selectedpage = 0;
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Wrong pin')));
        }
      } else {
        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Failed(trfid: trfid);
        }));
      }
    } catch (e) {
      print("error " + e.toString());

      var failedwithdrawal = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/failedwithdrawal.php'),
          body: {'refno': trfid});

      if (failedwithdrawal.statusCode == 200) {
        if (jsonDecode(failedwithdrawal.body) == "true") {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: trfid);
          }));
        } else {
          setState(() {
            _selectedpage = 0;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Failed(trfid: trfid);
          }));
        }
      } else {
        setState(() {
          _selectedpage = 0;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Failed(trfid: trfid);
        }));
      }
    }
  }
}
