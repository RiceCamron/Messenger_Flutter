// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:network/CustomUI/ButtonCard.dart';
// import 'package:network/Model/ChatModel.dart';
// import 'package:network/Model/FriendModel.dart';
// import 'package:network/Module/http.dart';
// import 'package:network/Screens/HomeScreen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   Box? box1;

//   late ChatModel sourceChat;
//   List<ChatModel> chatModels = [];

//   Future<void> refreshUsers() async {
//     var result = await http_post('search-user', {
//       "id": int.parse(box1?.get("id")),
//     });
//     if (result.ok) {
//       setState(() {
//         chatModels.clear();
//         var in_users = result.data as List<dynamic>;
//         in_users.forEach((in_user) {
//           chatModels.add(
//             ChatModel(
//               username: in_user['username'],
//               user_id: in_user['user_id'].toString(),
//               Id: in_user['id'].toString(),
//             ),
//           );
//         });
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     OpenBox();
//   }

//   void OpenBox() async {
//     box1 = await Hive.openBox('logindata');
//     setState(() {
//       refreshUsers();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: chatModels.length,
//         itemBuilder: (context, index) => InkWell(
//           onTap: () {
//             sourceChat = chatModels.removeAt(index);
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (builder) => HomeScreen(
//                   chatModels: chatModels,
//                   sourceChat: sourceChat,
//                 ),
//               ),
//             );
//           },
//           child: ButtonCard(
//             name: chatModels[index].username,
//             icon: Icons.animation,
//           ),
//         ),
//       ),
//     );
//   }
// }
