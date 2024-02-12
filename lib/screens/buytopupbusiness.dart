import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendorandroid/screens/processtopupbusiness.dart';

class BuyTopupBusiness extends StatefulWidget {
  String topuplink = "";
  String refnumber = "";
  String idname = "";
  String email = "";
  String amount = "";
  String decription = "";
  BuyTopupBusiness({Key? key,
  required this.topuplink,
  required this.refnumber,
  required this.idname,
  required this.email,
  required this.amount,
  required this.decription}) : super(key: key);

  @override
  _BuyTopupBusinessState createState() => _BuyTopupBusinessState();
}

class _BuyTopupBusinessState extends State<BuyTopupBusiness> {

  double _progress = 0;
  late InAppWebViewController  inAppWebViewController;

  int sec =0;
  String trfid = "";
  bool cancelTimer = false;

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
          return ProcessTopupBusiness(
            idname: widget.idname,
            email: widget.email,
            amount: widget.amount,
            description: widget.decription,
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
          'Authorization':dotenv.env['PAYSTACK_SECRET_KEYS']!
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

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  initState(){
    super.initState();
    calltimer();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Colors.white,
            title: Text("Vendorhive360"),
            titleTextStyle: TextStyle(
              color: Colors.orange,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            centerTitle: true,
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
      ),
    );
  }
}
