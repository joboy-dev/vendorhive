import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vendorandroid/screens/setservicepromotion.dart';

class ServicePromotion extends StatefulWidget {
  String idname = "";
  String adminemail = "";
  ServicePromotion({required this.idname,
    required this.adminemail});

  @override
  _ServicePromotionState createState() => _ServicePromotionState();
}

class _ServicePromotionState extends State<ServicePromotion> {
  bool myservices = false;
  int _selectedPage = 0;
  List rawservice = [];

  Future getservice() async{

    print('get services');

    try{

      var gettingservice = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorviewbusinessservice.php'),
          body: {
            'adminemail': widget.adminemail
          }
      );

      if(gettingservice.statusCode == 200){

        print(jsonDecode(gettingservice.body));

        rawservice = jsonDecode(gettingservice.body);

        setState(() {

          myservices = true;

        });

      }
      else{

        print('Network Issues ${gettingservice.statusCode}');

      }
    }
    catch(e){

      print("error is "+e.toString());

      setState(() {
        _selectedPage = 1;
      });

    }

  }

  Future getserviceretry() async{

    print('get services');

    setState(() {

      _selectedPage = 0;
      myservices = false;

    });

    try{

      var gettingservice = await http.post(
          Uri.https('adeoropelumi.com','vendor/vendorviewbusinessservice.php'),
          body: {
            'adminemail': widget.adminemail
          }
      );

      if(gettingservice.statusCode == 200){

        print(jsonDecode(gettingservice.body));

        rawservice = jsonDecode(gettingservice.body);

        setState(() {

          myservices = true;

        });

      }
      else{

        print('Network Issues ${gettingservice.statusCode}');

      }

    }
    catch(e){

      setState(() {
        _selectedPage = 1;
      });

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getservice();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: SafeArea(
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
                        child: Text("Service",style: TextStyle(
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
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.arrow_back,color: Colors.white,)
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Center(child: Text('Select a service to promote',
                    textAlign: TextAlign.center,)),
                ),

                Flexible(
                    child:
                  _selectedPage == 0 ?
                  myservices ?
                  rawservice.length > 0 ?
                  RefreshIndicator(
                    onRefresh: getservice,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: rawservice.length,
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              print(index);
                              print(rawservice[index]['sidname']);
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return SetServicePromotion(sidname: rawservice[index]['sidname'],
                                  servicename: rawservice[index]['name'],
                                  serviceimg: rawservice[index]['serviceimg'],
                                idname: widget.idname,
                                adminemail: widget.adminemail,);
                              }));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                              margin:EdgeInsets.only(left: 10,top: 10,right: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(229, 228, 226, 1)
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width/8,
                                    child: FadeInImage(
                                      image: NetworkImage("https://adeoropelumi.com/vendor/serviceimage/"+rawservice[index]['serviceimg']),
                                      placeholder: AssetImage(
                                          "assets/image.png"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/error.png',
                                            fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
                                    ),
                                    // child: Image.network("https://adeoropelumi.com/vendor/productimage/"+rawproducts[index]['productimg']),
                                  ),

                                  Expanded(
                                    child: Container(
                                      margin:EdgeInsets.only(left: 10,right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: Text(rawservice[index]['name'],
                                              textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width/24,
                                                fontWeight: FontWeight.w500
                                            ),),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            child: Text("₦"+rawservice[index]['price'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                              textAlign: TextAlign.end,style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width/27,
                                              ),),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                      :
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset("assets/empty.png",
                            width: MediaQuery.of(context).size.width/3,),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Text("no services",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/30,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  )
                      :
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          Spacer(),
                          CircularProgressIndicator(
                            color: Colors.orange,
                            backgroundColor: Colors.green,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("loading.....",style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/30,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  )
                      :
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              getserviceretry();
                            },
                            child: Container(
                              child: Image.asset("assets/internet.png",
                                width: MediaQuery.of(context).size.width/3,),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              getserviceretry();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text("Click icon to retry",style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width/30,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
