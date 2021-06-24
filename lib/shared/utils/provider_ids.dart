import 'dart:io';

/// Provide your ad unit ids from ad provider to load ads.
///
///Example: We provide for you test unit ids for you test your integration on debug environment
/// ```dart
/// ProvideUnitIds(rewardId: ProviderIds.mopubRewardedAd)
/// ```
class ProvideUnitIds {
  final String rewardedId;
  final String bannerId;
  final String intertitalId;

  ProvideUnitIds({
    this.rewardedId,
    this.bannerId,
    this.intertitalId,
  });
}

/// This class provide for you test unit ids
abstract class ProviderIds {
  /// provide a unic rewarded ad unit for both platform Android and iOS
  static String get mopubRewardedAd => '920b6145fb1546cf8b5cf2ac34638bb7';

  /// provide rewarded ad unit by platform Android or iOS
  static String get adMobRewardedAd => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';
}
