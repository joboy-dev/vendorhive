import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/failed.dart';
import 'package:vendorandroid/screens/successpackage.dart';

class ProcessPackagePayment extends StatefulWidget {
  String email = "";
  String package = "";
  String idname = "";

  ProcessPackagePayment({Key? key,
  required this.email,
  required this.idname,
  required this.package}) : super(key: key);

  @override
  _ProcessPackagePaymentState createState() => _ProcessPackagePaymentState();
}

class _ProcessPackagePaymentState extends State<ProcessPackagePayment> {

  String trfid = "";
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

    //timestamp
    currentdate();

    try{

      var recordpackage = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorpackagerecord.php'),
          body: {
            'email':widget.email,
            'package':widget.package,
            'refno': trfid
          }
      );

      var upgradepackage = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorupdatepackage.php'),
          body: {
            'email':widget.email,
            'package':widget.package
          }
      );

      //notify user
      var notifyuser = await http.post(
          Uri.https('vendorhive360.com', 'vendor/vendorsendnotification.php'),
          body: {
            'message': "You are now on "+widget.package+" package",
            'info': widget.email,
            'tag': 'Package',
            'quantity' : widget.package+" package",
            'refno': trfid
          }
      );

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
                  }
                  else{

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

                numberofservice = int.parse(numberassignedservice)+5;
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



              final SharedPreferences pref = await SharedPreferences.getInstance();

              await pref.setString('packagename', widget.package);

              Navigator.push(context, MaterialPageRoute(builder: (context){
                return SuccessPackage();
              }));

              print('package is recorded');

            }
            else{


              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Failed(trfid: trfid);
              }));

              print('failed recording pacakage');

            }
          }
          else{

            print('Network issue while recording package');

            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Failed(trfid: trfid);
            }));

          }
        }
        else{
          print('Failed while updating package');


          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Failed(trfid: trfid);
          }));

        }
      }
      else{

        print('Network issue while updating package');

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Failed(trfid: trfid);
        }));

      }
    }
    catch(e){

      var failedpackagepayment = await http.post(
          Uri.https('vendorhive360.com','vendor/failedpackagepayment.php'),
          body: {
            'email':widget.email,
            'refno':trfid
          }
      );

      if(failedpackagepayment.statusCode == 200){
        if(jsonDecode(failedpackagepayment.body) == "true"){


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

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pay();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Column(
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
                      ),
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
                        child: Text('Vendorhive360',
                          style: TextStyle(
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
}
