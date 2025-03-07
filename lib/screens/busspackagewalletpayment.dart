import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/success.dart';

class BussinessPackageWalletPayment extends StatefulWidget {
  String idname = "";
  String email = "";
  String package = "";
  String amount = "";
  BussinessPackageWalletPayment({Key? key,
    required this.idname,
    required this.email,
    required this.amount,
    required this.package}) : super(key: key);

  @override
  _BussinessPackageWalletPaymentState createState() => _BussinessPackageWalletPaymentState();
}

class _BussinessPackageWalletPaymentState extends State<BussinessPackageWalletPayment> {

  bool one_time_payment = true;
  int _selectedpage = 0;
  int amountofproducts = 0;
  int amountofservice = 0;
  String numberassignedproduct = "";
  String numberassignedservice = "";
  int numberofproduct = 0;
  int numberofservice = 0;
  int number_of_referals = 0;
  int number_of_referals_service = 0;
  List referals = [];
  List referals_service = [];
  List<String> idnames = [];
  List<String> sidnames = [];

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

  Future activate_available_products() async {

    print("print add product out");

    //check package for user email
    final getpackages = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetpackage.php'),
        body: {'useremail': widget.email});

    print("Package "+jsonDecode(getpackages.body)['package'].toString());

    //get upload number based on package
    final productamount = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetpackagedetails.php'),
        body: {
          'packagename': jsonDecode(getpackages.body)['package'].toString()
        });

    //check people you refered to add it
    var earn = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorviewearnings.php'),
        body: {
          'idname':widget.idname
        }
    );

    if (productamount.statusCode == 200 && earn.statusCode == 200) {
      print('getting assigned products');
      print(jsonDecode(productamount.body));
      print(jsonDecode(productamount.body)[0]);
      print("Assingned number of products for the package:- " +
          jsonDecode(productamount.body)[0]['productamount']);
      numberassignedproduct =
      jsonDecode(productamount.body)[0]['productamount'];
      if(jsonDecode(getpackages.body)['package'].toString() == "Free"){
        numberofproduct = int.parse(numberassignedproduct);
      }
      else{
        numberofproduct = int.parse(numberassignedproduct)+5;
      }
      print("Details of people I referred "+jsonDecode(earn.body).toString());
      //list of individuals I refered
      referals = jsonDecode(earn.body);
      print('Number of referals ${referals.length}');
      number_of_referals = referals.length;
      print("getting used products");
      //checking for number of products uploaded
      final checkfornumberofproducts = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorcheckproductid.php'),
          body: {'email': widget.email});

      if (checkfornumberofproducts.statusCode == 200) {
        idnames.clear();
        print(jsonDecode(checkfornumberofproducts.body));

        jsonDecode(checkfornumberofproducts.body)
            .forEach((s) => idnames.add(s["pidname"]));
        print("List lenght of product uploaded is ${idnames.length}");

        //amount of product uploaded
        amountofproducts = idnames.length;
        print("Number of product uploaded is $amountofproducts");

        print("Used amount of products :- $amountofproducts");

        // for (int o = 0; o < idnames.length; o++) {
        //   print("PId names in list " + idnames[o]);
        // }
        //

        int available_products = numberofproduct + number_of_referals;

        //activate number of products
        if(amountofproducts <= available_products){
          var activate_product = await http.post(
              Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_product.php'),
              body:{
                'useremail': widget.email,
                'number' : amountofproducts.toString()
              }
          );
        }else{
          //activate 5 products
          var activate_product = await http.post(
              Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_product.php'),
              body:{
                'useremail': widget.email,
                'number' : available_products.toString()
              }
          );
        }
      }
      else {
        setState(() {
          _selectedpage = 0;
        });
      }
    }
    else {
      setState(() {
        _selectedpage = 0;
      });
    }

  }

  Future activate_available_services() async {

    setState(() {
      _selectedpage = 1;
    });

    final getpackages = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetpackage.php'),
        body: {'useremail': widget.email});

    print("Package "+jsonDecode(getpackages.body)['package'].toString());

    final serviceamount = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorgetpackagedetails.php'),
        body: {
          'packagename': jsonDecode(getpackages.body)['package'].toString(),
        });

    var earn = await http.post(
        Uri.https('vendorhive360.com','vendor/vendorviewearnings.php'),
        body: {
          'idname':widget.idname
        }
    );

    if (serviceamount.statusCode == 200 && earn.statusCode == 200) {
      print(jsonDecode(serviceamount.body));

      print(jsonDecode(serviceamount.body)[0]);

      print("Assingned number of service:- " +
          jsonDecode(serviceamount.body)[0]['serviceamount']);

      numberassignedservice =
      jsonDecode(serviceamount.body)[0]['serviceamount'];

      if(jsonDecode(getpackages.body)['package'].toString() == "Free"){
        numberofservice = int.parse(numberassignedservice);
      }
      else{
        numberofservice = int.parse(numberassignedservice)+5;
      }
    }
    else {
      setState(() {
        _selectedpage = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text('Network Issues when getting number of assigned services')));
    }

    print("getting services");

    final checkfornumberofservices = await http.post(
        Uri.https('vendorhive360.com', 'vendor/vendorcheckserviceid.php'),
        body: {'email': widget.email});

    if (checkfornumberofservices.statusCode == 200) {
      sidnames.clear();
      print(jsonDecode(checkfornumberofservices.body));

      jsonDecode(checkfornumberofservices.body)
          .forEach((s) => sidnames.add(s["sidname"]));
      print("List lenght is ${sidnames.length}");

      amountofservice = sidnames.length;
      print(amountofservice);

      print("Used amount of services :- $amountofservice");

      // for (int o = 0; o < sidnames.length; o++) {
      //   print("SId names in list " + sidnames[o]);
      // }

      referals_service = jsonDecode(earn.body);
      number_of_referals_service = referals_service.length;

      int available_service = numberofservice + number_of_referals_service;

      //activate available service
      if(amountofservice <= available_service){
        final activate_service = await http.post(
            Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_service.php'),
            body:{
              "useremail": widget.email,
              "number": amountofservice.toString()
            }
        );
      }
      else{
        final activate_service = await http.post(
            Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_service.php'),
            body:{
              "useremail": widget.email,
              "number": available_service.toString()
            }
        );
      }
    }
    else {
      setState(() {
        _selectedpage = 0;
      });

      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text('Network Issues'),
      ));
    }
  }

  Future pay() async{

    setState(() {
      _selectedpage = 1;
    });

    //timestamp
    currentdate();

    try{

      final procespayment = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorpinprocess.php'),
          body: {
            'idname':widget.idname,
            'useremail':widget.email,
            'pin':pin1.text+pin2.text+pin3.text+pin4.text
          }
      );

      var getbalance = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorbusinessavailablebalance.php'),
          body: {
            'adminemail':widget.email
          }
      );

      if(getbalance.statusCode == 200){

        setState(() {
          finalbalance = jsonDecode(getbalance.body);
        });

        print("Available balance is "+finalbalance);
        if(procespayment.statusCode == 200) {
          if (jsonDecode(procespayment.body) == 'true') {
            print('correct pin');
            if (double.parse(finalbalance) >= double.parse(widget.amount)) {

              String desc = 'purchaced '+widget.package+' package.';

              String itemid = "wt "+trfid;

              //save transaction in vendor wallet
              var savetransaction = await http.post(
                  Uri.https('vendorhive360.com','vendor/vendorsaveinbusinesswallet.php'),
                  body: {
                    'idname': widget.idname,
                    'useremail': widget.email,
                    'adminemail': widget.email,
                    'debit':widget.amount,
                    'credit': '0',
                    'status': 'completed',
                    'refno' : trfid,
                    'description': desc,
                    'itemid': itemid
                  }
              );

              var upgradepackage = await http.post(
                  Uri.https('vendorhive360.com','vendor/vendorupdatepackage.php'),
                  body: {
                    'email':widget.email,
                    'package':widget.package
                  }
              );

              var recordpackage = await http.post(
                  Uri.https('vendorhive360.com','vendor/vendorpackagerecord.php'),
                  body: {
                    'email':widget.email,
                    'package':widget.package,
                    'refno': trfid
                  }
              );



              if(savetransaction.statusCode == 200){
                print(jsonDecode(savetransaction.body));
                if(jsonDecode(savetransaction.body)=='true'){
                  if(upgradepackage.statusCode == 200){
                    if(jsonDecode(upgradepackage.body) == 'true'){
                      print('User is upgraded to '+widget.package);
                      if(recordpackage.statusCode == 200){
                        if(jsonDecode(recordpackage.body) == 'true'){

                          //get upload number based on package
                          final productamount = await http.post(
                              Uri.https('vendorhive360.com', 'vendor/vendorgetpackagedetails.php'),
                              body: {
                                'packagename': widget.package
                              });

                          //check people you refered to add it
                          var earn = await http.post(
                              Uri.https('vendorhive360.com','vendor/vendorviewearnings.php'),
                              body: {
                                'idname':widget.idname
                              }
                          );

                          //processing service
                          final serviceamount = await http.post(
                              Uri.https('vendorhive360.com', 'vendor/vendorgetpackagedetails.php'),
                              body: {
                                'packagename': widget.package,
                              });

                          if (productamount.statusCode == 200 && earn.statusCode == 200) {
                            print('getting assigned products');
                            print(jsonDecode(productamount.body));
                            print(jsonDecode(productamount.body)[0]);
                            print("Assingned number of products for the package:- " +
                                jsonDecode(productamount.body)[0]['productamount']);

                            numberassignedproduct =
                            jsonDecode(productamount.body)[0]['productamount'];

                            numberofproduct = int.parse(numberassignedproduct)+5;

                            print("Details of people I referred "+jsonDecode(earn.body).toString());

                            //list of individuals I refered
                            referals = jsonDecode(earn.body);
                            print('Number of referals ${referals.length}');
                            number_of_referals = referals.length;

                            print("getting used products");
                            //checking for number of products uploaded
                            final checkfornumberofproducts = await http.post(
                                Uri.https('vendorhive360.com', 'vendor/vendorcheckproductid.php'),
                                body: {'email': widget.email});

                            if (checkfornumberofproducts.statusCode == 200) {
                              idnames.clear();
                              print(jsonDecode(checkfornumberofproducts.body));

                              jsonDecode(checkfornumberofproducts.body)
                                  .forEach((s) => idnames.add(s["pidname"]));
                              print("List lenght of product uploaded is ${idnames.length}");

                              //amount of product uploaded
                              amountofproducts = idnames.length;
                              print("Number of product uploaded is $amountofproducts");

                              print("Used amount of products :- $amountofproducts");

                              // for (int o = 0; o < idnames.length; o++) {
                              //   print("PId names in list " + idnames[o]);
                              // }
                              //

                              int available_products = numberofproduct + number_of_referals;

                              //activate number of products
                              if(amountofproducts <= available_products){
                                var activate_product = await http.post(
                                    Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_product.php'),
                                    body:{
                                      'useremail': widget.email,
                                      'number' : amountofproducts.toString()
                                    }
                                );
                              }else{

                                var activate_product = await http.post(
                                    Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_product.php'),
                                    body:{
                                      'useremail': widget.email,
                                      'number' : available_products.toString()
                                    }
                                );
                              }
                            }
                            else {
                              ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                                content: Text('Network Issues, Please go back and retry'),
                              ));
                            }
                          }
                          else {
                            ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                              content: Text('Network Issues, Please go back and retry'),
                            ));
                          }

                          if (serviceamount.statusCode == 200 && earn.statusCode == 200) {
                            print(jsonDecode(serviceamount.body));

                            print(jsonDecode(serviceamount.body)[0]);

                            print("Assingned number of service:- " +
                                jsonDecode(serviceamount.body)[0]['serviceamount']);

                            numberassignedservice =
                            jsonDecode(serviceamount.body)[0]['serviceamount'];

                            numberofservice = int.parse(numberassignedservice) + 5;
                          }
                          else {

                            ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                              content: Text('Network Issues, Please go back and retry'),
                            ));
                          }

                          print("getting services");

                          final checkfornumberofservices = await http.post(
                              Uri.https('vendorhive360.com', 'vendor/vendorcheckserviceid.php'),
                              body: {'email': widget.email});

                          if (checkfornumberofservices.statusCode == 200) {
                            sidnames.clear();
                            print(jsonDecode(checkfornumberofservices.body));

                            jsonDecode(checkfornumberofservices.body)
                                .forEach((s) => sidnames.add(s["sidname"]));
                            print("List lenght is ${sidnames.length}");

                            amountofservice = sidnames.length;
                            print(amountofservice);

                            print("Used amount of services :- $amountofservice");

                            // for (int o = 0; o < sidnames.length; o++) {
                            //   print("SId names in list " + sidnames[o]);
                            // }

                            referals_service = jsonDecode(earn.body);
                            number_of_referals_service = referals_service.length;

                            int available_service = numberofservice + number_of_referals_service;

                            //activate available service
                            if(amountofservice <= available_service){
                              final activate_service = await http.post(
                                  Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_service.php'),
                                  body:{
                                    "useremail": widget.email,
                                    "number": amountofservice.toString()
                                  }
                              );
                            }
                            else{
                              final activate_service = await http.post(
                                  Uri.https('vendorhive360.com','vendor/vendor_activate_number_of_service.php'),
                                  body:{
                                    "useremail": widget.email,
                                    "number": available_service.toString()
                                  }
                              );
                            }
                          }
                          else {

                            ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                              content: Text('Network Issues, Please go back and retry'),
                            ));
                          }


                          setState(() {
                            _selectedpage = 0;
                            one_time_payment = true;
                            pin1.clear();
                            pin2.clear();
                            pin3.clear();
                            pin4.clear();
                          });

                          print('package is recorded');

                          final SharedPreferences pref = await SharedPreferences.getInstance();

                          await pref.setString('packagename', widget.package);

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return Success();
                          }));

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

                          print('failed processing package');

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return Failed(trfid: trfid);
                          }));

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

                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Failed(trfid: trfid);
                        }));

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

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return Failed(trfid: trfid);
                      }));

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

                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Failed(trfid: trfid);
                    }));

                  }
                }
                else{

                  print('Failed package bought');

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Failed(trfid: trfid);
                  }));
                }
              }
              else{

                print('Network issues');

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Failed(trfid: trfid);
                }));
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

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{
        print('Vendor balance was not gotten');
        setState(() {
          _selectedpage = 0;
          one_time_payment = true;
          pin1.clear();
          pin2.clear();
          pin3.clear();
          pin4.clear();
        });

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
    catch(e){

      var failedpackagepayment = await http.post(
          Uri.https('vendorhive360.com','vendor/failedpackagewalletpayament.php'),
          body: {
            'email':widget.email,
            'refno':trfid
          }
      );

      if(failedpackagepayment.statusCode == 200){
        if(jsonDecode(failedpackagepayment.body) == "true"){

          setState(() {
            one_time_payment = true;
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
                                margin: EdgeInsets.only(bottom: 40),
                                child: Center(
                                  child: Text('Vendorhive360',style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: MediaQuery.of(context).size.width/25,
                                    fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.center,),
                                ),
                              )
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
      Center(
        child: Container(
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
    );
  }
}
