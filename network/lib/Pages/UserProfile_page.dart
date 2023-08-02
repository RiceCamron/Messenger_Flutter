import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/Model/friend.dart';
import 'package:network/Model/user.dart';
import 'package:network/Module/http.dart';
import 'package:network/Screens/HomeScreen.dart';
import 'package:velocity_x/velocity_x.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<Friend> friends = [];

  String txtFollowBtn = 'Добавить в друзья';
  bool isFollow = false;

  Box? box1;

  @override
  void initState() {
    super.initState();
    OpenBox();
  }

  void OpenBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {
      userProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 30, 52, 1),
        leadingWidth: 70,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, size: 24),
            ],
          ),
        ),
        title: Text(widget.user.username, style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            CircleAvatar(
              child: SvgPicture.asset(
                "assets/person.svg",
                color: Colors.white,
                height: 100,
                width: 100,
              ),
              backgroundColor: Colors.blue[600],
              maxRadius: 50.0,
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Text('@' + widget.user.username),
            ),
            ElevatedButton(
              onPressed: () {
                if (friends.isEmpty) {
                  addToFriend();
                  userProfile();
                } else if ((friends[0].friend_one == box1?.get("id") &&
                        friends[0].status == '0') ||
                    (friends[0].friend_one == box1?.get("id") &&
                        friends[0].status == '1') ||
                    (friends[0].friend_two == box1?.get("id") &&
                        friends[0].status == '1')) {
                  removeFriend();
                  userProfile();
                } else {
                  confirmFriendReq();
                  userProfile();
                }
              },
              child: Text(txtFollowBtn),
            ),
          ],
        ),
      ),
    );
  }

  userProfile() async {
    friends.clear();
    var result = await http_post('user-profile', {
      "user_id": box1?.get("id"),
      "friend_id": int.parse(widget.user.id),
    });
    if (result.ok) {
      if (result.data != null) {
        setState(() {
          var in_users = result.data as List<dynamic>;
          in_users.forEach((in_user) {
            friends.add(
              Friend(
                in_user['friend_one'].toString(),
                in_user['friend_two'].toString(),
                in_user['status'].toString(),
              ),
            );
          });
          if (friends[0].friend_one == box1?.get("id") &&
              friends[0].status == '0') {
            txtFollowBtn = 'Заявка отправлена';
          } else if (friends[0].status == '1') {
            txtFollowBtn = 'В друзьях';
          } else {
            txtFollowBtn = 'Подтвердить запрос';
          }
        });
      } else {
        txtFollowBtn = 'Добавить в друзья';
      }
    }
  }

  addToFriend() async {
    var result = await http_post('add-to-friend', {
      "user_id": box1?.get("id"),
      "friend_id": int.parse(widget.user.id),
    });
    if (result.ok) {
      setState(() {});
    }
  }

  confirmFriendReq() async {
    var result = await http_post('confirm-friend-req', {
      "user_id": box1?.get("id"),
      "friend_id": int.parse(widget.user.id),
    });
    if (result.ok) {
      setState(() {});
    }
  }

  removeFriend() async {
    var result = await http_post('remove-friend', {
      "user_id": box1?.get("id"),
      "friend_id": int.parse(widget.user.id),
    });
    if (result.ok) {
      setState(() {});
    }
  }
}
