import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vendorandroid/screens/faileddelete.dart';
import 'package:vendorandroid/screens/successfuldelete.dart';

class DeleteVendor extends StatefulWidget {
  String email = "";
  String idname = "";

  DeleteVendor({required this.email, required this.idname, Key? key})
      : super(key: key);

  @override
  _DeleteVendorState createState() => _DeleteVendorState();
}

class _DeleteVendorState extends State<DeleteVendor> {
  int _loadIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.email);
    print(widget.idname);
  }

  Future delete_account() async {
    setState(() {
      _loadIndex = 1;
    });
    var response = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/delete_vendor_account.php'),
        body: {'email': widget.email});
    if(response.statusCode == 200){
      if(jsonDecode(response.body)=="true"){
        setState(() {
          _loadIndex = 0;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SuccessDelete();
        }));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return FailedDelete();
        }));
      }
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return FailedDelete();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: _loadIndex == 0
              ? Column(
            children: [
              //setting app bar
              Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, .5),
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //setting text
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Delete Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
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
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: Text(
                  "Do you want to delete your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        delete_account();
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Yes",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset("assets/delete-document.png"),
              ),
              Container(
                child: Text(
                  "Vendorhive360",
                  style: TextStyle(
                      color: Colors.orange[900],
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
            ],
          ):
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
                          "processing",
                          style: TextStyle(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            fontWeight: FontWeight.bold,
                          ),
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
        )
    );
  }
}
