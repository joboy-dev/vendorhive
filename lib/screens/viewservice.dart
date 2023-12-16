import 'dart:convert';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vendorandroid/screens/ratings.dart';
import 'package:vendorandroid/screens/servicemsg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ViewService extends StatefulWidget {

  String idname = "";
  String useremail = "";
  String packagename = "";
  String usertype = "";
  String name = "";
  String amount = "";
  String imagename = "";
  String description = "";
  String serviceid = "";
  String adminemail = "";
  String username = "";

  ViewService({required this.username, required this.name, required this.amount, required this.imagename,
  required this.description, required this.idname, required this.useremail,
  required this.usertype, required this.packagename, required this.serviceid,
  required this.adminemail});

  @override
  _ViewServiceState createState() => _ViewServiceState();
}

class _ViewServiceState extends State<ViewService> {
  String imagename = "";
  String logo = "";
  String admin_username = "";
  bool setlogo = false;
  bool showlist = false;
  bool showrating = false;
  double finalratings = 0.0;
  List<String> servicesimg = [];
  List rawservice = [];

  Future serviceimages() async{

    setState(() {
      showlist = false;
    });

    var service = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorservicelistimage.php'),
        body: {
          'sidname':widget.serviceid
        }
    );

    if(service.statusCode == 200){

      print(jsonDecode(service.body));

      rawservice = jsonDecode(service.body);

      for(int o=0; o<rawservice.length; o++){

        setState(() {
          servicesimg.add(jsonDecode(service.body)[o]['serviceimage']);
        });

      }

    }
    else{

      print("Service image issues ${service.statusCode}");

    }

    setState(() {
      showlist = true;
    });

  }

  Future loadratings() async{

    setState(() {
      showrating = false;
    });

    var viewrattings = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorviewrattings.php'),
        body: {
          'pidname':widget.serviceid
        }
    );

    if(viewrattings.statusCode == 200){
      print(jsonDecode(viewrattings.body));

      if(jsonDecode(viewrattings.body)==0){

        setState(() {
          finalratings = 0;
        });

      }
      else{

        setState(() {
          finalratings = double.parse(jsonDecode(viewrattings.body));
        });

      }

      print(jsonDecode(viewrattings.body));
      print(finalratings);

      setState(() {
        showrating = true;
      });

    }
    else{

      print("view ratting issues ${viewrattings.statusCode}");

    }
  }

  Future gettingLogo() async{

    setState(() {
      setlogo = false;
    });

    var getonlyLogo = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorgetonlylogo.php'),
        body: {
          'useremail': widget.adminemail,
        });

    var admingetusername = await http.post(
        Uri.https('adeoropelumi.com', 'vendor/vendorgetamdinusernamecust.php'),
        body: {
          'adminemail': widget.adminemail,
        });

    if(getonlyLogo.statusCode == 200 && admingetusername.statusCode == 200){

      setState(() {
        logo = jsonDecode(getonlyLogo.body);
        admin_username = jsonDecode(admingetusername.body);
        setlogo = true;
      });

    }
    else{

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceimages();
    loadratings();
    gettingLogo();
    print("Login Id "+widget.idname);
    print("Admin email "+widget.adminemail);
    print("User Email "+widget.useremail);
    print("Image name "+widget.imagename);
    imagename = widget.imagename;
    print("Amount "+widget.amount);
    print("Service Id "+widget.serviceid);
    print("Serivce name "+widget.name);
    print("Customer package name "+widget.packagename);
    print("User type "+widget.usertype);
    print("Description "+widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.only(left: 20,right: 20,top: 20),
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height/2)-70,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                        width: MediaQuery.of(context).size.width/1.4,
                        child: FadeInImage(
                          image: NetworkImage("https://adeoropelumi.com/vendor/serviceimage/"+widget.imagename),
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
                        // child: Image.network("https://adeoropelumi.com/vendor/serviceimage/"+widget.imagename,)
                    ),
                    for(int o=0; o < rawservice.length; o++)
                      if(widget.imagename == servicesimg[o] )...[

                      ]else...[
                        Container(
                            width: MediaQuery.of(context).size.width/1.4,
                          child: FadeInImage(
                            image: NetworkImage("https://adeoropelumi.com/vendor/serviceimage/"+servicesimg[o]),
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
                            // child: Image.network("https://adeoropelumi.com/vendor/serviceimage/"+servicesimg[o],)
                        ),
                      ]
                  ],
                ),
              ),
            ),
            Container(
              child: Center(
                child: showlist?
                Text("swipe left",style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic
                ),)
                    :
                Icon(Icons.more_horiz),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(widget.name,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/16,
                                    fontWeight: FontWeight.w500
                                ),),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text("₦"+widget.amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.width/18,
                                ),),
                            )
                          ],
                        ),
                      ),
                    ),

                    showrating ?
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child: RatingBarIndicator(
                            rating: finalratings,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ),
                    )
                        :
                    Container(
                      child: Icon(Icons.more_horiz),
                    )
                  ],
                )
            ),

            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 30),
              child: Text(widget.description,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/26
                ),),
            ),
            
            GestureDetector(
              onTap: (){
                setlogo ?
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ServiceMsg(
                    logo: logo,
                    username: admin_username,
                    useremail: widget.useremail,
                    adminemail: widget.adminemail,
                  idname: widget.idname,
                  serviceid: widget.serviceid,
                  usertype: widget.usertype,
                  servicename: widget.name,);
                }))
                :ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Try again, Chat is loading"))
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 123, 55, 1),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Center(
                  child: Text("Message vendor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width/22
                  ),),
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(14, 44, 3, 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      padding: EdgeInsets.only(top: 13,bottom: 13),
                      child: Center(
                          child: Text("Go Back",style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width/22
                          ),)
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(showrating){

                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Ratings(pidname: widget.serviceid,finalratings: finalratings,);
                        }));

                      }else{

                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(246,234,190, 1),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      padding: EdgeInsets.only(top: 13,bottom: 13),
                      child: Center(
                          child: showrating ?
                          Text("Ratings and Reviews",style: TextStyle(
                              color: Colors.black54,
                              fontSize: MediaQuery.of(context).size.width/24
                          ),)
                              :
                          Icon(Icons.more_horiz,
                            size: MediaQuery.of(context).size.width/15,)
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
