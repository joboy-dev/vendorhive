import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Viewadminorder extends StatefulWidget {
  String productname = "";
  String productid = "";
  String productimage = "";
  String productprice = "";
  String deliveryprice = "";
  String location = "";
  String adminemail = "";
  String useremail = "";
  String tkid = "";
  Viewadminorder({
    required this.productname,
    required this.productid,
    required this.productimage,
    required this.productprice,
    required this.deliveryprice,
    required this.location,
    required this.adminemail,
    required this.useremail,
    required this.tkid
  });

  @override
  _ViewadminorderState createState() => _ViewadminorderState();
}

class _ViewadminorderState extends State<Viewadminorder> {

  int _selectedpage = 0;
  bool shipped = false;
  bool delivered = false;
  int shippedpin = 0;
  int deliveredpin = 0;
  bool enableshipping = false;
  bool enabledelivery = false;
  bool loading = false;
  bool loadingdeli = false;
  String appstat = "Vendorhive360";

  TextEditingController _shippedpin = TextEditingController();
  TextEditingController _deliveredpin = TextEditingController();

  Future productstats() async{

    setState(() {
      appstat = "loading...";
    });

    var productstatus = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorshipped.php'),
        body: {
          'productid':widget.tkid,
          'adminemail':widget.adminemail,
          'useremail':widget.useremail
        }
    );

    if(productstatus.statusCode == 200){

      print(jsonDecode(productstatus.body)[0]['ordershipped']);
      if(jsonDecode(productstatus.body)[0]['ordershipped'] == 'undone'){

        setState(() {
          enableshipping = true;
          enabledelivery = false;
          loading = true;
          loadingdeli = false;
          appstat = "Vendorhive360";
        });

      }
      else{

        setState(() {
          loading = false;
          enableshipping = false;
          enabledelivery = false;
        });

        print(jsonDecode(productstatus.body)[0]['orderarrived']);
        if(jsonDecode(productstatus.body)[0]['orderarrived'] == 'undone'){

          setState(() {
            loading = true;
            enabledelivery = true;
            loadingdeli = false;
            appstat = "Vendorhive360";
          });

        }
        else{

          setState(() {
            loading = true;
            enabledelivery = false;
            loadingdeli = true;
            appstat = "Vendorhive360";
          });

        }
      }
    }
  }

  Future updateshippedorder() async {

    setState(() {
      _selectedpage = 1;
    });

    var updateshiporder = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorupdateshipped.php'),
        body: {
          'productid':widget.tkid,
          'adminemail':widget.adminemail,
          'useremail':widget.useremail,
        }
    );

    if(updateshiporder.statusCode == 200){
      if(jsonDecode(updateshiporder.body)=='true'){

        setState(() {
          _selectedpage = 0;
          loading = true;
          shipped = false;
          enableshipping = false;
          loading = true;
          enabledelivery = true;
          loadingdeli = false;
        });

        print("Shipped order is registered");

      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        print("Shipped order is not registered");

      }
    }
  }

  Future updatearrivedorder() async {

    setState(() {
      _selectedpage = 1;
    });

    var updatearrive = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorupdatearrived.php'),
        body: {
          'productid':widget.tkid,
          'useremail':widget.useremail,
          'adminemail': widget.adminemail
        }
    );

    if(updatearrive.statusCode == 200){
      if(jsonDecode(updatearrive.body)=='true'){

        setState(() {
          _selectedpage = 0;
          delivered = false;
          enabledelivery = false;
          loadingdeli = true;
          loading = true;
        });

        print("Product has arrived at destination");

      }
      else{

        setState(() {
          _selectedpage = 0;
        });

        print("Product has not arrived at destination");

      }
    }
    else{

      setState(() {
        _selectedpage = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Issues'))
      );

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productstats();
    print(widget.tkid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, .5),
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Order Status",style: TextStyle(
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

              Flexible(
                  child: ListView(
                  children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height/30,
                  ),

                  //Image
                  Container(
                    height: MediaQuery.of(context).size.height/4,
                    child: Center(child: Image.network("https://adeoropelumi.com/vendor/productimage/"+widget.productimage)),
                  ),
                  //inform
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text("Inform the customer about he/her product "),
                    ),
                  ),

                  enableshipping ?
                  GestureDetector(
                    onTap: () {

                      setState(() {
                        if(shipped == false){
                          var rng = Random();
                          shippedpin = rng.nextInt(9999);
                          shipped = true;
                        }else if(shipped == true){
                          shipped = false;
                        }
                      });

                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 40, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(14, 44, 3, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Order is shipped",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),)),
                    ),
                  )
                  :
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 40, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(178, 190, 181, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child:
                      loading ?
                      Text("Customer is notified of shipped order",
                        textAlign: TextAlign.center,style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),)
                          :
                          Icon(Icons.more_horiz)
                      ),
                    ),

                  shipped ?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text("Shipped pin is ${shippedpin}"),
                    ),
                  )
                  :
                  Container(),

                  shipped ?
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: _shippedpin,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter pin',
                        enabledBorder: OutlineInputBorder(

                        ),
                        focusedBorder: OutlineInputBorder(

                        )
                      ),
                    ),
                  )
                  :
                  Container(),

                  shipped ?
                  GestureDetector(
                    onTap: () {
                      if(_shippedpin.text == shippedpin.toString()){
                        print("Correct pin");
                        updateshippedorder();
                      }else{
                        print("wrong pin");
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text('wrong pin'),
                            ));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 4, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(246, 123, 55, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Click here to confirm",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),)),
                    ),
                  )
                  :
                  Container(),

                  enabledelivery ?
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        if(delivered == false){
                          delivered = true;
                          var rng = Random();
                          deliveredpin = rng.nextInt(9999);
                        }else if(delivered == true){
                          delivered = false;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(14, 44, 3, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Order is delivered",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),)),
                    ),
                  )
                  :
                  Container(

                    margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    padding: EdgeInsets.symmetric(vertical: 18),

                    decoration: BoxDecoration(
                        color: Color.fromRGBO(178, 190, 181, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),

                    child: Center(
                        child:

                    loadingdeli ?

                    Text("Customer is notified of delivered order",
                      textAlign: TextAlign.center,style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),)

                    :

                        Icon(Icons.more_horiz)

                    ),
                  ),

                  delivered ?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text("Delivery pin is ${deliveredpin}"),
                    ),
                  )
                      :
                  Container(),

                  delivered ?
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: _deliveredpin,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter pin',
                          enabledBorder: OutlineInputBorder(

                          ),
                          focusedBorder: OutlineInputBorder(

                          )
                      ),
                    ),
                  )
                      :
                  Container(),

                  delivered ?
                  GestureDetector(
                    onTap: () {
                      if(_deliveredpin.text == deliveredpin.toString()){
                        print("Correct pin");
                        updatearrivedorder();

                      }else{
                        print("wrong pin");
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text('wrong pin'),
                            ));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 4, 10, 5),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(246, 123, 55, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Click here to confirm",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),)),
                    ),
                  )
                      :
                  Container(),

                  Container(
                    margin: EdgeInsets.only(bottom: 10,top: 10),
                    child: Center(
                      child: Text(appstat,style: TextStyle(
                          fontStyle: FontStyle.italic
                      ),),
                    ),
                  )
                ],
              )),
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
                    child: Text("Processing",style: TextStyle(
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
