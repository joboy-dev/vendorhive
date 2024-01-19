import 'dart:convert';
import 'dart:io';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendorandroid/screens/successsignup.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Businesslogo extends StatefulWidget {
  String id = "";
  String useremail = "";
  String description = "";
  String state = "";
  Businesslogo({required this.id, required this.useremail, required this.description, required this.state});
  @override
  _BusinesslogoState createState() => _BusinesslogoState();
}

class _BusinesslogoState extends State<Businesslogo> {

  File? uploadimage;
  String logoname = '';
  String appstatus = "Vendorhive360";
  int _selectedpage = 0;
  final ImagePicker _picker = ImagePicker();

  //modify sent message
  String replacing(String word) {
    word = word.replaceAll("'", "{(L!I_0)}");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  String modify(String word) {
    word = word.replaceAll("{(L!I_0)}", "'");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  Future<void> chooseImage() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage = File(choosedimage!.path);
      logoname = choosedimage!.name;
    });
    print(logoname);
  }

  Future signup() async{

    setState((){
      appstatus = "loading";
      _selectedpage = 1;
    });

    //Portfolio 1
    try{

      List<int> imageBytes = uploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('vendorhive360.com', 'vendor/businesslogo.php'),
          body: {
            'image': baseimage,
            'filename': logoname,
            'idname' : widget.id,
            'useremail' : widget.useremail,
            'description' : replacing(widget.description),
            'state': widget.state
          }
      );

      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["status"]){
          print("Business logo is registered");
          setState(()  {
            appstatus = "Business logo is registered";
            _selectedpage =0 ;
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
            return  SuccessSignup();
          }), (r){
            return false;
          });
        }
        else if(jsondata["error"]){
          print("Error during upload");
        }
        else{
          print("Error 251");
        }
      }
      else{
        print("Error during connection to server");
      }

      setState((){
        _selectedpage = 0;
        appstatus="Vendorhive360";
      });

    }catch(e){
      print(e);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedpage == 0 ?
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //text
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Column(
                  children: [
                    Text("Upload Business Logo",style: TextStyle(
                        fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                    Container(
                      margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                      child: Text("Your logo Identifies your business. Let's see your identity",textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
            ),

            //upload picker
            GestureDetector(
                onTap: (){
                  chooseImage();
                },
                child:Container(
                  child: Column(
                    children: [
                      uploadimage == null?
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(229, 228, 226,1),
                        radius: MediaQuery.of(context).size.width/3,
                        child: Icon(Icons.camera_alt_outlined,color: Colors.grey,size: MediaQuery.of(context).size.width/3,),
                      ):
                      CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: MediaQuery.of(context).size.width/2.5,
                          child:Image.file(uploadimage!,width: MediaQuery.of(context).size.width/2,)
                      ),
                      Center(
                        child: Text(appstatus,style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      ),
                    ],
                  ),
                )
            ),

            //button
            GestureDetector(
              onTap: (){
                signup();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 123, 55, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Next",style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),)),
              ),
            ),
          ],
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
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    'Vendorhive360',
                    style: TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
