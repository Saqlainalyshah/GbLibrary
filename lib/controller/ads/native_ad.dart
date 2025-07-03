import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_ids.dart';

final adIsLoadedProvider=StateProvider.autoDispose<bool>((ref)=>false);

class NativeAdWidget extends ConsumerStatefulWidget {
  const NativeAdWidget({super.key,required this.height,required this.container});
  final double height;
  final Widget container;/// due to this widget

  @override
  ConsumerState createState() => _NativeAdWidgetState();
}
class _NativeAdWidgetState extends ConsumerState<NativeAdWidget> {
  NativeAd? _nativeAd;
  //bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _nativeAd = NativeAd(
      adUnitId: AdIds.native,
      factoryId: 'nativeAd', // Must match what's defined in native code
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) => ref.read(adIsLoadedProvider.notifier).state=true,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
    // ref.invalidate(adIsLoadedProvider);

  }

  @override
  Widget build(BuildContext context) {

    return (ref.watch(adIsLoadedProvider) && _nativeAd!=null)
        ? Container(
      height: widget.height,
      padding: const EdgeInsets.all(8),
      child: AdWidget(ad: _nativeAd!),
    )
        : widget.container;
  }
}
