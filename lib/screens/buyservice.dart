import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendorandroid/screens/processservicepayment.dart';

class BuyService extends StatefulWidget {
  String topuplink = "";
  String refnumber = "";
  String idname = "";
  String sidname = "";
  String useremail = "";
  String adminemail = "";
  String servicename = "";
  String amount = "";
  String desc = "";
  BuyService({Key? key,
  required this.idname,
  required this.sidname,
  required this.useremail,
  required this.adminemail,
  required this.servicename,
  required this.desc,
  required this.amount,
  required this.topuplink,
  required this.refnumber}) : super(key: key);

  @override
  _BuyServiceState createState() => _BuyServiceState();
}

class _BuyServiceState extends State<BuyService> {

  int sec = 0;
  double _progress = 0;
  bool cancelTimer = false;
  late InAppWebViewController  inAppWebViewController;

  void calltimer() {
    Timer.periodic(Duration(seconds: 5), (timer) {

      sec++;

      if (mounted) {

        verifypaystack();
        print(sec);

      }

      if (cancelTimer) {

        timer.cancel();
        print(sec);

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ProcessServicePayment(
            idname: widget.idname,
            useremail: widget.useremail,
            amount: widget.amount.replaceAll(",", ""),
            adminemail: widget.adminemail,
            sidname: widget.sidname,
            servicename: widget.servicename,
            desc: widget.desc,
          );
        }));

      }
    });
  }

  Future verifypaystack() async {

    String url = "transaction/verify/"+widget.refnumber;

    var paystackverify = await http.get(
        Uri.https('api.paystack.co',url),
        headers: {
          'Authorization':'bearer sk_live_399d6462aa7d870cd384139c48709ea9e1ac54f4'
        }
    );

    if(paystackverify.statusCode == 200){

      print(jsonDecode(paystackverify.body));
      print(jsonDecode(paystackverify.body)['data']['status']);

      if(jsonDecode(paystackverify.body)['data']['status'] == 'success'){

        print('Paystack Transaction successful');

        print('crediting wallet is next');

        setState(() {
          cancelTimer = true;
        });

      }
      else if(jsonDecode(paystackverify.body)['data']['status'] == 'failed'){

        print('transaction failed');

        setState(() {
          cancelTimer = false;
        });

      }
      else if(jsonDecode(paystackverify.body)['data']['status'] == 'ongoing'){

        print('transaction proceeds from abandoned');

      }
      else if(jsonDecode(paystackverify.body)['data']['status'] == 'abandoned'){

        print('Awaiting customer to enter card details');

      }
      else{

        print(jsonDecode(paystackverify.body)['data']['status']);

      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calltimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                  padding: EdgeInsets.only(top: 10,left: 15),
                  child: FaIcon(FontAwesomeIcons.xmark,color: Colors.black,size: 30,))
          ),
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.only(top: 10,right: 15),
                    child: Text("Vendorhive",style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width/26
                    ),))
            ),
          ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.topuplink),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform:
                InAppWebViewOptions(useShouldOverrideUrlLoading: true),
              ),
              onReceivedServerTrustAuthRequest: (controller,challenge)
              async {
                return ServerTrustAuthResponse(action:
                ServerTrustAuthResponseAction.PROCEED);
              },
              onWebViewCreated: (InAppWebViewController controller){
                inAppWebViewController = controller;
                inAppWebViewController.clearCache();
                CookieManager.instance().deleteAllCookies();
                print('lilo');
              },
              onProgressChanged: (InAppWebViewController controller , int progress){
                setState(() {
                  _progress = progress / 100;
                });
              },
            ),
            _progress < 1 ? Container(
              child: LinearProgressIndicator(
                value: _progress,
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }
}
