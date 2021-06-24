/// Instantiate class to receive ad actions
///
/// ```dart
/// RewardedListener(
///   click: (){}
///   closeVideo: (){}
///   grantRewarded: (){}
///   errorLoadRewarded: (){}
///   loadedRewarded: (){}
/// )
/// ```
class RewardedListener {
  Function() click;
  Function() closeVideo;
  Function() grantRewarded;
  Function() errorLoadRewarded;
  Function() loadedRewarded;

  RewardedListener({
    this.click,
    this.closeVideo,
    this.grantRewarded,
    this.errorLoadRewarded,
    this.loadedRewarded,
  });
}
