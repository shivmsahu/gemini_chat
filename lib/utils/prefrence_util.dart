import 'package:shared_preferences/shared_preferences.dart';
import 'package:shivam_proj/features/home/models/chat_model.dart';
import 'package:shivam_proj/features/home/models/chatroom_model.dart';

class PreferencesUtil {
  late SharedPreferences _preferences;

  static final PreferencesUtil _instance = PreferencesUtil._();

  factory PreferencesUtil() {
    return _instance;
  }

  PreferencesUtil._();

  /// call this method one time to initialize Shared-preferences before using it
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  SharedPreferences get instance => _preferences;

  Future<bool> addEditChatRoomList(ChatroomModel chatroom) async {
    final chatroomList = getChatRoomList();
    final existingIndex =
        chatroomList.indexWhere((element) => element.id == chatroom.id);
    if (existingIndex != -1) {
      chatroomList[existingIndex] = chatroom;
    } else {
      chatroomList.add(chatroom);
    }
    return _preferences.setStringList(
        'chatRoomList', chatroomList.map((e) => e.toJsonString()).toList());
  }

  List<ChatroomModel> getChatRoomList() {
    final chatRoomList = _preferences.getStringList('chatRoomList');
    if (chatRoomList == null) return [];
    return chatRoomList.map((e) => ChatroomModel.fromJsonString(e)).toList();
  }

  Future<bool> addToChatList(ChatModel chat, String id) async {
    final chatList = getChatList(id);
    chatList.add(chat);
    return _preferences.setStringList(
        id, chatList.map((e) => e.toJsonString()).toList());
  }

  List<ChatModel> getChatList(String id) {
    final chatList = _preferences.getStringList(id);
    if (chatList == null) return [];
    return chatList.map((e) => ChatModel.fromJsonString(e)).toList();
  }

  Future<bool> removeChatRoomList(String id) {
    _preferences.remove(id);
    final chatroomList = getChatRoomList();
    chatroomList.removeWhere((element) => element.id == id);
    return _preferences.setStringList(
        'chatRoomList', chatroomList.map((e) => e.toJsonString()).toList());
  }
}
