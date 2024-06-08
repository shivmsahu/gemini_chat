import 'dart:convert';

class ChatroomModel {
  final String id;
  final String name;

  const ChatroomModel({required this.id, required this.name});

  copyWith({String? name}) {
    return ChatroomModel(
      id: id,
      name: name ?? this.name,
    );
  }

  toJson() {
    return {'id': id, 'name': name};
  }

  factory ChatroomModel.fromJson(Map<String, dynamic> json) {
    return ChatroomModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory ChatroomModel.fromJsonString(String json) {
    return ChatroomModel.fromJson(jsonDecode(json));
  }

  String toJsonString() => jsonEncode(toJson());
}
