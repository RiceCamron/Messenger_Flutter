import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network/CustomUI/CustomCard.dart';
import 'package:network/CustomUI/UserCard.dart';
import 'package:network/Model/ChatModel.dart';
import 'package:network/Model/user.dart';
import 'package:network/Module/http.dart';
import 'package:network/Pages/UserProfile_page.dart';
import 'package:network/Screens/SelectContact.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({
    Key? key,
  }) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  TextEditingController _controller = TextEditingController();

  List<User> users = [];
  List<User> userSearch = [];
  bool isSearch = false;

  Box? box1;

  @override
  void initState() {
    super.initState();

    OpenBox();
  }

  void OpenBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {
      refreshUsers();
    });
  }

  Future<void> searchUser() async {
    var result = await http_post('search-user', {
      "username": _controller.text.toString(),
    });
    if (result.ok) {
      setState(() {
        userSearch.clear();
        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          userSearch.add(
            User(
              in_user['id'].toString(),
              in_user['username'],
              in_user['phone'],
              in_user['email'],
              in_user['password'],
            ),
          );
        });
      });
      print(r'$$$$$$$$$$$$$$$$$$$$$$');
      print(userSearch);
    }
  }

  Future<void> refreshUsers() async {
    var result = await http_post('friends2', {
      "id": box1?.get("id"),
    });
    if (result.ok) {
      setState(() {
        users.clear();
        var in_users = result.data as List<dynamic>;
        in_users.forEach((in_user) {
          users.add(
            User(
              in_user['id'].toString(),
              in_user['username'],
              in_user['phone'],
              in_user['email'],
              in_user['password'],
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshUsers,
      child: Stack(
        children: [
          _searchBar(),
          isSearch
              ? Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: ListView.separated(
                    itemCount: userSearch.length,
                    itemBuilder: (context, i) => UserCard(user: userSearch[i]),
                    separatorBuilder: (context, i) => Divider(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: ListView.separated(
                    itemCount: users.length,
                    itemBuilder: (context, i) => UserCard(user: users[i]),
                    separatorBuilder: (context, i) => Divider(),
                  ),
                ),
        ],
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
            hintText: 'Search User',
            suffixIcon: isSearch
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = false;
                        _controller.clear();
                      });
                    },
                    icon: Icon(Icons.clear),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        searchUser();
                        print(userSearch.length);
                        isSearch = true;
                      });
                    },
                    icon: Icon(Icons.search),
                  )),
        // onChanged: (value) {
        //   if (value.length > 0 && _controller.text != '') {}
        // },
      ),
    );
  }
}
