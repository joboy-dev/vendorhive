import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vendorandroid/screens/processservicepromotionpayment.dart';

class BuyServicePromotion extends StatefulWidget {
  String topuplink = "";
  String refnumber = "";
  String adminemail = "";
  String amount = "";
  String days = "";
  String sidname = "";
  String servicename = "";
  BuyServicePromotion({Key? key,
  required this.topuplink,
  required this.refnumber,
  required this.amount,
  required this.days,
  required this.adminemail,
  required this.sidname,
  required this.servicename}) : super(key: key);

  @override
  _BuyServicePromotionState createState() => _BuyServicePromotionState();
}

class _BuyServicePromotionState extends State<BuyServicePromotion> {

  double _progress = 0;
  bool cancelTimer = false;
  int sec = 0;
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
          return ProcessServicePromotionPayment(
            adminemail: widget.adminemail,
            days: widget.days,
            amount: widget.amount,
            servicename: widget.servicename,
            sidname: widget.sidname,
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

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed"))
        );

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
          // actions: [
          //   GestureDetector(
          //       onTap: (){
          //         Navigator.of(context).pop();
          //       },
          //       child: Container(
          //           padding: EdgeInsets.only(top: 10,right: 15),
          //           child: FaIcon(FontAwesomeIcons.xmark,color: Colors.black,size: 30,))
          //   ),
          // ],
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
