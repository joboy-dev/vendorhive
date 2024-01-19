import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewPromotedService extends StatefulWidget {
  String idname = "";
  String email = "";
  ViewPromotedService({Key? key,
  required this.idname,
  required this.email}) : super(key: key);

  @override
  _ViewPromotedServiceState createState() => _ViewPromotedServiceState();
}

class _ViewPromotedServiceState extends State<ViewPromotedService> {

  bool myproducts = false;
  int _selectedpages = 0;
  List raw = [];

  Future promotedservice() async {

    print('printing promoted service');

    try{
      var listofpromotedservices = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorpromotedservices.php'),
          body: {
            'email': widget.email
          }
      );

      if(listofpromotedservices.statusCode == 200){

        print(jsonDecode(listofpromotedservices.body));

        raw = jsonDecode(listofpromotedservices.body);

        setState(() {

          myproducts = true;

        });

      }
      else{

        print("promoted services issues ${listofpromotedservices.statusCode}");

      }

    }
    catch(e){

      setState(() {
        _selectedpages = 1;
      });

    }

  }

  Future promotedserviceretry() async {

    setState(() {

      _selectedpages = 0;
      myproducts = false;

    });

    print('printing promoted service');

    try{
      var listofpromotedservices = await http.post(
          Uri.https('vendorhive360.com','vendor/vendorpromotedservices.php'),
          body: {
            'email': widget.email
          }
      );

      if(listofpromotedservices.statusCode == 200){

        print(jsonDecode(listofpromotedservices.body));

        raw = jsonDecode(listofpromotedservices.body);

        setState(() {

          myproducts = true;

        });

      }
      else{

        print("promoted services issues ${listofpromotedservices.statusCode}");

      }

    }
    catch(e){

      setState(() {
        _selectedpages = 1;
      });

    }

  }

  @override
  initState(){
    super.initState();

    promotedservice();

  }

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
                          child: Text("Promoted Service",style: TextStyle(
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
                                child: Icon(Icons.arrow_back,color: Colors.black,),
                              )
                          ),
                        )
                      ],
                    ),
                  ),

                  Flexible(
                      child:
                      _selectedpages == 0 ?
                      myproducts ?
                      raw.length > 0 ?
                      RefreshIndicator(
                        onRefresh: promotedservice,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: raw.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){

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
                                          image: NetworkImage("https://vendorhive360.com/vendor/serviceimage/"+raw[index]['serviceimg']),
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
                                        // child: Image.network("https://vendorhive360.com/vendor/productimage/"+rawproducts[index]['productimg']),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:EdgeInsets.only(left: 10,right: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                child: Text(raw[index]['name'],
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/24,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                child: Text("₦"+raw[index]['price'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width/26,
                                                  ),
                                                ),
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
                                child: Text("no promoted service",style: TextStyle(
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
                                  promotedserviceretry();
                                },
                                child: Container(
                                  child: Image.asset("assets/internet.png",
                                    width: MediaQuery.of(context).size.width/3,),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  promotedserviceretry();
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
      ),
    );
  }
}
