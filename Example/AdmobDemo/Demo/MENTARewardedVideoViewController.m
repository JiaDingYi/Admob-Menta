//
//  MENTARewardedVideoViewController.m
//  AdmobDemo_Example
//
//  Created by jdy on 2024/7/1.
//  Copyright © 2024 jdy. All rights reserved.
//

#import "MENTARewardedVideoViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MENTARewardedVideoViewController () <GADFullScreenContentDelegate>

@property(nonatomic, strong) GADRewardedAd *rewardedAd;

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;

@end

@implementation MENTARewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLoad.frame = CGRectMake(100, 100, 150, 80);
    [self.btnLoad setTitle:@"load rewarded" forState:UIControlStateNormal];
    [self.btnLoad addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLoad];
    
    self.btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnShow.frame = CGRectMake(100, 200, 150, 80);
    [self.btnShow setTitle:@"show rewarded" forState:UIControlStateNormal];
    [self.btnShow addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnShow];
}

- (void)loadAd {
    GADRequest *request = [GADRequest request];
    [GADRewardedAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/1712485313"
                            request:request
                  completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
            return;
        }
        self.rewardedAd = ad;
        self.rewardedAd.fullScreenContentDelegate = self;
        NSLog(@"Rewarded ad loaded.");
    }];
}

- (void)showAd {
    if (self.rewardedAd) {
        // The UIViewController parameter is nullable.
        [self.rewardedAd presentFromRootViewController:nil
                              userDidEarnRewardHandler:^{
            GADAdReward *reward = self.rewardedAd.adReward;
            NSLog(@"Reward the user! %@", reward);
        }];
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
