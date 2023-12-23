import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorandroid/screens/deleteservice.dart';
import 'package:vendorandroid/screens/paidservices.dart';

import 'businesspaidservices.dart';

class MyService {
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
  String username = "";

  VendorService({required this.adminemail, required this.idname,required this.username});

  @override
  _VendorServiceState createState() => _VendorServiceState();
}

class _VendorServiceState extends State<VendorService> {
  int _selectedPages = 0;
  List rawservice = [];
  bool myservices = false;
  List getallresults = [];
  bool getlogo = false;

  Future getservice() async {
    print('get services');

    try {
      var gettingservice = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorviewbusinessservice.php'),
          body: {
            'adminemail': widget.adminemail
          }
      );

      if (gettingservice.statusCode == 200) {
        print(jsonDecode(gettingservice.body));
        rawservice = jsonDecode(gettingservice.body);
        setState(() {
          myservices = true;
        });
      }
    }
    catch (e) {
      setState(() {
        _selectedPages = 1;
      });
    }
  }

  Future getserviceretry() async {
    print('get services');

    setState(() {
      myservices = false;
    });

    try {
      var gettingservice = await http.post(
          Uri.https('adeoropelumi.com', 'vendor/vendorviewbusinessservice.php'),
          body: {
            'adminemail': widget.adminemail
          }
      );

      if (gettingservice.statusCode == 200) {
        print(jsonDecode(gettingservice.body));
        rawservice = jsonDecode(gettingservice.body);
        setState(() {
          myservices = true;
        });
      }
    }
    catch (e) {
      setState(() {
        _selectedPages = 1;
      });
    }
  }

  Future vendorgetdescriptionsummary() async{
    final gettinglogo = await http.post(Uri.https('adeoropelumi.com', 'vendor/vendorgetlogo.php'),
        body: {
          'useremail' : widget.adminemail
        });
    if(gettinglogo.statusCode == 200){
      setState(() {
        getallresults = jsonDecode(gettinglogo.body);
        getlogo = true;
      });
      print(jsonDecode(gettinglogo.body));
      print(getallresults[0]["logoname"]);
    }else{
      print("Error Getting Image");
      setState(() {
        getlogo = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getservice();
    vendorgetdescriptionsummary();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header and back button
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
                        child: Text("My Service", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.arrow_back,
                                color: Colors.white,)
                          ),
                        ),
                      )
                    ],
                  )
              ),

              //picture + business name + call + menu button
              Container(
                  margin:EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.lime[100],
                        radius: 20,
                        child: getlogo ?
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: FadeInImage(
                            image: NetworkImage(
                              "https://www.adeoropelumi.com/vendor/blogo/"+getallresults[0]["logoname"],
                            ),
                            placeholder: AssetImage(
                                "assets/image.png"),
                            imageErrorBuilder:
                                (context, error,
                                stackTrace) {
                              return Image.asset(
                                  'assets/error.png',
                                  fit: BoxFit
                                      .fitWidth);
                            },
                            fit: BoxFit.fitWidth,
                          ),
                        ):
                        CircularProgressIndicator(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.username,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),),
                                Text(getlogo? widget.username+" shop in "+getallresults[0]["state"]:"loading...",
                                  style: TextStyle(
                                    fontSize: 9,
                                  ),)
                              ],
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.lime[100],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Icon(Icons.phone,size: 15,color: Colors.black,),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.lime[100],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Icon(Icons.more_horiz,size: 15,color: Colors.black,),
                      )
                    ],
                  )
              ),

              //Brief Explanation
              Container(
                margin:EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Text(getlogo?getallresults[0]["description"]:"loading...",
                  style: TextStyle(
                      fontSize: 9
                  ),maxLines: 6,overflow: TextOverflow.ellipsis,),
              ),

              const SizedBox(
                height: 10,
              ),

              //send message button
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return BusinessPaidServices(useremail: widget.adminemail, idname: widget.idname);
                  }));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 123, 55, 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text("View Paid Service",style: TextStyle(
                        color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // My Services text
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("My Services",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
              ),

              Flexible(
                  child:
                  _selectedPages == 0 ?
                  myservices ?
                  rawservice.length > 0 ?
                  RefreshIndicator(
                    onRefresh: getservice,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .7
                        ),
                        padding: EdgeInsets.zero,
                        itemCount: rawservice.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return DeleteService(
                                        payment_option: rawservice[index]['paymentoption'],
                                        servicename: rawservice[index]['name'],
                                        serviceoldPrice: rawservice[index]['price'],
                                        serviceolddescription: rawservice[index]['desription'],
                                        email: widget.adminemail,
                                        sidname: rawservice[index]['sidname'],
                                        serviceimg: rawservice[index]['serviceimg']);
                                  }));
                            },
                            child: Container(
                              // padding: EdgeInsets.only(
                              //     top: 10, bottom: 10, left: 10),
                              margin: EdgeInsets.only(
                                  left: 10, top: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(229, 228, 226, 1),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Column(
                                children: [
                                  AspectRatio(
                                      aspectRatio: 1,
                                      child: FadeInImage(
                                        image: NetworkImage(
                                          "https://adeoropelumi.com/vendor/serviceimage/" +
                                              rawservice[index]['serviceimg'],
                                        ),
                                        placeholder: AssetImage(
                                            "assets/image.png"),
                                        imageErrorBuilder:
                                            (context, error,
                                            stackTrace) {
                                          return Image.asset(
                                              'assets/error.png',
                                              fit: BoxFit
                                                  .fitWidth);
                                        },
                                        fit:
                                        BoxFit.fitWidth,
                                      )
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              rawservice[index]['name'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 24
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text("₦" +
                                              rawservice[index]['price']
                                                  .replaceAllMapped(RegExp(
                                                  r'(\d{1,3})(?=(\d{3})+(?!\d))'), (
                                                  Match m) => '${m[1]},'),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 26
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 3,),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Text("you haven't registerd any services",
                              style: TextStyle(
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 30,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold
                              ), textAlign: TextAlign.center,),
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
                            child: Text("loading...", style: TextStyle(
                                fontSize: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 30,
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
                            onTap: () {
                              getserviceretry();
                            },
                            child: Container(
                              child: Image.asset("assets/internet.png",
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3,),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getserviceretry();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                "Click icon to retry", style: TextStyle(
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 30,
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
