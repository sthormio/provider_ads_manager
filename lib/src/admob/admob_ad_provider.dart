import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../shared/interfaces/i_ad_provider.dart';
import '../../shared/utils/provider_ids.dart';

class AdmobAdProvider implements IAdProvider {
  final ProvideUnitIds provideUnitIds;
  AdmobAdProvider(this.provideUnitIds);

  bool _isAvailableToShowRewardVideo = false;
  AdListener _rewardedListener;
  RewardedAd _myRewarded;

  @override
  Future<bool> initProvider({
    Function readloadIfNeeded,
  }) async {
    final result = await MobileAds.instance.initialize();

    if (Platform.isIOS) {
      if (result.adapterStatuses['GADMobileAds'].state ==
          AdapterInitializationState.ready) {
        return true;
      } else {
        return false;
      }
    } else {
      if (result
              .adapterStatuses['com.google.android.gms.ads.MobileAds'].state ==
          AdapterInitializationState.ready) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Future<void> preLoadAd({Function isAlreadyLoaded}) async {
    await _myRewarded?.dispose();

    _myRewarded = RewardedAd(
      adUnitId: provideUnitIds.rewardedId,
      request: AdRequest(),
      listener: _rewardedListener,
    );

    await _myRewarded.load();
  }

  @override
  Future<void> providerAdEventListener({
    Function click,
    Function closeVideo,
    Function grantRewarded,
    Function errorLoadRewarded,
    Function loadedRewarded,
  }) async {
    _rewardedListener = AdListener(
      onNativeAdClicked: (ad) {
        click();
      },
      onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
        print(reward.type);
        print(reward.amount);
        grantRewarded();
      },
      onAdLoaded: (Ad ad) {
        _isAvailableToShowRewardVideo = true;
        loadedRewarded();
      },
      onAdClosed: (Ad ad) {
        closeVideo();
        print(ad.adUnitId);
        print(ad.hashCode);
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print(ad);
        print(error);
        ad.dispose();
        _isAvailableToShowRewardVideo = false;
      },
    );
  }

  @override
  Future<void> showRewardedVideo(String userName) async {
    if (_isAvailableToShowRewardVideo) {
      await _myRewarded.show();
    }
  }

  @override
  void dispose() {
    _myRewarded?.dispose();
  }
}
