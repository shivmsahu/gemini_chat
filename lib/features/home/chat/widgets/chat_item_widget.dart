import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shivam_proj/features/home/models/chat_model.dart';
import 'package:shivam_proj/utils/functions.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    super.key,
    required this.chatItem,
  });

  final ChatModel chatItem;

  @override
  Widget build(BuildContext context) {
    final isBot = chatItem.sender == Sender.bot;
    const borderRadius = Radius.circular(10);
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isBot
              ? Theme.of(context).primaryColor.withOpacity(0.2)
              : Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.only(
              topLeft: borderRadius,
              topRight: borderRadius,
              bottomLeft: isBot ? Radius.zero : borderRadius,
              bottomRight: !isBot ? Radius.zero : borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatItem.message,
              style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.titleMedium),
            ),
            Text(
              formatDate(DateTime.parse(chatItem.timeStamp)),
              style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.titleSmall,
                  color: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.color
                      ?.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
