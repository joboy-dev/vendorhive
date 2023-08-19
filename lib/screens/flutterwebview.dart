import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackPayment extends StatefulWidget {
  const PaystackPayment({Key? key}) : super(key: key);

  @override
  _PaystackPaymentState createState() => _PaystackPaymentState();
}

class _PaystackPaymentState extends State<PaystackPayment> {

  late WebViewController webViewController;
  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: SafeArea(
            child: Container(
              child: Stack(
                children: [
                  WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      onProgress: (value){
                        if(value == 100){
                          setState((){
                            isloading = false;
                          });
                        }
                      },
                      initialUrl :'https://checkout.paystack.com/ich2v8633n403q5'
                  ),
                  isloading ? Center( child: CircularProgressIndicator()) : Container()
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
