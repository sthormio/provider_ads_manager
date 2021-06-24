// import 'package:mopub_flutter/mopub.dart';
// import 'package:mopub_flutter/mopub_rewarded.dart';

// import '../../provider_ads.dart';
// import '../../shared/interfaces/i_ad_provider.dart';

// class MopubIOSAdProvider implements IAdProvider {
//   final ProvideUnitIds provideUnitIds;
//   bool _isAvailableToShowRewardVideo = false;
//   MoPubRewardedVideoAd _rewardedVideoAd;
//   Function(RewardedVideoAdResult rewardedResult, dynamic value)
//       _rewardedListener;

//   MopubIOSAdProvider(this.provideUnitIds);
//   @override
//   Future<bool> initProvider({Function readloadIfNeeded}) async {
//     try {
//       await MoPub.init(ProviderIds.mopubRewardedAd, testMode: true);
//       _isAvailableToShowRewardVideo = true;
//       return _isAvailableToShowRewardVideo;
//     } catch (e) {
//       _isAvailableToShowRewardVideo = false;
//       return _isAvailableToShowRewardVideo;
//     }
//   }

//   @override
//   Future<void> preLoadAd({Function isAlreadyLoaded}) async {
//     _rewardedVideoAd =
//         MoPubRewardedVideoAd(provideUnitIds.rewardId, _rewardedListener);

//     await _rewardedVideoAd.load();
//   }

//   @override
//   Future<void> providerAdEventListener({
//     Function click,
//     Function closeVideo,
//     Function grantRewarded,
//     Function errorLoadRewarded,
//     Function loadedRewarded,
//   }) async {
//     _rewardedListener = (RewardedVideoAdResult result, dynamic value) {
//       switch (result) {
//         case RewardedVideoAdResult.ERROR:
//           errorLoadRewarded();
//           _isAvailableToShowRewardVideo = false;
//           break;
//         case RewardedVideoAdResult.LOADED:
//           loadedRewarded();
//           _isAvailableToShowRewardVideo = true;
//           break;
//         case RewardedVideoAdResult.CLICKED:
//           click();
//           break;
//         case RewardedVideoAdResult.GRANT_REWARD:
//           grantRewarded();
//           break;
//         case RewardedVideoAdResult.VIDEO_DISPLAYED:
//           break;
//         case RewardedVideoAdResult.VIDEO_CLOSED:
//           closeVideo();
//           break;
//       }
//     };
//   }

//   @override
//   Future<void> showRewardedVideo(String userName) async {
//     if (_isAvailableToShowRewardVideo) {
//       await _rewardedVideoAd.show();
//     }
//   }

//   @override
//   void dispose() {}
// }
