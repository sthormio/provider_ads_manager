# Provider Ads Manager

Provider ads manager is a package open source that have goal of the became the management of the ads inside your flutter app more easy. Whit this package you will can initialize and manager ad providers using the same methods and parameters.

At this moment the provider ads manager have two ad providers implemented (Mopub and AdMob) but the goal is implements others too. The type of the ad supported at this moment is rewarded video ad.

### AdMob prerequisites

- Flutter 1.22.0 or higher
- Android
  - Android Studio 3.2 or higher
  - Target Android API level 19 or higher
  - Set `compileSdkVersion` to 28 or higher
  - Android Gradle Plugin 4.1 or higher (this is the version supported by Flutter out of the box)
- Ios
  - Latest version of Xcode with [enabled command-line tools](https://flutter.dev/docs/get-started/install/macos#install-xcode).
- Recommended: [Create an AdMob account](https://support.google.com/admob/answer/2784575) and [register an Android and/or iOS app](https://support.google.com/admob/answer/2773509)

iOS:

- add this in your info.plist

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>cstr6suwn9.skadnetwork</string>
    </dict>
  </array>
```

- The GADApplicationIdentifier listed is to dev environment, replace by your of the production

See more information about this [here](https://developers.google.com/admob/ios/quick-start#update%5C_your%5C_infoplist)

Android:

- add this in your AndroidManifest.xml ⇒ android/app/src/main/AndroidManifest.xml

```xml
<manifest>
    <application>
        <!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

See more information about this [here](https://developers.google.com/admob/android/quick-start#update_your_androidmanifestxml)

### Mopub prerequisites

iOS

- Change minimum platform target to iOS 10.0
  - Open ios/Runner.xcworkspace in xcode
  - In Runner target -> Deployment Info -> change Target to iOS 10.0
- Configure App Transport Security (ATS) : Add this key value to your ios/Runner/info.plist

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsForMedia</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```

See more information about this [here](https://developers.mopub.com/publishers/ios/integrate/#step-5-configure-app-transport-security-ats)

Android

- Change minimum sdk to 19 :
  - Open app level build.gradle file (android/app/build.gradle)
  - In android -> defaultConfig scope change this line

```
defaultConfig {
        .
        .
        .
        minSdkVersion 19//default is 16
        .
        .
        .
        multiDexEnabledtrue//add this line if you have build errors
    }

```

- In dependencies scope add this line (to resolve conflict between packages. apply only if you face build errors)

```xml
dependencies {
        .
        .
        .
        implementation 'com.google.guava:listenablefuture:9999.0-empty-to-avoid-conflict-with-guava' *//add this line*
        .
        .
        .
    }
```

### How to initialize the provider?

- With Mopub

```dart
providerAd = ProviderAd();
await providerAd.initMopubAdProvider(
  mopubRewardedUnitAds: ProvideUnitIds(
    rewardedId: ProviderIds.mopubRewardedAd, // provide your production id
   ),
    rewardedListener: RewardedListener(
	    loadedRewarded: () {},
      closeVideo: () {},
      grantRewarded: () {},
      errorLoadRewarded: () {},
      click: () {},
    ),
 );
```

- With AdMob

```dart
providerAd = ProviderAd();
await providerAd.initAdMobAdProvider(
  adMobRewardedUnitAds: ProvideUnitIds(
    rewardedId: ProviderIds.adMobRewardedAd, // provide your production id
   ),
    rewardedListener: RewardedListener(
	    loadedRewarded: () {},
      closeVideo: () {},
      grantRewarded: () {},
      errorLoadRewarded: () {},
      click: () {},
    ),
 );
```

- Other way to initialize all provider

  Only pass the provider unit ids call the method *initAllProviders* then it will initialize

```dart
providerAd.initAllProviders(
   adMobUnitAds: ProvideUnitIds(
     rewardedId: ProviderIds.adMobRewardedAd,
   ),
   mopubUnitAds: ProvideUnitIds(
     rewardedId: ProviderIds.mopubRewardedAd,
   ),
);
```

- Using listeners on this way

```dart
providerAd.rewardedEventListener(
    adMobRewardedListener: RewardedListener(
      click: () {},
      loadedRewarded: () {},
      closeVideo: () {},
      grantRewarded: () {},
	    errorLoadRewarded: () {},
   ),
		mopubRewardedListener: RewardedListener(
	    click: () {},
      loadedRewarded: () {},
      closeVideo: () {},
      grantRewarded: () {},
      errorLoadRewarded: () {},
   ),
 );
```

### How to load a Rewarded Ad?

Call the method *preLoadAd* to load the rewarded ad

```dart
providerAd.preLoadAd(
   adProvider: AdProvider.mopub, // pass AdProvider.mopub or AdProvider.admob
   isAlreadyLoaded: () {
	   print("This ad is already loaded");
  },
);
```

Note: this method must be call before show the ad.

### How to show a Rewarded Ad?

Call the method *showRewardedVideo* to show the ad that  is loaded

```dart
providerAd.showRewardedVideo(adProvider: AdProvider.mopub); // pass AdProvider.mopub or AdProvider.admob
```

### Important

Call the dispose to clean the listeners of the memorie

```dart
providerAd.dispose();
```

## **How to contribute?**

You can clone this project and send a pull request with your improvements or open issues
