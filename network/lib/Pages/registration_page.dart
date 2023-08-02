import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:network/pages/login_page.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:network/Module/http.dart';

class Registration_Page extends StatefulWidget {
  const Registration_Page({Key? key}) : super(key: key);

  @override
  _Registration_PageState createState() => _Registration_PageState();
}

class _Registration_PageState extends State<Registration_Page> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String response = "";

  Registration() async {
    var result = await http_post("create-user", {
      "username": usernameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "password": passwordController.text
    });
    if (result.ok) {
      setState(() {
        response = result.data['status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(19, 30, 52, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeightBox(110),
                      "Registration".text.color(Colors.white).size(20).make(),
                      HeightBox(26),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            isDense: true, // Added this
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      HeightBox(20),
                      GestureDetector(
                          onTap: () {
                            Registration();
                          },
                          child: "Sign-Up"
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
                      HeightBox(140),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login_Page()));
          },
          child: RichText(
              text: TextSpan(
            text: 'New User?',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: ' Login Now',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.blue[200]),
              ),
            ],
          )).pLTRB(20, 0, 0, 15),
        ));
  }
}
