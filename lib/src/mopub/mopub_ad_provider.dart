import 'dart:convert';
import 'package:flutter_mopub/flutter_mopub.dart';

import '../../shared/interfaces/i_ad_provider.dart';
import '../../shared/utils/provider_ids.dart';

class MopubAdProvider implements IAdProvider {
  final ProvideUnitIds provideUnitIds;
  bool _isAvailableToShowRewardVideo = false;
  int _currentIdEventListener;
  MopubAdProvider(this.provideUnitIds);

  @override
  Future<bool> initProvider({Function readloadIfNeeded}) async {
    final result =
        await FlutterMopub.initilize(adUnitId: provideUnitIds.rewardedId);
    return result;
  }

  @override
  Future<void> preLoadAd({Function isAlreadyLoaded}) async {
    int loadOutcome = await FlutterMopub.rewardedVideoAdInstance.load(
      adUnitId: provideUnitIds.rewardedId,
    );

    if (loadOutcome >= 0) {
      //successfully added Ad to loading queue
      print('ad is in loading queue');
    } else if (loadOutcome == -1) {
      _isAvailableToShowRewardVideo = true;
      if (isAlreadyLoaded != null) isAlreadyLoaded();
    } else {
      //failed to add Ad to loading queue
      print('failed to load ad : errCode = $loadOutcome');
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
    _currentIdEventListener =
        FlutterMopub.rewardedVideoAdInstance.addRewardedVideoListener(
      listener: (event, args) async {
        print(event);
        print(args['adUnitIds']); //for RewardedVideoAdEvent.SUCCESS
        print(args['adUnitId']); //for rest of events

        switch (event) {
          case RewardedVideoAdEvent.CLICKED:
            click();
            break;
          case RewardedVideoAdEvent.SUCCESS:
            _isAvailableToShowRewardVideo = true;
            loadedRewarded();
            break;
          case RewardedVideoAdEvent.CLOSED:
            closeVideo();
            // preLoadAd(isAlreadyLoaded: loadedRewarded);
            break;
          case RewardedVideoAdEvent.COMPLETED:
            grantRewarded();
            break;
          case RewardedVideoAdEvent.FAILURE:
            _isAvailableToShowRewardVideo = false;
            errorLoadRewarded();
            break;
          case RewardedVideoAdEvent.STARTED:
            break;
          case RewardedVideoAdEvent.PLAYBACKERROR:
            break;
        }
      },
    );
  }

  @override
  Future<void> showRewardedVideo(String userName) async {
    final customData = {
      "userName": userName,
    };

    if (_isAvailableToShowRewardVideo) {
      final result = await FlutterMopub.rewardedVideoAdInstance.show(
        adUnitId: provideUnitIds.rewardedId,
        customData: jsonEncode(customData),
      );

      if (result == -1) {
        print('Fail to load ads');
      }
    }
  }

  @override
  void dispose() {
    FlutterMopub.rewardedVideoAdInstance
        .removeRewardedVideoListener(_currentIdEventListener);
  }
}
