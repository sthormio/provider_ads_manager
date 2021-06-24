import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_ads/provider_ads.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProviderAd providerAd;
  bool isLoadedAdMopub = false;
  bool isLoadedAdMob = false;
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    providerAd = ProviderAd();
    await providerAd.initMopubAdProvider(
      mopubRewardedUnitAds: ProvideUnitIds(
        rewardedId: ProviderIds.mopubRewardedAd,
      ),
      rewardedListener: RewardedListener(
        loadedRewarded: () {
          setState(() {
            isLoadedAdMopub = true;
          });
        },
        closeVideo: () {
          setState(() {
            isLoadedAdMopub = false;
          });
        },
        grantRewarded: () {},
      ),
    );

    await providerAd.initAdMobAdProvider(
      adMobRewardedUnitAds: ProvideUnitIds(
        rewardedId: ProviderIds.adMobRewardedAd,
      ),
      rewardedListener: RewardedListener(
        loadedRewarded: () {
          setState(() {
            isLoadedAdMob = true;
          });
        },
        closeVideo: () {
          setState(() {
            isLoadedAdMob = false;
          });
        },
        grantRewarded: () {},
      ),
    );

    // providerAd.rewardedEventListener(
    //   // mopubRewardedListener: RewardedListener(
    //   //   loadedRewarded: () {
    //   //     setState(() {
    //   //       isLoadedAdMopub = true;
    //   //     });
    //   //   },
    //   //   closeVideo: () {
    //   //     setState(() {
    //   //       isLoadedAdMopub = false;
    //   //     });
    //   //   },
    //   //   grantRewarded: () {},
    //   // ),
    //   adMobRewardedListener: RewardedListener(
    //     loadedRewarded: () {
    //       setState(() {
    //         isLoadedAdMob = true;
    //       });
    //     },
    //     closeVideo: () {
    //       setState(() {
    //         isLoadedAdMob = false;
    //       });
    //     },
    //     grantRewarded: () {},
    //   ),
    // );
  }

  @override
  void dispose() {
    providerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Ad Providers'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              child: Text(
                isLoadedAdMopub
                    ? 'Show Rewarded Mopub'
                    : 'Load Rewarded Mopub Ad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.white,
                ),
              ),
              onPressed: () {
                if (isLoadedAdMopub) {
                  providerAd.showRewardedVideo(adProvider: AdProvider.mopub);
                } else {
                  providerAd.preLoadAd(adProvider: AdProvider.mopub);
                }
              },
            ),
            SizedBox(height: 20),
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              child: Text(
                isLoadedAdMob
                    ? 'Show Rewarded adMob'
                    : 'Load Rewarded AdMob Ad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.white,
                ),
              ),
              onPressed: () {
                if (isLoadedAdMob) {
                  providerAd.showRewardedVideo(adProvider: AdProvider.admob);
                } else {
                  providerAd.preLoadAd(adProvider: AdProvider.admob);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
