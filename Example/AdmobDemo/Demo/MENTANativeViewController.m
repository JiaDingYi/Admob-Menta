//
//  MENTANativeViewController.m
//  AdmobDemo_Example
//
//  Created by jdy on 2024/7/1.
//  Copyright © 2024 jdy. All rights reserved.
//

#import "MENTANativeViewController.h"
#import <MentaBaseGlobal/MentaBaseGlobal-umbrella.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MENTANativeViewController () <GADAdLoaderDelegate, GADNativeAdLoaderDelegate, GADNativeAdDelegate>

@property (nonatomic, strong) GADAdLoader *gadLoader;
@property (nonatomic, strong) GADNativeAd *nativeAd;
@property (nonatomic, strong) GADNativeAdView *nativeAdView;

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;

@end

@implementation MENTANativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLoad.frame = CGRectMake(100, 100, 100, 80);
    [self.btnLoad setTitle:@"load native" forState:UIControlStateNormal];
    [self.btnLoad addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLoad];
    
    self.btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnShow.frame = CGRectMake(100, 200, 100, 80);
    [self.btnShow setTitle:@"show native" forState:UIControlStateNormal];
    [self.btnShow addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnShow];
}

- (void)loadAd {
    [self.nativeAdView removeFromSuperview];
    self.gadLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-9454875840803246/1354093358"
                                       rootViewController:self
                                                  adTypes:@[ GADAdLoaderAdTypeNative ]
                                                  options:@[]];
    self.gadLoader.delegate = self;
    [self.gadLoader loadRequest:[GADRequest request]];
}

- (void)showAd {
    [self showWith:self.nativeAd];
}

- (void)showWith:(GADNativeAd *)nativeAd {
    GADNativeAdView *nativeAdView =
          [[NSBundle mainBundle] loadNibNamed:@"NativeAdView" owner:nil options:nil].firstObject;
    self.nativeAdView = nativeAdView;
    [self.view addSubview:self.nativeAdView];
    
    [self.nativeAdView mas_makeConstraints:^(MentaMASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.mas_equalTo(375);
        make.height.mas_equalTo(667);
    }];
    
    // Set the mediaContent on the GADMediaView to populate it with available
    // video/image asset.
    nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;

    // Populate the native ad view with the native ad assets.
    // The headline is guaranteed to be present in every native ad.
    ((UILabel *)nativeAdView.headlineView).text = nativeAd.headline;

    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    ((UILabel *)nativeAdView.bodyView).text = nativeAd.body;
    nativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;

    [((UIButton *)nativeAdView.callToActionView)setTitle:nativeAd.callToAction
                                                forState:UIControlStateNormal];
    nativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

    ((UIImageView *)nativeAdView.iconView).image = nativeAd.icon.image;
    nativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

    ((UIImageView *)nativeAdView.starRatingView).image = [self imageForStars:nativeAd.starRating];
    nativeAdView.starRatingView.hidden = nativeAd.starRating ? NO : YES;

    ((UILabel *)nativeAdView.storeView).text = nativeAd.store;
    nativeAdView.storeView.hidden = nativeAd.store ? NO : YES;

    ((UILabel *)nativeAdView.priceView).text = nativeAd.price;
    nativeAdView.priceView.hidden = nativeAd.price ? NO : YES;

    ((UILabel *)nativeAdView.advertiserView).text = nativeAd.advertiser;
    nativeAdView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;

    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    nativeAdView.callToActionView.userInteractionEnabled = NO;

    // Associate the native ad view with the native ad object. This is
    // required to make the ad clickable.
    nativeAdView.nativeAd = nativeAd;
}

/// Gets an image representing the number of stars. Returns nil if rating is
/// less than 3.5 stars.
- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
  double starRating = numberOfStars.doubleValue;
  if (starRating >= 5) {
    return [UIImage imageNamed:@"stars_5"];
  } else if (starRating >= 4.5) {
    return [UIImage imageNamed:@"stars_4_5"];
  } else if (starRating >= 4) {
    return [UIImage imageNamed:@"stars_4"];
  } else if (starRating >= 3.5) {
    return [UIImage imageNamed:@"stars_3_5"];
  } else {
    return nil;
  }
}

#pragma mark - GADAdLoaderDelegate

/// Called when adLoader fails to load an ad.
- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

/// Called after adLoader has finished loading.
- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader *)adLoader {
    NSLog(@"%s", __FUNCTION__);
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
    self.nativeAd = nativeAd;
    self.nativeAd.delegate = self;
}

#pragma mark - GADNativeAdDelegate

/// Called when an impression is recorded for an ad.
- (void)nativeAdDidRecordImpression:(nonnull GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
}

/// Called when a click is recorded for an ad.
- (void)nativeAdDidRecordClick:(nonnull GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
}

/// Called when a swipe gesture click is recorded for an ad.
- (void)nativeAdDidRecordSwipeGestureClick:(nonnull GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Click-Time Lifecycle Notifications

/// Called before presenting the user a full screen view in response to an ad action. Use this
/// opportunity to stop animations, time sensitive interactions, etc.
///
/// Normally the user looks at the ad, dismisses it, and control returns to your application with
/// the nativeAdDidDismissScreen: message. However, if the user hits the Home button or clicks on an
/// App Store link, your application will be backgrounded. The next method called will be the
/// applicationWillResignActive: of your UIApplicationDelegate object.
- (void)nativeAdWillPresentScreen:(nonnull GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
}

/// Called before dismissing a full screen view.
- (void)nativeAdWillDismissScreen:(nonnull GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
}

/// Called after dismissing a full screen view. Use this opportunity to restart anything you may
/// have stopped as part of nativeAdWillPresentScreen:.
- (void)nativeAdDidDismissScreen:(nonnull GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Mute This Ad

/// Used for Mute This Ad feature. Called after the native ad is muted. Only called for Google ads
/// and is not supported for mediated ads.
- (void)nativeAdIsMuted:(nonnull GADNativeAd *)nativeAd {
    NSLog(@"%s", __FUNCTION__);
}

@end
