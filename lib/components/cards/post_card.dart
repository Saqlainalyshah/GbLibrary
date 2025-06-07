import 'package:booksexchange/screens/postview/view_details.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import '../button.dart';
import '../text_widget.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.title,
    required this.board,
    required this.time,
    required this.description,
    required this.location,
    required this.numberOfBooks,
    required this.imageUrl,
  });
  final String title;
  final String board;
  final String time;
  final String description;
  final String location;
  final int numberOfBooks;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Flexible(
                flex: 1,
                child: buildContainerImage(context, imageUrl, 160, true),
              ),
              Flexible(
                flex: 2,
                child: buildPostColumn(
                  context,
                  title,
                  board,
                  numberOfBooks,
                  description,
                ),
              ),
            ],
          ),
          Flexible(child: buildBottomRow(context, location, time)),
        ],
      ),
    );
  }
}

buildPostColumn(
  BuildContext context,
  String title,
  String board,
  int noOfBooks,
  String description,
) {
  return Column(
    // mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 10,
    children: [
      RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: ResponsiveText.getSize(context, 18)),
          children: [
            TextSpan(
              text: "I want to Exchange ",
              style: GoogleFonts.asapCondensed(
                fontWeight: FontWeight.bold,
                color: AppThemeClass.darkText,
              ),
            ),
            TextSpan(
              text: "$title class Books",
              style: GoogleFonts.asapCondensed(
                fontWeight: FontWeight.bold,
                color: Color(0xff00a67e),
              ),
            ),
          ],
        ),
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

buildBottomRow(BuildContext context, String location, String time) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //mainAxisSize: MainAxisSize.min,
    children: [
      buildIconTextRow(context, Icons.location_on, location),
      buildIconTextRow(context, Icons.access_time, time),
      CustomButton(
        onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => ViewDetails()),
          );
        },
        title: 'View Details',
        width: ResponsiveBox.getSize(context, 130),
        height: ResponsiveBox.getSize(context, 50),
      ),
    ],
  );
}

buildContainerImage(
  BuildContext context,
  String imageUrl,
  double size,
  bool isBorder,
) {
  return Container(
    height: ResponsiveBox.getSize(context, size),
    decoration: BoxDecoration(
      // color: Colors.grey,
      borderRadius: BorderRadius.circular(5),
      border: isBorder
          ? Border.all(color: AppThemeClass.primary, width: 1.0)
          : null,
      image: DecorationImage(
        image: AssetImage("assets/splash/splash.png"),
        fit: BoxFit.cover,
      ),
    ),
  );
}

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
        CustomText(
          text: text,
          maxLines: 1,
          fontSize: ResponsiveText.getSize(context, 12),
        ),
      ],
    ),
  );
}
