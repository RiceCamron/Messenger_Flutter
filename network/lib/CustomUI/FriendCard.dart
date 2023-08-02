import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/FriendModel.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({Key? key, required this.friendModel}) : super(key: key);
  final FriendModel friendModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 54,
        width: 50,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              child: SvgPicture.asset(
                "assets/person.svg",
                color: Colors.white,
                height: 30,
                width: 30,
              ),
              backgroundColor: Colors.blue[400],
            ),
            friendModel.isSelect
                ? Positioned(
                    bottom: 4,
                    right: 2,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      radius: 11,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      title: Text(
        friendModel.username,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
