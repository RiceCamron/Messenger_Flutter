import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/CustomUI/AvatarCard.dart';
import 'package:network/CustomUI/ButtonCard.dart';
import 'package:network/CustomUI/FriendCard.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/FriendModel.dart';
import 'package:network/Module/http.dart';
import 'package:network/Screens/CreateTitleGroup.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<FriendModel> friendsMod = [];
  List<FriendModel> groupMember = [];
  Box? box1;
  TextEditingController _controller = TextEditingController();

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

  createChat() async {
    var friends_id = [];
    for (var i in groupMember) {
      friends_id.add(int.parse(i.id));
    }
    var result = await http_post('create-chat', {
      "id": int.parse(box1?.get("id")),
      "friend_id": friends_id,
      "c_name": _controller.text
    });
    if (result.ok) {
      setState(() {
        Navigator.pop(context);
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
              "New Group",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Add participants",
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
            setState(
              () {
                if (groupMember.isNotEmpty && _controller.text != '') {
                  createChat();
                }
              },
            );
          },
          child: Icon(Icons.arrow_forward)),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: friendsMod.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    height: groupMember.length > 0 ? 156 : 10,
                  );
                }
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (friendsMod[index - 1].isSelect == true) {
                        groupMember.remove(friendsMod[index - 1]);
                        friendsMod[index - 1].isSelect = false;
                      } else {
                        groupMember.add(friendsMod[index - 1]);
                        friendsMod[index - 1].isSelect = true;
                      }
                    });
                  },
                  child: FriendCard(
                    friendModel: friendsMod[index - 1],
                  ),
                );
              }),
          groupMember.length > 0
              ? Align(
                  child: Column(
                    children: [
                      _titleBar(),
                      Container(
                        height: 75,
                        color: Colors.white,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: friendsMod.length,
                            itemBuilder: (context, index) {
                              if (friendsMod[index].isSelect == true)
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      groupMember.remove(friendsMod[index]);
                                      friendsMod[index].isSelect = false;
                                    });
                                  },
                                  child: AvatarCard(
                                    friendModel: friendsMod[index],
                                  ),
                                );
                              return Container();
                            }),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                  alignment: Alignment.topCenter,
                )
              : Container(),
        ],
      ),
    );
  }

  _titleBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Group Name',
          suffixIcon: IconButton(
            onPressed: () {
              _controller.clear();
              setState(() {});
            },
            icon: Icon(Icons.clear),
          ),
        ),
        onChanged: (value) {
          if (value.length > 0 && _controller.text != '') {}
        },
      ),
    );
  }
}
