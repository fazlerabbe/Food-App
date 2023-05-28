import 'dart:convert';

import 'package:admin_app/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nav_bar/nav_bar_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      progressIndicator: spinkit,
      blur: 0.5,
      opacity: 0.2,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login page',
                style: myStyle(25, Colors.teal),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Enter your Email'),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  getLogin();
                },
                child: Text(
                  'Submit',
                  style: myStyle(25, Colors.tealAccent, FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  isLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    if (token != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BottomNavBarPage(),
      ));
    }
  }

  getLogin() async {
    try {
      setState(() {
        isLoading = true;
      });
      String url = "${baseUrl}sign-in";
      var map = Map<String, dynamic>();
      map["email"] = emailController.text.toString();
      map["password"] = passwordController.text.toString();
      var responce = await http.post(Uri.parse(url), body: map);
      var data = jsonDecode(responce.body);
      setState(() {
        isLoading = false;
      });
      print('responce data is $data');
      print('statas code is ${responce.statusCode}');

      if (responce.statusCode == 200) {
        showInToast("login success");
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("token", data["access_token"]);
        print("save token is ${sharedPreferences.getString("token")}");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BottomNavBarPage(),
        ));
      } else {
        showInToast("email or password does not match");
      }
    } catch (e) {
      print('Something is wrong $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    isLogin();
    super.initState();
  }
}
