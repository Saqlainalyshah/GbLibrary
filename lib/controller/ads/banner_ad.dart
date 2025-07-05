import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/controller/providers/global_providers.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ads_ids.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});
  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}
class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdIds.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          setState(() => _isAdLoaded = false);
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? SizedBox(
      height: _bannerAd.size.height.toDouble(),
      width: _bannerAd.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd),
    )
        : Consumer(builder:(context,ref,child){
          final user=ref.watch(userProfileProvider);
          if(user!=null){
            return RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
              children: [
                TextSpan(
                  text: "Hello👋! ",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppThemeClass.darkText,
                    fontSize: ResponsiveText.getSize(context, 18)
                  )
                ),
                TextSpan(text: user.name,style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppThemeClass.primary,
                    fontSize: ResponsiveText.getSize(context, 20),
                ),

                )
              ]
            ));
            return CustomText(text: "Hello! ${user.name}",isBold: true,);
          }else{
            return SizedBox.shrink();
          }
    });
  }
}

