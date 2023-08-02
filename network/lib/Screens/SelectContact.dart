import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/CustomUI/ButtonCard.dart';
import 'package:network/CustomUI/FriendCard.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/FriendModel.dart';
import 'package:network/Module/http.dart';
import 'package:network/Screens/CreateGroup.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<FriendModel> friendsMod = [];

  Box? box1;

  @override
  void initState() {
    super.initState();
    OpenBox();
  }

  void OpenBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {
      refreshFriends();
    });
  }

  refreshFriends() async {
    friendsMod.clear();
    var result = await http_post('friends', {
      "id": int.parse(box1?.get("id")),
    });
    if (result.ok) {
      setState(() {
        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          friendsMod.add(
            FriendModel(
              id: in_user['id'].toString(),
              username: in_user['username'].toString(),
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 30, 52, 1),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Friends",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              friendsMod.length.toString(),
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 26),
            onPressed: () {},
          ),
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("Invite a friend"),
                value: "Invite a friend",
              ),
              PopupMenuItem(
                child: Text("Contacts"),
                value: "Contacts",
              ),
              PopupMenuItem(
                child: Text("Refresh"),
                value: "Refresh",
              ),
              PopupMenuItem(
                child: Text("Help"),
                value: "Help",
              ),
            ];
          }),
        ],
      ),
      body: ListView.builder(
          itemCount: friendsMod.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CreateGroup(),
                      ),
                    );
                  },
                  child: ButtonCard(icon: Icons.group, name: "New Group"));
            }
            return FriendCard(
              friendModel: friendsMod[index - 2],
            );
          }),
    );
  }
}
