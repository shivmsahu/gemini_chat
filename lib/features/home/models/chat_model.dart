import 'dart:convert';

class ChatModel {
  final String timeStamp;
  final String message;
  final Sender sender;

  const ChatModel(
      {required this.timeStamp, required this.message, required this.sender});

  copyWith({String? message}) {
    return ChatModel(
      timeStamp: timeStamp,
      message: message ?? this.message,
      sender: sender,
    );
  }

  toJson() {
    return {
      'timeStamp': timeStamp,
      'message': message,
      'sender': sender == Sender.bot ? 'bot' : 'user'
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      timeStamp: json['timeStamp'],
      message: json['message'],
      sender: json['sender'] == 'bot' ? Sender.bot : Sender.user,
    );
  }

  factory ChatModel.fromJsonString(String json) {
    return ChatModel.fromJson(jsonDecode(json));
  }

  String toJsonString() => jsonEncode(toJson());
}

enum Sender { user, bot }
