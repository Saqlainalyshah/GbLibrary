import 'package:booksexchange/screens/home/view_details.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../button.dart';
import '../text_widget.dart';

/// card to display posts
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.title,
    required this.board,
    required this.time,
    required this.description,
    required this.location,
    required this.type,
    required this.imageUrl,
  });
  final String title;
  final String board;
  final String time;
  final String description;
  final String location;
  final String type;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Row(
         crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Flexible(child:    buildContainerImage(context, imageUrl, 175,true),),
            Flexible(
              flex: 2,
              child: BuildPostColumn(
                title:
                title,
                board:
                board,
                type:type,
                description:
                description,
              ),
            )
          ],
        ),
        Flexible(child: _buildBottomRow(context, location, time)),
      ],
    );
  }
}
///Right side portion of card like title, board and dcription
class BuildPostColumn extends StatelessWidget {
  const BuildPostColumn({
    super.key,
    required this.type,
    required this.title,
    required this.board,
    required this.description
  });
      final String type;
      final String title;
      final String board;
      final String description;
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        CustomText(
          text: "I want to Exchange 1th class books",
          isBold: true,
          //overflow: TextOverflow.ellipsis,s
          fontSize: ResponsiveText.getSize(context, 15),
          maxLines: 5,
        ),

        buildIconTextRow(context, Icons.school, board),
        CustomText(
          text: description,
          //overflow: TextOverflow.ellipsis,s
          fontSize: ResponsiveText.getSize(context, 13),
          maxLines: 5,
        ),
      ],
    );
  }
}
///bottom row of card which contains location, time and view details button
_buildBottomRow(BuildContext context, String location, String time) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    spacing: 5,
    //mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(child: buildIconTextRow(context, Icons.location_on, location)),
      buildIconTextRow(context, Icons.access_time, time),
      CustomButton(
       // isBorder: false,
        radius: 5,
        onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => ViewDetails()),
          );
        },
        title: 'View Details',
        width: ResponsiveBox.getSize(context, 120),
        height: ResponsiveBox.getSize(context, 40),
      ),
    ],
  );
}


///Container to show image with border or without border
buildContainerImage(
  BuildContext context,
  String imageUrl,
  double size,
  bool isBorder,
) {
  return Container(
    padding: EdgeInsets.all(2),
    height: ResponsiveBox.getSize(context,size ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: isBorder
          ? Border.all(color: AppThemeClass.primary, width: .5)
          : null,
    ),
    
    child: Image.asset("assets/images/book.jpg",fit: BoxFit.cover,),
  );
}
///row widget wrapped in a container with a app secondary color which contains icon and text
buildIconTextRow(BuildContext context, IconData icon, String text) {
  return Container(
   // width: double.infinity,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: AppThemeClass.secondary,
      borderRadius: BorderRadius.circular(3),
    ),
    child: Row(
      spacing: 3,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppThemeClass.primary,
          size: ResponsiveBox.getSize(context, 18),
        ),
        Flexible(
          child: CustomText(
            text: text,
            maxLines: 1,
            fontSize: ResponsiveText.getSize(context, 12),
          ),
        ),
      ],
    ),
  );
}
