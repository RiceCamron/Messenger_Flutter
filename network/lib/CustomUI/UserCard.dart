import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/user.dart';
import 'package:network/Pages/UserProfile_page.dart';
import 'package:network/Screens/IndividualPage.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              user: user,
            ),
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue[600]),
            title: Text(user.username),
          ),
        ],
      ),
    );
  }
}
