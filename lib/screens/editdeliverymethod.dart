import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditDeliveryMethod extends StatefulWidget {
  String adminemail = "";
  String pidname = "";
  String deliveryplan = "";
  String amount = "";
  String days = "";
  String productname = "";

  EditDeliveryMethod(
      {required this.adminemail,
      required this.pidname,
      required this.deliveryplan,
      required this.amount,
      required this.productname,
      required this.days,
      Key? key})
      : super(key: key);

  @override
  _EditDeliveryMethodState createState() => _EditDeliveryMethodState();
}

class _EditDeliveryMethodState extends State<EditDeliveryMethod> {

  bool loading = true;
  int done = 0;

  TextEditingController amount = TextEditingController();
  TextEditingController days = TextEditingController();

  Future update_delivery_price() async{

    print(widget.pidname);

    setState(() {
      loading = false;
    });

    final response = await http.post(
        Uri.https("vendorhive360.com","vendor/vendorupdatedeliveryprice.php"),
        body: {
          'amount':amount.text,
          'pidname' : widget.pidname,
          'plan' : widget.deliveryplan
        }
    );

    if(response.statusCode == 200){
      if(jsonDecode(response.body) == "true"){
        setState(() {
          loading = true;
          done = 1;
          amount.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Amount is changed!"))
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out"))
        );
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request timed out"))
      );
    }
  }

  Future update_delivery_days() async{

    print(widget.pidname);

    setState(() {
      loading = false;
    });

    final response = await http.post(
        Uri.https("vendorhive360.com","vendor/vendorupdatedeliverydays.php"),
        body: {
          'days':days.text,
          'pidname' : widget.pidname,
          'plan' : widget.deliveryplan
        }
    );

    if(response.statusCode == 200){
      if(jsonDecode(response.body) == "true"){
        setState(() {
          loading = true;
          done = 1;
          days.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Days is changed!"))
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out"))
        );
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request timed out"))
      );
    }
  }

  Future _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to delete this delivery plan?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                delete_delivery_plan();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future delete_delivery_plan() async{

    setState(() {
      loading = false;
    });

    final response = await http.post(
        Uri.https('vendorhive360.com','vendor/vendordeletedeliverymethod.php'),
        body:{
          'email':widget.adminemail,
          'pidname':widget.pidname,
          'plan':widget.deliveryplan,
        }
    );

    if(response.statusCode == 200){
      if(jsonDecode(response.body) == "true"){
        setState(() {
          loading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delivery Method is deleted"))
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
      else{
        setState(() {
          loading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request timed out"))
        );
      }
    }
    else{
      setState(() {
        loading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request timed out"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading?
      done == 0 ?
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, .5),
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //setting text
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child: Text(
                            widget.productname+" Delivery Method",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),
                      ),

                      //back button
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
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit Details for "+widget.deliveryplan,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.orange[700]
                      ),),
                    IconButton(onPressed: _showAlertDialog,
                        icon: Icon(Icons.cancel),
                      iconSize: 20,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Old Amount:",style: TextStyle(
                        fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("₦"+widget.amount.replaceAllMapped(
                        RegExp(
                            r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},'),style: TextStyle(
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
              const SizedBox(height: 2,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter new Amount",
                    hintStyle: TextStyle(
                      color: Colors.grey[200]
                    ),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  if(amount.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Fill amount field"))
                    );
                  }else{
                    update_delivery_price();
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text("Edit Amount",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Old Delivery Days:",style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(widget.days+" days",style: TextStyle(
                        fontSize: 14
                    ),),
                  ],
                ),
              ),
              const SizedBox(height: 2,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: days,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter new days",
                    hintStyle: TextStyle(
                        color: Colors.grey[200]
                    ),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  if(days.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fill days field"))
                    );
                  }else{
                    update_delivery_days();
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text("Edit Delivery Days",style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text("Vendorhive360",style: TextStyle(
                  fontSize: 12
                ),),
              )
            ],
          ),
        ),
      )
          :
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.orange.shade100,
                  Colors.green.shade100
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap:(){

                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/3,
                        child: Image.asset("assets/successs.png",),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          done = 0;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text("Click here to go back",style: TextStyle(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width/23
                        ),),
                      ),
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
                    height: MediaQuery.of(context).size.height / 3,
                    child: SpinKitFadingCube(
                      color: Colors.orange,
                      size: 100,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Processing",
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
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
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
}
