import 'package:vendorandroid/screens/businesslogo.dart';
import 'package:flutter/material.dart';

class IntroSecond extends StatefulWidget {
  String id = "";
  String useremail = "";
  IntroSecond({required this.id, required this.useremail});

  @override
  _IntroSecondState createState() => _IntroSecondState();
}

class _IntroSecondState extends State<IntroSecond> {
  String appstatus = "Vendorhirve...";
  String drop = "Lagos State";
  String desc = "";
  String finaldesc = "";
  int _selectedpage = 0;
  TextEditingController _description = new TextEditingController();

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

  void introducebusiness(){

    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Businesslogo(
        id: widget.id,
        useremail: widget.useremail,
        description: _description.text,
        state: drop,);
    }));

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
                Container(
                  margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: Text("Lorem ipsum dolor sit amet consectetur. Quam sed ac sed a leo ornare. Nunc ut odio felis.",textAlign: TextAlign.center,),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10,left: 10),
                  child: Text("Where’s your business located?"),
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
                            value: drop,
                            items: [ //add items in the dropdown
                              DropdownMenuItem(
                                child: Text("Lagos State",style: TextStyle(
                                    fontSize: 17
                                ),),
                                value: "Lagos State",
                              ),
                              DropdownMenuItem(
                                  child: Text("Oyo State",style: TextStyle(
                                      fontSize: 17
                                  ),),
                                  value: "Oyo State"
                              ),
                              DropdownMenuItem(
                                child: Text("Ogun State",style: TextStyle(
                                    fontSize: 17
                                ),),
                                value: "Ogun State",
                              )

                            ],
                            onChanged: (value){ //get value when changed
                              setState(() {
                                drop = value!;
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
                  child: Text("Brief Description (100 words)"),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: TextField(
                    maxLines: 18,
                    controller: _description,
                    decoration: InputDecoration(
                      hintText: 'We are a company that specialize in....',
                        filled: true, //<-- SEE HERE
                        fillColor: Color.fromRGBO(229, 228, 226, 1),
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,color: Color.fromRGBO(229, 228, 226, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,color: Color.fromRGBO(229, 228, 226, 1),
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    introducebusiness();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
