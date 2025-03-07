import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:vendorandroid/screens/processproductpayment.dart';

class BuyProduct extends StatefulWidget {
  String topuplink = "";
  String refnumber = "";
  String idname = "";
  String useremail = "";
  String state = "";
  String amount = "";
  String fullname = "";
  String streetaddress = "";
  double service_fee = 0;
  String phone_number = "";
  String username = "";

  BuyProduct({Key? key,
    required this.username,
  required this.topuplink,
  required this.refnumber,
  required this.idname,
  required this.useremail,
  required this.state,
  required this.amount,
  required this.fullname,
  required this.streetaddress,
  required this.service_fee, required this.phone_number}) : super(key: key);

  @override
  _BuyProductState createState() => _BuyProductState();
}

class _BuyProductState extends State<BuyProduct> {

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
          return ProcessProductPayment(
            username: widget.username,
            idname: widget.idname,
            useremail: widget.useremail,
            state: widget.state,
            fullname: widget.fullname,
            streetaddress: widget.streetaddress,
            service_fee: widget.service_fee,
            phonenumber: widget.phone_number,
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
  initState(){
    super.initState();
    calltimer();
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading:Container(),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("Vendorhive360"),
            titleTextStyle: TextStyle(
              color: Colors.orange,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            actions: [
              IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.cancel))
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
      ),
    );
  }
}
