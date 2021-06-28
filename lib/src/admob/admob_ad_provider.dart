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
    bool isLoaded = await _myRewarded.isLoaded();

    if (isLoaded) {
      await _addRewardedInstance();
      await _myRewarded.load();

      isAlreadyLoaded();
    } else {
      await _myRewarded.load();
    }
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
      onAdFailedToLoad: (Ad ad, LoadAdError error) async {
        print(ad);
        print(error);
        _isAvailableToShowRewardVideo = false;
        errorLoadRewarded();
      },
    );

    _addRewardedInstance();
  }

  @override
  Future<void> showRewardedVideo(String userName) async {
    if (_isAvailableToShowRewardVideo) {
      await _myRewarded.show();
    }
  }

  Future<void> _addRewardedInstance() async {
    _myRewarded = RewardedAd(
      adUnitId: provideUnitIds.rewardedId,
      request: AdRequest(),
      listener: _rewardedListener,
    );
  }

  @override
  void dispose() {
    _myRewarded?.dispose();
  }
}
