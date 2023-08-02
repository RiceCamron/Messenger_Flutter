import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/user.dart';
import 'package:network/Screens/LoginScreen.dart';
import 'package:network/pages/registration_page.dart';
import 'package:network/pages/login_page.dart';
import 'package:network/Module/http.dart';
import 'package:network/Screens/HomeScreen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/pages/registration_page.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  bool isChecked = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String response = '';

  late Box box1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    // getdata();
  }

  // void getdata() async {
  //   if (box1.get('username') != null) {
  //     usernameController.text = box1.get('username');
  //     isChecked = true;
  //     setState(() {});
  //   }
  //   if (box1.get('pass') != null) {
  //     passwordController.text = box1.get('pass');
  //     isChecked = true;
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(19, 30, 52, 1),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "Login".text.color(Colors.white).size(20).make(),
                    const HeightBox(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          isDense: true,
                          // Added this
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        ),
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const HeightBox(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue)),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        ),
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    HeightBox(10),
                    GestureDetector(
                        onTap: () {
                          print("Login Clicked Event");
                          login();
                        },
                        child: "Login"
                            .text
                            .white
                            .light
                            .xl
                            .makeCentered()
                            .box
                            .white
                            .shadowOutline(outlineColor: Colors.grey)
                            .color(Colors.black87)
                            .roundedLg
                            .make()
                            .w(150)
                            .h(40)),
                    HeightBox(12),
                    Text(
                      response,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Registration_Page()));
          },
          child: RichText(
              text: const TextSpan(
            text: 'Have an account?',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: ' Register Now',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color.fromARGB(255, 144, 202, 249)),
              ),
            ],
          )).pLTRB(20, 0, 0, 15),
        ));
  }

  void login() async {
    List<User> users = [];
    var result = await http_post("login", {
      "username": usernameController.text,
      "password": passwordController.text,
    });
    if (result.ok) {
      setState(() {
        users.clear();

        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          users.add(
            User(
              in_user['id'].toString(),
              in_user['username'],
              in_user['phone'],
              in_user['email'],
              in_user['password'],
            ),
          );
        });
      });

      if (!users.isEmpty) {
        box1.put('id', users[0].id);
        box1.put('username', users[0].username);
        box1.put('phone', users[0].phone);
        box1.put('email', users[0].email);
        box1.put('password', users[0].password);
        box1.put('isLogged', true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (builder) => HomeScreen(),
            ));
      } else if (users.isEmpty) {
        response = 'Неверный логин или пароль';
      }
    }
  }
}
