import 'package:flutter/material.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/FriendModel.dart';
import 'package:network/Model/user.dart';
import 'package:network/Module/http.dart';
import 'package:network/Pages/ChatPage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:network/Pages/FriendPage.dart';
import 'package:network/Pages/UsersPage.dart';
import 'package:network/pages/login_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late User user = User(
    box1?.get("id"),
    box1?.get("username"),
    box1?.get("phone"),
    box1?.get("email"),
    box1?.get("password"),
  );
  TabController? _controller;

  Box? box1;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    OpenBox();
  }

  void OpenBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {
      // searchUser();
    });
  }

  // Future<void> searchUser() async {
  //   var result = await http_post('search-user', {
  //     "id": int.parse(box1?.get("id")),
  //   });
  //   if (result.ok) {
  //     setState(() {
  //       sourceChat.clear();
  //       var in_sourceChats = result.data as List<dynamic>;
  //       in_sourceChats.forEach((in_sourceChat) {
  //         sourceChat.add(
  //           ChatModel(
  //             user_id: in_sourceChat['id'].toString(),
  //             c_name: in_sourceChat['c_name'].toString(),
  //             c_id: in_sourceChat['c_id'].toString(),
  //           ),
  //         );
  //       });
  //     });
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network'),
        backgroundColor: Color.fromRGBO(19, 30, 52, 1), //25, 25, 112
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              box1?.put('isLogged', false);
              box1?.delete('id');
              box1?.delete('username');
              box1?.delete('phone');
              box1?.delete('email');
              box1?.delete('password');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (builder) => Login_Page()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "Friends",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ChatPage(
            user: user,
          ),
          UsersPage(),
        ],
      ),
    );
  }
}
