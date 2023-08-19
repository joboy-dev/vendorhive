import 'package:flutter/material.dart';
import 'package:vendorandroid/screens/businesschangefullname.dart';
import 'package:vendorandroid/screens/businesschangephone.dart';

class BusinessEditProfile extends StatefulWidget {
  String email = "";
  String idname = "";
  BusinessEditProfile({Key? key,
    required this.email,
    required this.idname}) : super(key: key);

  @override
  _BusinessEditProfileState createState() => _BusinessEditProfileState();
}

class _BusinessEditProfileState extends State<BusinessEditProfile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: SafeArea(
            child: Container(
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
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Edit Profile",style: TextStyle(
                              fontWeight: FontWeight.bold
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

                  Flexible(
                      child:ListView(
                        padding: EdgeInsets.zero,
                        children: [

                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return BusinessChangePhone(idname: widget.idname,
                                email: widget.email,);
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: .5,
                                          color: Colors.grey
                                      )
                                  )
                              ),
                              padding: EdgeInsets.only(bottom: 20),
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10,left: 15),
                                    child: Image.asset("assets/editprofile.png",
                                      width: MediaQuery.of(context).size.width/8,
                                      color: Color.fromRGBO(246, 123, 55, 1),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10,left: 10),
                                    child: Text("Change Phone Number",style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/22.5,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return BusinessChangeFullname(idname: widget.idname,
                                email: widget.email,);
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: .5,
                                          color: Colors.grey
                                      )
                                  )
                              ),
                              padding: EdgeInsets.only(bottom: 20),
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10,left: 10),
                                    child: Image.asset("assets/edit.png",
                                      width: MediaQuery.of(context).size.width/8,
                                      color: Color.fromRGBO(246, 123, 55, 1),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10,left: 15),
                                    child: Text("Change Full Name",style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/22.5,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  )
                                ],
                              ),
                            ),
                          ),

                        ],
                      )
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
