import 'package:vendorandroid/screens/businesschangefullname.dart';
import 'package:vendorandroid/screens/businesschangephone.dart';
import 'package:vendorandroid/screens/setdelivery.dart';
import 'package:flutter/material.dart';

class Editprofile extends StatefulWidget {
  String email = "";
  String idname = "";
  Editprofile({Key? key,
  required this.email,
  required this.idname}) : super(key: key);

  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    child: Text("Edit Profile",style: TextStyle(
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
                          child: Icon(Icons.arrow_back,color: Colors.black,
                          size: 25,),
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
                              width: MediaQuery.of(context).size.width/8,
                              margin: EdgeInsets.only(top: 10,left: 10),
                              child: Image.asset("assets/editprofile.png",
                                color: Color.fromRGBO(246, 123, 55, 1),),
                            ),

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10,left: 15),
                                child: Text("Change Phone Number",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/22.5,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
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
                              width: MediaQuery.of(context).size.width/8,
                              margin: EdgeInsets.only(top: 10,left: 10),
                              child: Image.asset("assets/edit.png",
                                // height: 54,
                                color: Color.fromRGBO(246, 123, 55, 1),),
                            ),
                            
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10,left: 15),
                                child: Text("Change Full Name",style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/22.5,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
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
    );
  }
}
