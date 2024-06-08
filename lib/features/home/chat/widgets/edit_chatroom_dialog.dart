import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shivam_proj/features/home/models/chatroom_model.dart';
import 'package:shivam_proj/utils/prefrence_util.dart';

class EditChatroomNameDialog extends StatefulWidget {
  final ChatroomModel chatroom;

  const EditChatroomNameDialog({super.key, required this.chatroom});

  @override
  State<EditChatroomNameDialog> createState() => _EditChatroomNameDialogState();
}

class _EditChatroomNameDialogState extends State<EditChatroomNameDialog> {
  late TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController(text: widget.chatroom.name);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update chatroom name'),
      content: TextField(
        controller: _textFieldController,
        decoration: const InputDecoration(hintText: "Enter new name"),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            String enteredText = _textFieldController.text.trim();
            if (enteredText.isEmpty) {
              EasyLoading.showToast('Name cannot be empty');
              return;
            }
            PreferencesUtil().addEditChatRoomList(
                widget.chatroom.copyWith(name: enteredText));
            Navigator.of(context).pop(enteredText);
          },
        ),
      ],
    );
  }
}
