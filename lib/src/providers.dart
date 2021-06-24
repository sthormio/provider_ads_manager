import 'package:flutter/material.dart';

import '../shared/errors/ad_provider_error.dart';
import '../shared/interfaces/i_ad_provider.dart';
import '../shared/provider/rewarded/rewarded_listener.dart';
import '../shared/unums/ad_providers_enum.dart';
import '../shared/utils/provider_ids.dart';
import 'admob/admob_ad_provider.dart';
import 'mopub/mopub_ad_provider.dart';

class ProviderAd extends ChangeNotifier {
  IAdProvider _mopubAdProvider;
  IAdProvider _admobAdProvider;
  bool _mopubIsAvailable = false;
  bool _adMobIsAvailable = false;

  bool get adMobIsAvailable => _adMobIsAvailable;
  bool get mopubIsAvailable => _mopubIsAvailable;

  /// Initialize The Mopub Ad provider only
  ///
  /// This function return true if this ad provider is available
  ///
  /// Example:
  ///
  /// ```dart
  /// await initMopubAdProvider(
  ///   mopubRewardedUnitAds: ProvideUnitIds(rewardId: ProviderIds.mopubRewardedAd)
  ///   rewardedListener: RewardedListener(
  ///     click: () {},
  ///     loadedRewarded: () {},
  ///     closeVideo: () {},
  ///     grantRewarded: () {},
  ///     errorLoadRewarded: () {}
  ///   )
  /// )
  /// ```
  Future<bool> initMopubAdProvider({
    @required ProvideUnitIds mopubRewardedUnitAds,
    @required RewardedListener rewardedListener,
  }) async {
    try {
      await initAllProviders(
        mopubUnitAds: mopubRewardedUnitAds,
      );

      await _mopubAdProvider?.providerAdEventListener(
        click: rewardedListener.click,
        closeVideo: rewardedListener.closeVideo,
        grantRewarded: rewardedListener.grantRewarded,
        errorLoadRewarded: rewardedListener.errorLoadRewarded,
        loadedRewarded: rewardedListener.loadedRewarded,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Initialize The AdMob Ad provider only
  ///
  /// This function return true if this ad provider is available
  ///
  /// Example:
  ///
  /// ```dart
  /// await initMopubAdProvider(
  ///   adMobUnitAds: ProvideUnitIds(rewardId: ProviderIds.admobRewardedAd)
  ///     rewardedListener: RewardedListener(
  ///     click: () {},
  ///     loadedRewarded: () {},
  ///     closeVideo: () {},
  ///     grantRewarded: () {},
  ///     errorLoadRewarded: () {}
  ///   )
  /// )
  /// ```
  Future<bool> initAdMobAdProvider({
    @required ProvideUnitIds adMobRewardedUnitAds,
    @required RewardedListener rewardedListener,
  }) async {
    try {
      await initAllProviders(
        adMobUnitAds: adMobRewardedUnitAds,
      );

      _admobAdProvider?.providerAdEventListener(
        click: rewardedListener.click,
        closeVideo: rewardedListener.closeVideo,
        grantRewarded: rewardedListener.grantRewarded,
        errorLoadRewarded: rewardedListener.errorLoadRewarded,
        loadedRewarded: rewardedListener.loadedRewarded,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Initalize all ad providers
  ///
  /// ```dart
  /// await initAllProviders(
  ///   mopubUnitAds: ProvideUnitIds(rewardId: ProviderIds.mopubRewardedAd)
  ///   adMobUnitAds: ProvideUnitIds(rewardId: ProviderIds.admobRewardedAd)
  /// )
  /// ```
  /// Call the method reloadProviders if you want to restart the ad providers
  Future<void> initAllProviders({
    ProvideUnitIds mopubUnitAds,
    ProvideUnitIds adMobUnitAds,
    Function reloadProviders,
  }) async {
    if (mopubUnitAds != null) {
      _mopubAdProvider = MopubAdProvider(mopubUnitAds);
    }
    if (adMobUnitAds != null) {
      _admobAdProvider = AdmobAdProvider(adMobUnitAds);
    }

    _throwErrorIfAdProviderNotInitialized();

    if (_mopubAdProvider != null) {
      _mopubIsAvailable = await _mopubAdProvider.initProvider();
      if (_mopubIsAvailable) debugPrint('-- MopubAdProvider initialized');
    }
    if (_admobAdProvider != null) {
      _adMobIsAvailable = await _admobAdProvider.initProvider();
      if (_adMobIsAvailable) debugPrint('-- AdMobAdProvider initialized');
    }
  }

  /// Call this method to load a Ad before to show your add
  ///
  /// Choose what the provider that you want to load the Ad passing
  /// the parameter adProvider
  ///
  /// ```dart
  ///await preLoadAd(adProvider: AdProvider.mopub)
  /// ```
  Future<void> preLoadAd({
    Function isAlreadyLoaded,
    AdProvider adProvider = AdProvider.mopub,
  }) async {
    _throwErrorIfAdProviderNotInitialized();

    switch (adProvider) {
      case AdProvider.mopub:
        _mopubAdProvider?.preLoadAd();
        break;
      case AdProvider.admob:
        _admobAdProvider?.preLoadAd();
        break;
    }
  }

  /// Listener the actions that happen with the ad provider that running at the moment
  ///
  /// If you are using two or more ad providers at same time the listener return actions based
  /// on the current ad in action at moment
  Future<void> rewardedEventListener({
    RewardedListener mopubRewardedListener,
    RewardedListener adMobRewardedListener,
  }) async {
    _throwErrorIfAdProviderNotInitialized();

    if (mopubRewardedListener != null && _mopubAdProvider == null) {
      throw AdProviderError(
        'Initalize Mopub Ad Provider first to use this listener',
      );
    }
    if (adMobRewardedListener != null && _admobAdProvider == null) {
      throw AdProviderError(
        'Initalize AdMob Ad Provider first to use this listener',
      );
    }

    if (mopubRewardedListener != null) {
      _mopubAdProvider?.providerAdEventListener(
        click: mopubRewardedListener.click,
        closeVideo: mopubRewardedListener.closeVideo,
        grantRewarded: mopubRewardedListener.grantRewarded,
        errorLoadRewarded: mopubRewardedListener.errorLoadRewarded,
        loadedRewarded: mopubRewardedListener.loadedRewarded,
      );
    }

    if (adMobRewardedListener != null) {
      _admobAdProvider?.providerAdEventListener(
        click: adMobRewardedListener.click,
        closeVideo: adMobRewardedListener.closeVideo,
        grantRewarded: adMobRewardedListener.grantRewarded,
        errorLoadRewarded: adMobRewardedListener.errorLoadRewarded,
        loadedRewarded: adMobRewardedListener.loadedRewarded,
      );
    }
  }

  /// Call this method to show an rewarded video on screen if there are a ad loaded
  ///
  /// Pass witch ad provider that you want to show rewarded ad
  ///
  /// ```dart
  /// await showRewardedVideo(adProvider: AdProvider.mopub)
  /// await showRewardedVideo(adProvider: AdProvider.admob)
  /// ```
  Future<void> showRewardedVideo({
    String userName,
    AdProvider adProvider = AdProvider.mopub,
  }) async {
    _throwErrorIfAdProviderNotInitialized();
    switch (adProvider) {
      case AdProvider.mopub:
        await _mopubAdProvider?.showRewardedVideo(userName);
        break;
      case AdProvider.admob:
        await _admobAdProvider?.showRewardedVideo(userName);
        break;
    }
  }

  void _throwErrorIfAdProviderNotInitialized() {
    if ((_mopubAdProvider == null) && (_admobAdProvider == null)) {
      throw AdProviderError(
        'You must be pass least one AdUnitId for receive the instance of the your Ad Provider',
      );
    }
    return;
  }

  @override
  void dispose() {
    _mopubAdProvider?.dispose();
    _admobAdProvider?.dispose();
    super.dispose();
  }
}
