import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_ids.dart';

class UserActions {
  final int viewPosts;
  final int countMessages;
  final int numberOfPosts;
  final int numberOfProfileUpdate;
  final DateTime? lastAdShownTime;

  UserActions({
    required this.viewPosts,
    required this.countMessages,
    required this.numberOfPosts,
    required this.numberOfProfileUpdate,
    this.lastAdShownTime,
  });

  UserActions copyWith({
    int? viewPosts,
    int? countMessages,
    int? numberOfPosts,
    int? numberOfProfileUpdate,
    DateTime? lastAdShownTime,
  }) =>
      UserActions(
        viewPosts: viewPosts ?? this.viewPosts,
        countMessages: countMessages ?? this.countMessages,
        numberOfPosts: numberOfPosts ?? this.numberOfPosts,
        numberOfProfileUpdate:
        numberOfProfileUpdate ?? this.numberOfProfileUpdate,
        lastAdShownTime: lastAdShownTime ?? this.lastAdShownTime,
      );
}

class UserActionsNotifier extends StateNotifier<UserActions> {
  UserActionsNotifier() :super(UserActions(
    viewPosts: 0, countMessages: 0, numberOfPosts: 0, numberOfProfileUpdate: 0,
  ));

  void updateViewPosts(int count) {
    state = state.copyWith(viewPosts: count);
  }

  void updateCountMessages(int count) {
    state = state.copyWith(countMessages: count);
  }

  void updateNumberOfPosts(int count) {
    state = state.copyWith(numberOfPosts: count);
  }

  void updateNumberOfProfileUpdate(int count) {
    state = state.copyWith(numberOfProfileUpdate: count);
  }
  void updateLastAdShownTime(DateTime timestamp) {
    state = state.copyWith(lastAdShownTime: timestamp);
  }
  void clearViewPosts() {
    state = state.copyWith(viewPosts: 0);
  }

  void clearCountMessages() {
    state = state.copyWith(countMessages: 0);
  }

  void clearNumberOfPosts() {
    state = state.copyWith(numberOfPosts: 0);
  }

  void clearNumberOfProfileUpdate() {
    state = state.copyWith(numberOfProfileUpdate: 0);
  }
  bool get canShowAd {
    final cooldown = Duration(hours: 1);
    final lastShown = state.lastAdShownTime;

    return lastShown == null ||
        DateTime.now().difference(lastShown) > cooldown;
  }
}

final userActionsTracker = StateNotifierProvider<UserActionsNotifier, UserActions>((ref)=>UserActionsNotifier());




class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdIds.interstitial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
              _interstitialAd?.setImmersiveMode(true);

          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }
  void showInterstitialAd(VoidCallback onAdClosed) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        onAdClosed();
        print("=====================================");
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        onAdClosed();
       // createInterstitialAd();
      }
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }
  InterstitialAd? get interstitialAd => _interstitialAd;
  /// Dispose interstitial ad resources
  void disposeInterstitialAds() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

}

