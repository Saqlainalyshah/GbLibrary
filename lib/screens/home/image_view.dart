import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../utils/fontsize/app_theme/theme.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.url});
final String url;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.darkText,
          appBar: AppBar(
            title: Text("Image View",style: TextStyle(color: AppThemeClass.whiteText),),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios,color: AppThemeClass.whiteText,)),
          ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Container(color: Colors.black,
        width: double.infinity,
        child: Center(
          child: CachedNetworkImage(fit: BoxFit.fill, imageUrl: url,
            width: double.infinity,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    //margin: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: AppThemeClass.primary
                    ),
                  ),
                ),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
          ),
        ),
        ),
      ),
    ));
  }
}
