import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyService{
  String servicename = "";
  String siname = "";
  String serviceprice = "";
  String serviceimg = "";
  MyService({required this.servicename,
    required this.siname,
    required this.serviceprice,
    required this.serviceimg});
}

class VendorService extends StatefulWidget {
  String adminemail = "";
  String idname = "";
  VendorService({required this.adminemail,required this.idname});

  @override
  _VendorServiceState createState() => _VendorServiceState();
}

class _VendorServiceState extends State<VendorService> {
  int _selectedPages = 0;
  List rawservice = [];
  bool myservices = false;

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

    }
    catch(e){

      setState(() {
        _selectedPages = 1;
      });

    }
  }

  Future getserviceretry() async{

    print('get services');

    setState(() {

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
    }
    catch(e){

      setState(() {

        _selectedPages = 1;

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
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
                        child: Text("My Service",style: TextStyle(
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
                  )
              ),

              Flexible(
                  child:
              _selectedPages == 0 ?
              myservices ?
              rawservice.length > 0 ?
              RefreshIndicator(
                onRefresh: getservice,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rawservice.length,
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                        margin:EdgeInsets.only(left: 10,top: 10,right: 10),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(229, 228, 226, 1)
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              child: Image.network("https://adeoropelumi.com/vendor/serviceimage/"+rawservice[index]['serviceimg']),
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
                                          fontWeight: FontWeight.w500,
                                          fontSize: MediaQuery.of(context).size.width/24
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Text("Starting Price: ₦"+rawservice[index]['price'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width/26
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
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
                        child: Text("you haven't registerd any services",style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/30,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.center,),
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
                        child: Text("loading...",style: TextStyle(
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
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}
