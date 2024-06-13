import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shivam_proj/features/home/chat/widgets/chat_item_widget.dart';
import 'package:shivam_proj/features/home/chat/widgets/edit_chatroom_dialog.dart';
import 'package:shivam_proj/features/home/models/chat_model.dart';
import 'package:shivam_proj/features/home/models/chatroom_model.dart';
import 'package:shivam_proj/utils/functions.dart';
import 'package:shivam_proj/utils/prefrence_util.dart';

class ChatPage extends StatefulWidget {
  final ChatroomModel chatroom;

  const ChatPage({super.key, required this.chatroom});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController messageController;
  final gemini = Gemini.instance;
  late String chatroomName;
  List<ChatModel> chatList = [];

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    chatroomName = widget.chatroom.name;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatList =
        PreferencesUtil().getChatList(widget.chatroom.id).reversed.toList();
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) => EditChatroomNameDialog(
                        chatroom: widget.chatroom,
                      )).then((value) {
                setState(() {
                  chatroomName = value.toString();
                });
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  chatroomName,
                  style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headlineMedium),
                ),
                Text(
                  formatDate(DateTime.parse(widget.chatroom.id)),
                  style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.titleSmall),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    itemCount: chatList.length,
                    reverse: true,
                    shrinkWrap: chatList.length < 10,
                    //Assuming screen height can accommodate maximum 10 messages
                    //shrinkWrap will be true only if there are less than 10 messages
                    //because shrinkWrap true will build all message at once which can hamper performance
                    //and will not provide any benefit for if there are than 10 message
                    itemBuilder: (_, index) {
                      return ChatItemWidget(chatItem: chatList[index]);
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: messageController,
                onSubmitted: (_) {
                  sendMessage();
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Ask something',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void sendMessage() {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    saveLocally(messageController.text, Sender.user);
    gemini.text(messageController.text).then((value) {
      saveLocally(value?.content?.parts?.last.text ?? '', Sender.bot);
      EasyLoading.dismiss();
      setState(() {});
    }).catchError((e) {
      const message = 'Something went wrong';
      saveLocally(message, Sender.bot);
      EasyLoading.dismiss();
      EasyLoading.showToast(message);
      setState(() {});
    });
    messageController.clear();
  }

  void saveLocally(String message, Sender sender) {
    PreferencesUtil().addToChatList(
        ChatModel(
            timeStamp: DateTime.now().toString(),
            message: message,
            sender: sender),
        widget.chatroom.id);
  }
}
