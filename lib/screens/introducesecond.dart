import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  String appstatus = "Vendorhive360";
  String drop = "Lagos";
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

  String replacingword(String word) {
    word = word.replaceAll("'", "");
    word = word.replaceAll(r'\', r'\\');
    return word;
  }

  void introducebusiness() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Businesslogo(
        id: widget.id,
        useremail: widget.useremail,
        description: replacingword(_description.text),
        state: drop,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _selectedpage == 0
            ? GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: SafeArea(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text(
                              "Introduce your Business",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Text(
                            "Lorem ipsum dolor sit amet consectetur. Quam sed ac sed a leo ornare. Nunc ut odio felis.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Where’s your business located?"),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                //background color of dropdown button
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                //border of dropdown button
                                borderRadius: BorderRadius.circular(
                                    10), //border raiuds of dropdown button
                                // boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                                //   BoxShadow(
                                //       // color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                //       // blurRadius: 5
                                //   ) //blur radius of shadow
                                // ]
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: DropdownButton(
                                    value: drop,
                                    items: [
                                      //add items in the dropdown
                                      DropdownMenuItem(
                                        child: Text(
                                          "Abia",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Abia",
                                      ),
                                      //2nd state Adamawa
                                      DropdownMenuItem(
                                        child: Text(
                                          "Adamawa",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Adamawa",
                                      ),
                                      //3rd state Akwa Ibom
                                      DropdownMenuItem(
                                        child: Text(
                                          "Akwa Ibom",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Akwa Ibom",
                                      ),
                                      //4th state Anambra
                                      DropdownMenuItem(
                                        child: Text(
                                          "Anambra",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Anambra",
                                      ),
                                      //5th state Bauchi
                                      DropdownMenuItem(
                                        child: Text(
                                          "Bauchi",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Bauchi",
                                      ),
                                      //6th state Bayelsa
                                      DropdownMenuItem(
                                        child: Text(
                                          "Bayelsa",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Bayelsa",
                                      ),
                                      //7th state Benue
                                      DropdownMenuItem(
                                        child: Text(
                                          "Benue",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Benue",
                                      ),
                                      //8th state Borno
                                      DropdownMenuItem(
                                        child: Text(
                                          "Borno",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Borno",
                                      ),
                                      //9th state Cross River
                                      DropdownMenuItem(
                                        child: Text(
                                          "Cross River",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Cross River",
                                      ),
                                      //10th state Delta
                                      DropdownMenuItem(
                                        child: Text(
                                          "Delta",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Delta",
                                      ),
                                      //11th state Ebonyi
                                      DropdownMenuItem(
                                        child: Text(
                                          "Ebonyi",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Ebonyi",
                                      ),
                                      //12th state Edo
                                      DropdownMenuItem(
                                        child: Text(
                                          "Edo",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Edo",
                                      ),
                                      //13th state Ekiti
                                      DropdownMenuItem(
                                        child: Text(
                                          "Ekiti",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Ekiti",
                                      ),
                                      //14th state Enugu
                                      DropdownMenuItem(
                                        child: Text(
                                          "Enugu",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Enugu",
                                      ),
                                      //15th state Gombe
                                      DropdownMenuItem(
                                        child: Text(
                                          "Gombe",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Gombe",
                                      ),
                                      //16th state Imo
                                      DropdownMenuItem(
                                        child: Text(
                                          "Imo",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Imo",
                                      ),
                                      //17th state Jigawa
                                      DropdownMenuItem(
                                        child: Text(
                                          "Jigawa",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Jigawa",
                                      ),
                                      //18th state Kaduna
                                      DropdownMenuItem(
                                        child: Text(
                                          "Kaduna",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Kaduna",
                                      ),
                                      //19th state Kano
                                      DropdownMenuItem(
                                        child: Text(
                                          "Kano",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Kano",
                                      ),
                                      //20th state Katsina
                                      DropdownMenuItem(
                                        child: Text(
                                          "Katsina",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Katsina",
                                      ),
                                      //21th state Kebbi
                                      DropdownMenuItem(
                                        child: Text(
                                          "Kebbi",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Kebbi",
                                      ),
                                      //22th state kogi
                                      DropdownMenuItem(
                                        child: Text(
                                          "Kogi",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Kogi",
                                      ),
                                      //23th state Kwara
                                      DropdownMenuItem(
                                        child: Text(
                                          "Kwara",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Kwara",
                                      ),
                                      //24th state Lagos
                                      DropdownMenuItem(
                                        child: Text(
                                          "Lagos",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Lagos",
                                      ),
                                      //25th state Nasarawa
                                      DropdownMenuItem(
                                        child: Text(
                                          "Nasarawa",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Nasarawa",
                                      ),
                                      //26th state Niger
                                      DropdownMenuItem(
                                        child: Text(
                                          "Niger",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Niger",
                                      ),
                                      //27th  state Ogun
                                      DropdownMenuItem(
                                        child: Text(
                                          "Ogun",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Ogun",
                                      ),
                                      //28th state Ondo
                                      DropdownMenuItem(
                                        child: Text(
                                          "Ondo",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Ondo",
                                      ),
                                      //29th state Osun
                                      DropdownMenuItem(
                                        child: Text(
                                          "Osun",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Osun",
                                      ),
                                      //30th state Oyo
                                      DropdownMenuItem(
                                        child: Text(
                                          "Oyo",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Oyo",
                                      ),
                                      //31st state Plateau
                                      DropdownMenuItem(
                                        child: Text(
                                          "Plateau",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Plateau",
                                      ),
                                      //32nd state Rivers
                                      DropdownMenuItem(
                                        child: Text(
                                          "Rivers",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Rivers",
                                      ),
                                      //33rd state Sokoto
                                      DropdownMenuItem(
                                        child: Text(
                                          "Sokoto",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Sokoto",
                                      ),
                                      //34th state Taraba
                                      DropdownMenuItem(
                                        child: Text(
                                          "Taraba",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Taraba",
                                      ),
                                      //35th state Yobe
                                      DropdownMenuItem(
                                        child: Text(
                                          "Yobe",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        value: "Yobe",
                                      ),
                                      //36th state Zamfara
                                      DropdownMenuItem(
                                          child: Text(
                                            "Zamfara",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          value: "Zamfara"),
                                    ],
                                    onChanged: (value) {
                                      //get value when changed
                                      setState(() {
                                        drop = value!;
                                      });
                                      print("You have selected $value");
                                    },
                                    icon: Padding(
                                        //Icon at tail, arrow bottom is default icon
                                        padding: EdgeInsets.only(left: 20),
                                        child: Icon(Icons.arrow_drop_down)),
                                    iconEnabledColor: Colors.white,
                                    //Icon color
                                    style: TextStyle(
                                        //te
                                        color: Colors.white, //Font color
                                        fontSize:
                                            20 //font size on dropdown button
                                        ),

                                    dropdownColor: Colors.grey,
                                    //dropdown background color
                                    underline: Container(),
                                    //remove underline
                                    isExpanded:
                                        true, //make true to make width 100%
                                  ))),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Brief Description (100 words)"),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: TextField(
                            maxLines: 18,
                            controller: _description,
                            decoration: InputDecoration(
                              hintText:
                                  'We are a company that specialize in....',
                              filled: true,
                              //<-- SEE HERE
                              fillColor: Color.fromRGBO(229, 228, 226, 1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(229, 228, 226, 1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(229, 228, 226, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            introducebusiness();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(246, 123, 55, 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "Next",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Center(
                            child: Text(
                              appstatus,
                              style: TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
