import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/FriendModel.dart';
import 'package:network/Model/user.dart';
import 'package:network/Screens/IndividualPage.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.chatModel, required this.user})
      : super(key: key);

  final ChatModel chatModel;
  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualPage(
              chatModel: chatModel,
              user: user,
            ),
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset(
                "assets/person.svg",
                color: Colors.white,
                height: 34,
                width: 34,
              ),
              backgroundColor: Colors.blue[400],
            ),
            title: Text(
              chatModel.c_name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
                // children: [
                //   Icon(Icons.done_all),
                //   SizedBox(
                //     width: 3,
                //   ),
                // ],
                ),
          ),
        ],
      ),
    );
  }
}
