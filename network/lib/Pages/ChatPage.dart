import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/CustomUI/FriendCard.dart';
import 'package:network/CustomUI/CustomCard.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/FriendModel.dart';
import 'package:network/Model/user.dart';
import 'package:network/Module/http.dart';
import 'package:network/Screens/CreateGroup.dart';
import 'package:network/Screens/SelectContact.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> chatModels = [];

  Box? box1;

  @override
  void initState() {
    super.initState();

    OpenBox();
  }

  void OpenBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {
      // searchUser();
      refreshChats();
    });
  }

  // Future<void> searchUser() async {
  //   var result = await http_post('search-user', {
  //     "id": int.parse(box1?.get("id")),
  //   });
  //   if (result.ok) {
  //     setState(() {
  //       chatModels.clear();
  //       var in_users = result.data as List<dynamic>;
  //       in_users.forEach((in_user) {
  //         sourceChat = ChatModel(
  //           c_name: in_user['c_name'],
  //           user_id: in_user['id'].toString(),
  //           c_id: in_user['c_id'].toString(),
  //         );
  //       });
  //       print(chatModels);
  //     });
  //   }
  // }

  Future<void> refreshChats() async {
    var result = await http_post('chats', {
      "id": box1?.get("id"),
    });
    if (result.ok) {
      setState(() {
        chatModels.clear();
        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          chatModels.add(
            ChatModel(
              user_id: in_user['id'].toString(),
              c_name: in_user['c_name'],
              c_id: in_user['c_id'].toString(),
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => CreateGroup(),
            ),
          );
        },
        backgroundColor: Colors.blue[400],
        child: Icon(Icons.chat, color: Colors.white),
      ),
      body: RefreshIndicator(
          onRefresh: refreshChats,
          child: ListView.builder(
              itemCount: chatModels.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: CustomCard(
                    chatModel: chatModels[index],
                    user: widget.user,
                  ),
                );
                // separatorBuilder: (context, i) => Divider(),
              })),
    );
  }
}
