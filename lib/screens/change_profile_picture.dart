import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'success_edit_profile.dart';

class ChnageProfilePicture extends StatefulWidget {
  final String idname;
  final String email;

  ChnageProfilePicture({Key? key, required this.email, required this.idname})
      : super(key: key);

  @override
  _ChnageProfilePictureState createState() => _ChnageProfilePictureState();
}

class _ChnageProfilePictureState extends State<ChnageProfilePicture> {
  int _selectedpage = 0;
  File? uploadimage;
  String logoname = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> chooseImage() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage = File(choosedimage!.path);
      logoname = choosedimage!.name;
    });
    print(logoname);
  }

  Future changeProfilePic() async {
    //vendor email
    print(widget.email);

    //vendor id name
    print(widget.idname);

    setState(() {
      _selectedpage = 1;
    });

    //chnage profile picture
    try {
      List<int> imageBytes = uploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      var response = await http.post(
          Uri.https('vendorhive360.com', 'vendor/updateBusinessLogo.php'),
          body: {
            'image': baseimage,
            'filename': logoname,
            'idname': widget.idname,
            'useremail': widget.email,
          });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["status"]) {
          print("Business logo is changed");
          setState(() {
            _selectedpage = 0;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SuccessEditProfile()));
        } else if (jsondata["error"]) {
          print("Error during upload");
        } else {
          print("Error 251");
        }
      } else {
        print("Error during connection to server");
      }

      setState(() {
        _selectedpage = 0;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _selectedpage == 0
            ? SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //text
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Upload New Business Logo",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Text(
                                "Your logo Identifies your business. Let's see your identity",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //upload picker
                    GestureDetector(
                        onTap: () {
                          chooseImage();
                        },
                        child: Container(
                          child: Column(
                            children: [
                              uploadimage == null
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(229, 228, 226, 1),
                                      radius:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.grey,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                3,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              2.5,
                                      child: Image.file(
                                        uploadimage!,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                      )),
                              Center(
                                child: Text(
                                  "Vendorhive360",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )),

                    //button
                    GestureDetector(
                      onTap: () {
                        if (logoname.isNotEmpty) {
                          changeProfilePic();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Select an Image")));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(246, 123, 55, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          "Upload",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
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
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
