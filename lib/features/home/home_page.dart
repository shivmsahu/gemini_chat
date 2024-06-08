import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shivam_proj/features/home/chat/chat_page.dart';
import 'package:shivam_proj/features/home/models/chatroom_model.dart';
import 'package:shivam_proj/features/home/widgets/are_you_sure_dialog.dart';
import 'package:shivam_proj/utils/prefrence_util.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final chatRoomList = PreferencesUtil().getChatRoomList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: chatRoomList.isNotEmpty
            ? ListView.builder(
                itemCount: chatRoomList.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  chatroom: chatRoomList[index],
                                )))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chatRoomList[index].name,
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AreYouSureDialog(
                                    message:
                                        'Are you sure you want to proceed?',
                                    onConfirm: () {
                                      PreferencesUtil().removeChatRoomList(
                                          chatRoomList[index].id);
                                    },
                                  );
                                },
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ),
              )
            : Text(
                'Click on floating button to initiate a new chat',
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.titleMedium),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final chatRoom =
              ChatroomModel(id: DateTime.now().toString(), name: 'Untitled');
          PreferencesUtil().addEditChatRoomList(chatRoom);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => ChatPage(
                        chatroom: chatRoom,
                      )))
              .then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
