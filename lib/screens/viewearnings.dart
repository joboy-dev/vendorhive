import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewEarnings extends StatefulWidget {
  String email = "";
  String idname = "";
  ViewEarnings({Key? key,
  required this.idname,
  required this.email}) : super(key: key);

  @override
  _ViewEarningsState createState() => _ViewEarningsState();
}

class _ViewEarningsState extends State<ViewEarnings> {

  String number = '...';
  String amtearnings = "...";
  String claimedearning = "...";
  bool claiming = false;
  String trfid = "";
  List raw = [];
  List rawearn = [];
  bool getearnings  = true;

  void currentdate(){
    DateTime now = new DateTime.now();
    print(now.toString());
    timestamp(now.toString());
    trfid = timestamp(now.toString());
    print(trfid);
  }

  String timestamp(String str){
    str = str.replaceAll(":", "");
    str = str.replaceAll("-", "");
    str = str.replaceAll(".", "");
    str = str.replaceAll(" ", "");
    return str;
  }

  Future earnings()async{

    var earn = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorviewearnings.php'),
        body: {
          'idname':widget.idname
        }
    );

    var claimedearnings = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorviewclaimedearnings.php'),
        body: {
          'idname' : widget.idname
        }
    );

    if(earn.statusCode == 200){

      print(jsonDecode(earn.body));

      raw = jsonDecode(earn.body);

      rawearn = jsonDecode(claimedearnings.body);

      print(raw.length);
      print(rawearn.length);

      setState(() {

        number = raw.length.toString();
        double amttt= raw.length * 100;
        double clamtt = rawearn.length * 100;
        amtearnings = amttt.toString();
        claimedearning = clamtt.toString();
        claiming = true;

      });

    }
    else{
      print("Earn issues ${earn.statusCode}");
    }

  }

  Future depositearning()async{

    currentdate();

    setState(() {
      claiming = false;
      getearnings = false;
    });

    print('depositing earnings');

    var updatethearnings = await http.post(
        Uri.https('adeoropelumi.com','vendor/vendorclaim.php'),
        body: {
          'code':widget.idname
        }
    );

    if(updatethearnings.statusCode == 200){
      if(jsonDecode(updatethearnings.body) == 'true'){

        print('earnings are updated');
        String itemid = "er-"+trfid;

        if(double.parse(amtearnings) > 0){

          var savetransaction = await http.post(
              Uri.https('adeoropelumi.com','vendor/vendorsaveinbusinesswallet.php'),
              body: {
                'idname': widget.idname,
                'useremail': widget.email,
                'adminemail': widget.email,
                'debit':'0',
                'credit': amtearnings,
                'status': 'completed',
                'refno' : trfid,
                'description': 'top up',
                'itemid': itemid
              }
          );

          if(jsonDecode(savetransaction.body) == 'true'){

            print('Earnings are deposited');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Earning were deposited'))
            );

            setState(() {
              claiming = true;
              amtearnings = "0.0";
              getearnings = true;
            });

          }
          else{

            print('Earnings failed to deposited');

            setState(() {
              claiming = true;
              getearnings = true;
            });

          }
        }
        else{

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Oops, There is nothing to claim'))
          );

          setState(() {
            claiming = true;
            getearnings = true;
          });

        }
      }
      else{

        print('Earnings were not updated');

        setState(() {
          claiming = true;
          getearnings = true;
        });

      }
    }

  }

  @override
  initState(){
    super.initState();
    earnings();
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
                          child: Text("Active Referals",style: TextStyle(
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

                  Flexible(child:
                  ListView(
                    padding: EdgeInsets.only(top: 10),
                    children: [

                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                child: Text('Number of Active referals:- ',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width/24
                                ),),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(

                              ),
                              width: MediaQuery.of(context).size.width/3,
                              child: Text(number,style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/24,
                              ),),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                child: Text('Product upload rewards:- ',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width/24,
                                ),),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/3,
                              child: Text(number,style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/24,
                              ),),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                child: Text('Service upload rewards:- ',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width/24,
                                ),),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/3,
                              child: Text(number,style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/24,
                              ),),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.orange)
                        ),
                        child: claiming ?
                        Center(
                          child: Text('Free Product and Service Upload',style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                        )
                            :
                        Center(
                          child: Text('loading...',style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
                        height: MediaQuery.of(context).size.height/4,
                        child: getearnings ? Image.asset("assets/naira-earnings.png")
                        :
                        Image.asset("assets/loading.png"),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(getearnings ? 'Vendorhive360' : 'loading...',style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      )

                  ],))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
