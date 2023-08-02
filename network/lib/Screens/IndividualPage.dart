import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network/CustomUI/OwnMessageCard.dart';
import 'package:network/CustomUI/ReplyCard.dart';
import 'package:network/Model/FriendModel.dart';
import 'package:network/Model/MessageModel.dart';
import 'package:network/Model/user.dart';
import 'package:network/Module/http.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:network/Model/ChatModel.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({Key? key, required this.chatModel, required this.user})
      : super(key: key);

  final ChatModel chatModel;
  final User user;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  // bool showEmoji = false;

  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  late IO.Socket socket;
  bool sendButton = false;
  List<MessageModel> messages = [];
  List<int> targets_id = [];
  ScrollController _scrollController = ScrollController();

  Box? box1;

  void OpenBox() async {
    box1 = await Hive.openBox('logindata');

    if (mounted) {
      setState(() {
        refreshMessages();
        refreshParty();
      });
    }
  }

  void connect() {
    socket = IO.io("http://192.168.1.134:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("/signin", widget.user.id);
    socket.onConnect((data) {
      // print("Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage(
            msg['message'].toString(), "destination", widget.chatModel.c_id);
        if (_scrollController.hasClients) {
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
    });
    // print(socket.connected);
  }

  void sendMessage(String message, String sourceId) async {
    setMessage(message, sourceId, widget.chatModel.c_id);

    for (var i in targets_id) {
      socket.emit(
        "message",
        {
          "message": message,
          "sourceId": int.parse(sourceId),
          "targetId": i,
          // "targetId": int.parse(targetId),
        },
      );
    }
  }

  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    OpenBox();
    connect();
  }

  void setMessage(
    String content,
    String from_id,
    String c_id,
  ) async {
    MessageModel messageModel = MessageModel(
      content: content,
      from_id: from_id,
      // to_id: to_id,
      c_id: c_id,
    );
    var result = await http_post('add-message', {
      "content": content,
      "from_id": int.parse(box1?.get("id")),
      // "to_id": int.parse(widget.chatModel.user_id),
      "c_id": widget.chatModel.c_id,
    });
    if (result.ok) {
      if (mounted) {
        setState(() {
          messages.add(messageModel);
        });
      }
    }
  }

  Future<void> refreshMessages() async {
    var result = await http_post('messages', {
      "c_id": widget.chatModel.c_id,
    });
    if (result.ok) {
      if (mounted) {
        setState(() {
          messages.clear();
          var in_messages = result.data as List<dynamic>;
          in_messages.forEach((in_message) {
            messages.add(
              MessageModel(
                content: in_message['content'],
                from_id: in_message['from_id'].toString(),
                // to_id: in_message['to_id'].toString(),
                c_id: in_message['c_id'].toString(),
              ),
            );
          });
        });
      }
    }
  }

  Future<void> refreshParty() async {
    var result = await http_post('party', {
      "user_id": int.parse(box1?.get("id")),
      "c_id": widget.chatModel.c_id,
    });
    if (result.ok) {
      if (mounted) {
        setState(() {
          targets_id.clear();
          var in_parties = result.data as List<dynamic>;
          in_parties.forEach((in_party) {
            targets_id.add(in_party['id']);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double messageListHeight = MediaQuery.of(context).size.height - 150;
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 30, 52, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 30, 52, 1),
        leadingWidth: 70,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, size: 24),
              CircleAvatar(
                child: SvgPicture.asset(
                  "assets/person.svg",
                  color: Colors.white,
                  height: 34,
                  width: 34,
                ),
                radius: 20,
                backgroundColor: Colors.blue[400],
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatModel.c_name,
                    style:
                        TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold)),
                // Text(
                //   "last seen today at 12.06",
                //   style: TextStyle(fontSize: 12),
                // ),
              ],
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.videocam),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.call),
        //   ),
        //   PopupMenuButton(itemBuilder: (BuildContext context) {
        //     return [
        //       PopupMenuItem(
        //         child: Text("View Contact"),
        //         value: "View Contact",
        //       ),
        //       PopupMenuItem(
        //         child: Text("Media, links, and docs"),
        //         value: "Media, links, and docs",
        //       ),
        //       PopupMenuItem(
        //         child: Text("Search"),
        //         value: "Search",
        //       ),
        //       PopupMenuItem(
        //         child: Text("Mute Notification"),
        //         value: "Mute Notification",
        //       ),
        //       PopupMenuItem(
        //         child: Text("Wallpaper"),
        //         value: "Wallpaper",
        //       ),
        //     ];
        //   }),
        // ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              // height: messageListHeight,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                // itemCount: messages.length,

                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return Container(
                      height: 68,
                    );
                  }
                  if (messages[index].from_id == box1?.get("id")) {
                    return OwnMessageCard(
                      message: messages[index].content,
                    );
                  } else {
                    return ReplyCard(
                      message: messages[index].content,
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 68,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Card(
                            margin:
                                EdgeInsets.only(left: 2, right: 2, bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextFormField(
                              controller: _controller,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              onChanged: (value) {
                                messageListHeight =
                                    MediaQuery.of(context).size.height - 600;
                                if (value.length > 0) {
                                  setState(() {
                                    sendButton = true;
                                  });
                                } else {
                                  setState(() {
                                    sendButton = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Type a message",
                                // prefixIcon: IconButton(
                                //   icon: Icon(Icons.emoji_emotions),
                                //   onPressed: () {
                                //     setState((){
                                //       showEmoji != showEmoji;
                                //     });
                                //   },
                                // ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // IconButton(
                                    //   icon: Icon(Icons.attach_file),
                                    //   onPressed: () {
                                    //     showModalBottomSheet(
                                    //         backgroundColor: Colors.transparent,
                                    //         context: context,
                                    //         builder: (builder) =>
                                    //             bottomSheet());
                                    //   },
                                    // ),
                                    // IconButton(
                                    //   icon: Icon(Icons.camera_alt),
                                    //   onPressed: () {},
                                    // ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 8, right: 2, left: 2),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Color.fromRGBO(19, 30, 52, 1),
                            child: IconButton(
                              icon: Icon(
                                sendButton ? Icons.send : Icons.mic,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (sendButton == true &&
                                    _controller.text != '') {
                                  if (_scrollController.hasClients) {
                                    // _scrollController.jumpTo(_scrollController
                                    // .position.maxScrollExtent);

                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                  }
                                  sendMessage(
                                    _controller.text,
                                    widget.user.id,
                                    // targets_id[0].toString(),
                                  );
                                  _controller.clear();
                                  sendButton = false;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {
        if (text == 'Camera') {
          takePhoto(ImageSource.camera);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 29,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _scrollController.dispose();

    socket.close();
  }

  void takePhoto(ImageSource imgSource) async {
    final pickedFile = await _picker.getImage(source: imgSource);
    setState(() {
      _imageFile = pickedFile!;
    });
  }
  // Widget emojiSelect() {
  //   return EmojiPicker(
  //       rows: 4,
  //       columns: 7,
  //       onEmojiSelected: (emoji, category) {
  //         print(emoji);
  //       });
  // }
}
