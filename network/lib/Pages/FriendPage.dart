// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:network/CustomUI/CustomCard.dart';
// import 'package:network/CustomUI/FriendCard.dart';
// import 'package:network/CustomUI/UserCard.dart';
// import 'package:network/Model/ChatModel.dart';
// import 'package:network/Model/FriendModel.dart';
// import 'package:network/Model/user.dart';
// import 'package:network/Module/http.dart';
// import 'package:network/Screens/SelectContact.dart';

// class FriendPage extends StatefulWidget {
//   const FriendPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _FriendPageState createState() => _FriendPageState();
// }

// class _FriendPageState extends State<FriendPage> {
//   TextEditingController _controller = TextEditingController();
//   List<FriendModel> friendsMod = [];
//   List<User> users = [];

//   Box? box1;
//   @override
//   void initState() {
//     super.initState();
//     OpenBox();
//   }

//   void OpenBox() async {
//     box1 = await Hive.openBox('logindata');
//     setState(() {
//       refreshFriends();
//     });
//   }

//   Future<void> refreshUsers() async {
//     var result = await http_post('friends', {
//       "username": _controller.text,
//     });
//     if (result.ok) {
//       setState(() {
//         users.clear();
//         var in_users = result.data as List<dynamic>;
//         in_users.forEach((in_user) {
//           users.add(
//             User(
//               in_user['id'].toString(),
//               in_user['username'],
//               in_user['phone'],
//               in_user['email'],
//               in_user['password'],
//             ),
//           );
//         });
//       });
//     }
//   }

//   Future<void> refreshFriends() async {
//     friendsMod.clear();
//     var result = await http_post('friends', {
//       "id": int.parse(box1?.get("id")),
//     });
//     if (result.ok) {
//       setState(() {
//         var in_users = result.data as List<dynamic>;
//         in_users.forEach((in_user) {
//           friendsMod.add(
//             User(
//               id: in_user['id'].toString(),
//               username: in_user['username'].toString(),
//             ),
//           );
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: refreshFriends,
//         child: ListView.builder(
//           itemCount: friendsMod.length,
//           itemBuilder: (context, index) {
//             return InkWell(onTap: () {
//               child:
//               UserCard(user: friendsMod[index]);
//             });
//           },
//         ),
//       ),
//     );
//   }

//   _searchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: _controller,
//         decoration: InputDecoration(
//           hintText: 'Search..',
//           suffixIcon: IconButton(
//             onPressed: () {
//               refreshUsers;
//             },
//             icon: Icon(Icons.search),
//           ),
//         ),
//         // onChanged: (value) {
//         //   if (value.length > 0 && _controller.text != '') {}
//         // },
//       ),
//     );
//   }
// }
