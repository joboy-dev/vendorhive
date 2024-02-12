import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendorandroid/screens/create.dart';
import 'package:vendorandroid/screens/dashboard.dart';
import 'package:vendorandroid/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorandroid/screens/welcome.dart';

int? assign;
String? idname;
String? username;
String? useremail;
String? packagename;
String? usertype;
int? pagenumber;
String? finalbalance;
String? pendingbalance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await getvalue();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

Future<void> getvalue() async{

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  assign = prefs.getInt('counter');

  idname = prefs.getString('idname');
  username = prefs.getString('username');
  useremail = prefs.getString('useremail');
  packagename = prefs.getString('packagename');
  usertype = prefs.getString('usertype');
  pagenumber = prefs.getInt('pagenumber');
  finalbalance = prefs.getString('finalbalance');
  pendingbalance = prefs.getString('pendingbalance');

  print(assign);
  print(idname);
  print(useremail);
  print(packagename);
  print(usertype);
  print(pagenumber);
  print(finalbalance);
  print(pendingbalance);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          backgroundColor: Colors.white
        )
      ),
      debugShowCheckedModeBanner: false,
      title: 'Vendorhive 360',
      home: assign == null ?
      Login()
          :
      assign != null && assign == 1 ?
      Dashboard(idname: idname??'',
        username: username??'',
        useremail: useremail??'',
        packagename: packagename??'',
        usertype: usertype??'',
        finalbalance: finalbalance??'',
        pendingbalance: pendingbalance??'',)
          :
      assign != null && assign == 2 ?
      Welcome(idname: idname??'',
          username: username??'',
          useremail: useremail??'',
          packagename: packagename??'',
          usertype: usertype??'',
          pagenumber: pagenumber??0,
      custwalletbalance: finalbalance??'',)
          :
      Create(),
    );
  }
}

