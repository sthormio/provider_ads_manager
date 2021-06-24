abstract class IAdProvider {
  Future<bool> initProvider({
    Function readloadIfNeeded,
  });
  Future<void> providerAdEventListener({
    Function click,
    Function closeVideo,
    Function grantRewarded,
    Function errorLoadRewarded,
    Function loadedRewarded,
  });
  Future<void> preLoadAd({Function isAlreadyLoaded});

  Future<void> showRewardedVideo(String userName);

  void dispose();
}
