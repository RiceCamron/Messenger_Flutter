import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/CustomUI/AvatarCard.dart';
import 'package:network/CustomUI/ButtonCard.dart';
import 'package:network/CustomUI/FriendCard.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/FriendModel.dart';
import 'package:network/Module/http.dart';

class CreateTitleGroup extends StatefulWidget {
  CreateTitleGroup(
      {Key? key, required this.friendsMod, required this.groupMember})
      : super(key: key);

  final List<FriendModel> friendsMod;
  final List<FriendModel> groupMember;

  @override
  _CreateTitleGroupState createState() => _CreateTitleGroupState();
}

class _CreateTitleGroupState extends State<CreateTitleGroup> {
  TextEditingController _controller = TextEditingController();
  // Box? box1;

  // @override
  // void initState() {
  //   super.initState();
  //   OpenBox();
  // }

  // void OpenBox() async {
  //   box1 = await Hive.openBox('logindata');
  //   setState(() {
  //     refreshFriends();
  //   });
  // }

  // refreshFriends() async {
  //   widget.friendsMod.clear();
  //   var result = await http_post('friends', {
  //     "id": int.parse(box1?.get("id")),
  //   });
  //   if (result.ok) {
  //     setState(() {
  //       var in_users = result.data as List<dynamic>;
  //       in_users.forEach((in_user) {
  //         widget.friendsMod.add(
  //           FriendModel(
  //             id: in_user['id'].toString(),
  //             username: in_user['username'].toString(),
  //           ),
  //         );
  //       });
  //     });
  //   }
  // }

  // createChat() async {
  //   var result = await http_post('create-chat', {
  //     "id": int.parse(box1?.get("id")),
  //     "friend_id": int.parse(widget.groupMember[0].id),
  //   });
  //   if (result.ok) {
  //     setState(() {
  //       Navigator.pop(context);
  //     });
  //   }
  // }

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
              "New Group",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Add title",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                size: 26,
              ),
              onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          onPressed: () {
            setState(() {
              // createChat();
            });
          },
          child: Icon(Icons.arrow_forward)),
      body: Container(
        child: ListView.builder(
          itemCount: widget.groupMember.length,
          itemBuilder: (context, index) {
            if (!widget.groupMember.isEmpty) {
              return InkWell(
                child: FriendCard(
                  friendModel: widget.groupMember[index],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
