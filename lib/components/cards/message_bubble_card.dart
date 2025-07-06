import 'package:booksexchange/controller/time_format/time_format.dart';
import 'package:booksexchange/model/message_model.dart';
import 'package:flutter/material.dart';
import '../../utils/app_theme/theme.dart';
import '../../utils/fontsize/responsive_text.dart';
import '../text_widget.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key, required this.index,required this.message,required this.isMe,

    required this.messageModel,
  });
  final int index;
  final String message;
  final bool isMe;
  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight:Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 2,
          mainAxisAlignment: isMe? MainAxisAlignment.end:MainAxisAlignment.start,
          crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            !isMe? CircleAvatar(backgroundImage: NetworkImage(messageModel.userPic),):SizedBox.shrink(),
            Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveBox.getSize(context, 260),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
              decoration: BoxDecoration(
                color: isMe ? AppThemeClass.secondary:AppThemeClass.primary ,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(isMe?30:0) ,
                  topRight:  Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight:Radius.circular(isMe?0:30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(text:
                  message,
                      color: isMe ?  Colors.black:Colors.white ,
                    fontSize: 15,
                      //isBold: true,
                      //isGoogleFont:true
                  ),
                  SizedBox(height: 5), // Space for timestamp & ticks
                  Row(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:MainAxisAlignment.end,
                    children: [
                      CustomText(text:
                      TimeFormater.timeAgo(messageModel.createdAt.toString()), // Example timestamp
                        fontSize: 10, color: isMe ?AppThemeClass.primary:AppThemeClass.whiteText,
                        isGoogleFont: true,
                      ),
                      if(isMe) Icon(
                        Icons.done_all,
                        size: 16,
                        color:  Colors.blueAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            isMe?   CircleAvatar(backgroundImage: NetworkImage(messageModel.userPic),):SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}