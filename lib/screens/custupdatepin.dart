import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustUpdatePin extends StatefulWidget {
  String idname = "";
  String email = "";
  CustUpdatePin({Key? key,
  required this.idname,
  required this.email}) : super(key: key);

  @override
  _CustUpdatePinState createState() => _CustUpdatePinState();
}

class _CustUpdatePinState extends State<CustUpdatePin> {

  int _selectedpage = 0;
  TextEditingController _oldpin = new TextEditingController();
  TextEditingController _newpin = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _selectedpage == 0 ?
        GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: SafeArea(
              child: ListView(
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
                          child: Text("Update Pin",style: TextStyle(
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
                                backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                                child: Icon(Icons.arrow_back,color: Colors.black,),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: _oldpin,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Enter Old Pin',
                        contentPadding: EdgeInsets.only(left: 10)
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: _newpin,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                          hintText: 'Enter New Pin',
                          contentPadding: EdgeInsets.only(left: 10)
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(_oldpin.text.isNotEmpty && _newpin.text.isNotEmpty){
                        if(_oldpin.text.toString().length == 4 && _newpin.text.toString().length == 4 ){
                          pin();
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Pin must be 4 digits'))
                          );
                        }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fill all fields'))
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orangeAccent),
                          color: Colors.green
                      ),
                      child: Center(
                        child: Text('Change Pin',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width/21
                        ),),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text('Vendorhive360',style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/30,
                          fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    height: MediaQuery.of(context).size.width/2,
                    width: MediaQuery.of(context).size.width/2,
                    child: Image.asset("assets/change-passcode.png"),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      fontSize: MediaQuery.of(context).size.width/29,
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text('Vendorhive360',style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/30,
                          fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future pin()async{

    setState(() {
      _selectedpage = 1;
    });

    print("processing pin");

    var procespayment = await http.post(Uri.https('vendorhive360.com','vendor/vendorpinprocess.php'),body: {
      'idname':widget.idname,
      'useremail':widget.email,
      'pin':_oldpin.text
    });

    if(procespayment.statusCode == 200){
      print(jsonDecode(procespayment.body));
      if(jsonDecode(procespayment.body)=='true'){

        var updatepin = await http.post(
            Uri.https('vendorhive360.com','vendor/vendorcustpinupdate.php'),
            body: {
              'email':widget.email,
              'pin':_newpin.text
            }
        );

        print(jsonDecode(updatepin.body));
        if(jsonDecode(updatepin.body)=='true'){

          setState(() {
            _selectedpage = 0;
            _newpin.clear();
            _oldpin.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pin is Successful'))
          );

        }
        else{

          setState(() {
            _selectedpage = 0;
            _newpin.clear();
            _oldpin.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed, try again'))
          );

        }

      }
      else{
        setState(() {
          _selectedpage = 0;
          _newpin.clear();
          _oldpin.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Old pin is incorrect'))
        );
      }
    }
  }

}
