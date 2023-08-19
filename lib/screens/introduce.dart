import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:vendorandroid/screens/introducesecond.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ServiceTag {
  String id = "";
  String tag = "";
  ServiceTag({required this.id, required this.tag});
}

class Introduce extends StatefulWidget {
  String id = "";
  String useremail = "";
  Introduce({required this.id, required this.useremail});

  @override
  _IntroduceState createState() => _IntroduceState();
}

class _IntroduceState extends State<Introduce> {

  String drop = "Advertising";
  String options = 'No';
  String status = "";
  String appstatus = "Vendorhirve...";
  File? uploadimage;
  File? uploadimage2;
  File? uploadimage3;
  File? uploadimage4;
  File? uploadimage5;
  final ImagePicker _picker = ImagePicker();
  String filename = '';
  String filename2 = '';
  String filename3 = '';
  String filename4 = '';
  String filename5 = '';
  int _selectedpage = 0;

  Future<void> chooseImage() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage = File(choosedimage!.path);
      filename = choosedimage!.name;
    });
    print(filename);
  }

  Future<void> chooseImage2() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage2 = File(choosedimage!.path);
      filename2 = choosedimage!.name;
    });
    print(filename2);
  }

  Future<void> chooseImage3() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage3 = File(choosedimage!.path);
      filename3 = choosedimage!.name;
    });
    print(filename3);
  }

  Future<void> chooseImage4() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage4 = File(choosedimage!.path);
      filename4 = choosedimage!.name;
    });
    print(filename4);
  }

  Future<void> chooseImage5() async {
    var choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage5 = File(choosedimage!.path);
      filename5 = choosedimage!.name;
    });
    print(filename5);
  }

  Future<void> uploadImage() async {

    try{
      List<int> imageBytes = uploadimage!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
          body: {
            'image': baseimage,
            'filename': filename,
            'idname' : widget.id,
            'useremail' : widget.useremail
          }
      );

      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["status"]){
          print("Portfolio 1 Upload successful");
          setState(()  {
            appstatus = "First portfolio is registered";
          });
        }else if(jsondata["error"]){
          print("Error during upload");
        }else{
          print("Error 251");
        }
        // if(jsondata["error"]){
        //   print(jsondata["msg"]);
        // }else{
        //   print("Portfolio 1 Upload successful");
        // }
      }else{
        print("Error during connection to server");
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> uploadImage2() async {

    try{

      List<int> imageBytes = uploadimage2!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
          body: {
            'image': baseimage,
            'filename': filename2,
            'idname' : widget.id,
            'useremail' : widget.useremail
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["status"]){
          print("Portfolio 2 Upload successful");
          setState(() {
            appstatus = "Second portfolio is registered";
          });
        }else if(jsondata["error"]){
          print("Error during upload");
        }else{
          print("Error 251");
        }
      }else{
        print("Error during connection to server");
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> uploadImage3() async {

    try{

      List<int> imageBytes = uploadimage3!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
          body: {
            'image': baseimage,
            'filename': filename3,
            'idname' : widget.id,
            'useremail' : widget.useremail
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["status"]){
          print("Portfolio 3 Upload successful");
          setState(() {
            appstatus = "Third portfolio is registered";
          });
        }else if(jsondata["error"]){
          print("Error during upload");
        }else{
          print("Error 251");
        }
      }else{
        print("Error during connection to server");
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> uploadImage4() async {

    try{

      List<int> imageBytes = uploadimage4!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
          body: {
            'image': baseimage,
            'filename': filename4,
            'idname' : widget.id,
            'useremail' : widget.useremail
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["status"]){
          print("Portfolio 4 Upload successful");
          setState(() {
            appstatus = "Fourth portfolio is registered";
          });
        }else if(jsondata["error"]){
          print("Error during upload");
        }else{
          print("Error 251");
        }
      }else{
        print("Error during connection to server");
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> uploadImage5() async {

    try{

      List<int> imageBytes = uploadimage5!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
          body: {
            'image': baseimage,
            'filename': filename5,
            'idname' : widget.id,
            'useremail' : widget.useremail
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["status"]){
          print("Portfolio 5 Upload successful");
          setState(() {
            appstatus = "Fifth portfolio is registered";
          });
        }else if(jsondata["error"]){
          print("Error during upload");
        }else{
          print("Error 251");
        }
      }else{
        print("Error during connection to server");
      }
    }catch(e){
      print(e);
    }
  }

  List<DropdownMenuItem<String>> dropdownItems = [];

  List<ServiceTag> servicetags = [];

  TextEditingController services = new TextEditingController();
  TextEditingController _businessname = new TextEditingController();

  // List of items in our dropdown menu
  var items = [
    'Advertising',
    'Digital Marketing',
    'Content Writing',
    'Tailoring',
    'Shoe Making',
    'Solar & Inverter',
  ];

  Future introducebusiness() async{

    setState(() {
      _selectedpage = 1;
    });

    //Business name, industry and physical goods
    try{
      final response = await http.post(
          Uri.https('adeoropelumi.com','vendor/introducebusiness.php'),
          body: {
            'idname':widget.id,
            'useremail' : widget.useremail,
            'businessname' : _businessname.text,
            'industry': drop,
            'physicalgoods':options
          }
      );

      if(response.statusCode == 200){
        if(jsonDecode(response.body)== "business details"){
          status = "Business details registered";
          print(status);
          setState(() {
            appstatus = "Business details is registered";
          });
        }
      }

    }catch(e){
      print(e);
    }


    //Services
    try{
      for(int i=0; i<servicetags.length; i++){
        final responseservice = await http.post(
            Uri.https('adeoropelumi.com','vendor/vendorservices.php'),
            body: {
              'idname':widget.id,
              'useremail' : widget.useremail,
              'services' : servicetags[i].tag
            }
        );

        if(responseservice.statusCode == 200){
          if(jsonDecode(responseservice.body) == "service registered"){

            print('services registered');

            setState(() {
              appstatus = servicetags[i].tag+" Service is registered";
            });

            print(servicetags[i].tag+" service "+(i+1).toString());

          }
        }
      }


      //Portfolio 1
      try{

        List<int> imageBytes = uploadimage!.readAsBytesSync();
        String baseimage = base64Encode(imageBytes);

        var response = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
            body: {
              'image': baseimage,
              'filename': filename,
              'idname' : widget.id,
              'useremail' : widget.useremail
            }
        );

        if(response.statusCode == 200){
          var jsondata = json.decode(response.body);
          if(jsondata["status"]){
            print("Portfolio 1 Upload successful");
            setState(()  {
              appstatus = "First portfolio is registered";
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

      }catch(e){
        print(e);
      }


      //Portfolio 2
      try{

        List<int> imageBytes = uploadimage2!.readAsBytesSync();
        String baseimage = base64Encode(imageBytes);

        var response = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
            body: {
              'image': baseimage,
              'filename': filename2,
              'idname' : widget.id,
              'useremail' : widget.useremail
            }
        );

        if(response.statusCode == 200){
          var jsondata = json.decode(response.body);
          if(jsondata["status"]){
            print("Portfolio 2 Upload successful");
            setState(() {
              appstatus = "Second portfolio is registered";
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

      }catch(e){
        print(e);
      }


      //Portfolio 3
      try{

        List<int> imageBytes = uploadimage3!.readAsBytesSync();
        String baseimage = base64Encode(imageBytes);

        var response = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
            body: {
              'image': baseimage,
              'filename': filename3,
              'idname' : widget.id,
              'useremail' : widget.useremail
            }
        );

        if(response.statusCode == 200){
          var jsondata = json.decode(response.body);
          if(jsondata["status"]){
            print("Portfolio 3 Upload successful");
            setState(() {
              appstatus = "Third portfolio is registered";
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

      }catch(e){
        print(e);
      }

      //Portfolio 4
      try{

        List<int> imageBytes = uploadimage4!.readAsBytesSync();
        String baseimage = base64Encode(imageBytes);

        var response = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
            body: {
              'image': baseimage,
              'filename': filename4,
              'idname' : widget.id,
              'useremail' : widget.useremail
            }
        );

        if(response.statusCode == 200){
          var jsondata = json.decode(response.body);
          if(jsondata["status"]){
            print("Portfolio 4 Upload successful");
            setState(() {
              appstatus = "Fourth portfolio is registered";
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

      }catch(e){
        print(e);
      }

      //Portfolio 5
      try{

        List<int> imageBytes = uploadimage5!.readAsBytesSync();
        String baseimage = base64Encode(imageBytes);

        var response = await http.post(
            Uri.https('adeoropelumi.com', 'vendor/portfolio.php'),
            body: {
              'image': baseimage,
              'filename': filename5,
              'idname' : widget.id,
              'useremail' : widget.useremail
            }
        );

        if(response.statusCode == 200){
          var jsondata = json.decode(response.body);
          if(jsondata["status"]){
            print("Portfolio 5 Upload successful");
            setState(() {
              appstatus = "Fifth portfolio is registered";
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

      }catch(e){
        print(e);
      }

      setState(() {
        _selectedpage = 0;
        appstatus = "All set";
      });

      Navigator.push(context, MaterialPageRoute(builder: (context){
        return IntroSecond(id: widget.id,useremail: widget.useremail,);
      }));

    }catch(e){
      print(e);
    }

  }

  @override
  void initState(){
    super.initState();
    dropdownItems = List.generate(
      items.length,
          (index) => DropdownMenuItem(
        value: items[index],
        child: Text(
          items[index],style: TextStyle(
            fontSize: 17
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text("Introduce your Business",style: TextStyle(
                      fontSize: 20
                    ),),
                  ),
                ),

                // Container(
                //   margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                //   child: Text("Lorem ipsum dolor sit amet consectetur. Quam sed ac sed a leo ornare. Nunc ut odio felis.",textAlign: TextAlign.center,),
                // ),

                Container(
                  margin: EdgeInsets.only(top: 20,left: 10),
                  child: Text("Business Name"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: TextField(
                    controller: _businessname,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.black
                        )
                      )
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  child: Text("Industry"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color:Colors.grey, //background color of dropdown button
                          border: Border.all(color: Colors.grey, width:1), //border of dropdown button
                          borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                          // boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                          //   BoxShadow(
                          //       // color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                          //       // blurRadius: 5
                          //   ) //blur radius of shadow
                          // ]
                      ),

                      child:Padding(
                          padding: EdgeInsets.only(left:20, right:20),
                          child:DropdownButton<String>(
                            items: dropdownItems,
                            value: drop,
                            onChanged: (value) {
                              setState(() {
                                drop = value!;
                                print("You have selected $value");
                              });
                            },
                            icon: Padding( //Icon at tail, arrow bottom is default icon
                                padding: EdgeInsets.only(left:20),
                                child:Icon(Icons.arrow_drop_down)
                            ),
                            iconEnabledColor: Colors.white, //Icon color
                            style: TextStyle(  //te
                                color: Colors.white, //Font color
                                fontSize: 20 //font size on dropdown button
                            ),

                            dropdownColor: Colors.grey, //dropdown background color
                            underline: Container(), //remove underline
                            isExpanded: true, //make true to make width 100%
                          )
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  child: Text("Services"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5,left: 10,right: 10),
                  child: TextField(
                    controller: services,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: .5,
                          color: Colors.black,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: .5,
                          color: Colors.black
                        )
                      ),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            var rand = Random();
                            int id = rand.nextInt(1000000000);
                            print("lilo");
                            print(services.text);
                            setState(() {
                              servicetags.add(ServiceTag(id: id.toString(), tag: services.text));
                              services.clear();
                            });
                          },
                            child: Icon(Icons.check_circle,size: 30,)
                        ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(229, 228, 226, 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.only(left: 10,top: 5,right: 10),
                  child: Container(
                    // margin: EdgeInsets.only(left: 10),
                    child: Wrap(
                          children:[
                              for(int i = 0; i < servicetags.length; i++)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                              margin: EdgeInsets.only(left: 10,top: 3.5,bottom:3.5 ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(servicetags[i].tag),
                                  GestureDetector(
                                    onTap: (){
                                      print("lilo");
                                      setState(() {
                                        servicetags.removeWhere((a) =>
                                        a.id ==
                                            servicetags[i].id);
                                      });
                                    },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 8),
                                          child: Icon(Icons.cancel,size: 20,)
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  child: Text("Do you sell physical goods?"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color:Colors.grey, //background color of dropdown button
                        border: Border.all(color: Colors.grey, width:1), //border of dropdown button
                        borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                        // boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                        //   BoxShadow(
                        //       // color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                        //       // blurRadius: 5
                        //   ) //blur radius of shadow
                        // ]
                      ),

                      child:Padding(
                          padding: EdgeInsets.only(left:20, right:20),
                          child:DropdownButton(
                            value: options,
                            items: [ //add items in the dropdown
                              DropdownMenuItem(
                                child: Text("No",style: TextStyle(
                                    fontSize: 17
                                ),),
                                value: "No",
                              ),
                              DropdownMenuItem(
                                  child: Text("Yes",style: TextStyle(
                                      fontSize: 17
                                  ),),
                                  value: "Yes"
                              ),


                            ],
                            onChanged: (value){ //get value when changed
                              setState(() {
                                options = value!;
                              });
                              print("You have selected $value");
                            },
                            icon: Padding( //Icon at tail, arrow bottom is default icon
                                padding: EdgeInsets.only(left:20),
                                child:Icon(Icons.arrow_drop_down)
                            ),
                            iconEnabledColor: Colors.white, //Icon color
                            style: TextStyle(  //te
                                color: Colors.white, //Font color
                                fontSize: 20 //font size on dropdown button
                            ),

                            dropdownColor: Colors.grey, //dropdown background color
                            underline: Container(), //remove underline
                            isExpanded: true, //make true to make width 100%
                          )
                      )
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  child: Text("Business Portfolio"),
                ),

                Container(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      GestureDetector(
                        onTap: (){
                          chooseImage();
                        },
                          child:uploadimage == null?
                          Container(
                            margin: EdgeInsets.only(left: 10,top: 10),
                            decoration:BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                            ),
                            child: Image(image: AssetImage("assets/add.png"), color: Color.fromRGBO(129, 133, 137, 1),),
                          ):
                          Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child:Image.file(uploadimage!)
                          )
                      ),

                      GestureDetector(
                          onTap: (){
                            chooseImage2();
                          },
                          child:uploadimage2 == null?
                          Container(
                            width: 150,
                            margin: EdgeInsets.only(left: 10,top: 10),
                            decoration:BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                            ),
                            child: Image(image: AssetImage("assets/add.png"), color: Color.fromRGBO(129, 133, 137, 1),width: 50,),
                          ):
                          Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child:Image.file(uploadimage2!)
                          )
                      ),

                      GestureDetector(
                          onTap: (){
                            chooseImage3();
                          },
                          child:uploadimage3 == null?
                          Container(
                            width: 150,
                            margin: EdgeInsets.only(left: 10,top: 10),
                            decoration:BoxDecoration(
                              color: Color.fromRGBO(229, 228, 226, 1),
                            ),
                            child: Image(image: AssetImage("assets/add.png"), color: Color.fromRGBO(129, 133, 137, 1),width: 50,),
                          ):
                          Container(
                              margin: EdgeInsets.only(left: 10,top: 10),
                              child:Image.file(uploadimage3!)
                          )
                      ),

                      // GestureDetector(
                      //     onTap: (){
                      //       chooseImage4();
                      //     },
                      //     child:uploadimage4 == null?
                      //     Container(
                      //       width: 150,
                      //       margin: EdgeInsets.only(left: 10,top: 10),
                      //       decoration:BoxDecoration(
                      //         color: Color.fromRGBO(229, 228, 226, 1),
                      //       ),
                      //       child: Image(image: AssetImage("assets/add.png"), color: Color.fromRGBO(129, 133, 137, 1),width: 50,),
                      //     ):
                      //     Container(
                      //         margin: EdgeInsets.only(left: 10,top: 10),
                      //         child:Image.file(uploadimage4!)
                      //     )
                      // ),

                      // GestureDetector(
                      //     onTap: (){
                      //       chooseImage5();
                      //     },
                      //     child:uploadimage5 == null?
                      //     Container(
                      //       width: 150,
                      //       margin: EdgeInsets.only(left: 10,top: 10),
                      //       decoration:BoxDecoration(
                      //         color: Color.fromRGBO(229, 228, 226, 1),
                      //       ),
                      //       child: Image(image: AssetImage("assets/add.png"), color: Color.fromRGBO(129, 133, 137, 1),width: 50,),
                      //     ):
                      //     Container(
                      //         margin: EdgeInsets.only(left: 10,top: 10),
                      //         child:Image.file(uploadimage5!)
                      //     )
                      // ),

                    ],
                  ),
                ),

                //Next Button
                GestureDetector(
                  onTap: (){
                    introducebusiness();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 23, 10, 10),
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

                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Center(
                    child: Text(appstatus,style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic
                    ),),
                  ),
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
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    child: Image.asset("assets/processing.png",color: Color.fromRGBO(14, 44, 3, 1),),
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
                      child: Text(appstatus,style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic
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
