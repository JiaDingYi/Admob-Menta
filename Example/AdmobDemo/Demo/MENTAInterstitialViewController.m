//
//  MENTAInterstitialViewController.m
//  AdmobDemo_Example
//
//  Created by jdy on 2024/7/1.
//  Copyright © 2024 jdy. All rights reserved.
//

#import "MENTAInterstitialViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MENTAInterstitialViewController () <GADFullScreenContentDelegate>

@property(nonatomic, strong) GADInterstitialAd *interstitial;

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;


@end

@implementation MENTAInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLoad.frame = CGRectMake(100, 100, 150, 80);
    [self.btnLoad setTitle:@"load interstitial" forState:UIControlStateNormal];
    [self.btnLoad addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLoad];
    
    self.btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnShow.frame = CGRectMake(100, 200, 150, 80);
    [self.btnShow setTitle:@"show interstitial" forState:UIControlStateNormal];
    [self.btnShow addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnShow];
}

- (void)loadAd {
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-9454875840803246/5674065015"
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
    }];
}

- (void)showAd {
    if (self.interstitial) {
      // The UIViewController parameter is nullable.
      [self.interstitial presentFromRootViewController:self];
    } else {
      NSLog(@"Ad wasn't ready");
    }
}

#pragma mark - GADFullScreenContentDelegate

/// Tells the delegate that an impression has been recorded for the ad.
- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%s", __FUNCTION__);
}

/// Tells the delegate that a click has been recorded for the ad.
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%s", __FUNCTION__);
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%s", __FUNCTION__);
}

/// Tells the delegate that the ad will dismiss full screen content.
- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%s", __FUNCTION__);
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%s", __FUNCTION__);
}

@end
