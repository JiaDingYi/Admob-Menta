//
//  MENTABannerViewController.m
//  AdmobDemo_Example
//
//  Created by jdy on 2024/6/28.
//  Copyright © 2024 jdy. All rights reserved.
//

#import "MENTABannerViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MENTABannerViewController () <GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic, strong) UIButton *btnLoad;
@property (nonatomic, strong) UIButton *btnShow;

@end

@implementation MENTABannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnLoad = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLoad.frame = CGRectMake(100, 100, 100, 80);
    [self.btnLoad setTitle:@"load banner" forState:UIControlStateNormal];
    [self.btnLoad addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnLoad];
    
    self.btnShow = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnShow.frame = CGRectMake(100, 200, 100, 80);
    [self.btnShow setTitle:@"show banner" forState:UIControlStateNormal];
    [self.btnShow addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnShow];
}

- (void)loadAd {
    // Here safe area is taken into account, hence the view frame is used after the
    // view has been laid out.
    CGRect frame = UIEdgeInsetsInsetRect(self.view.frame, self.view.safeAreaInsets);
    CGFloat viewWidth = frame.size.width;

    // Here the current interface orientation is used. If the ad is being preloaded
    // for a future orientation change or different orientation, the function for the
    // relevant orientation should be used.
    GADAdSize adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth);
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc] initWithAdSize:adaptiveSize];
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2435281174";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;

    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)showAd {
    [self addBannerViewToView:self.bannerView];
}

- (void)addBannerViewToView:(UIView *)bannerView {
  bannerView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:bannerView];
  [self.view addConstraints:@[
    [NSLayoutConstraint constraintWithItem:bannerView
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.view.safeAreaLayoutGuide
                               attribute:NSLayoutAttributeBottom
                              multiplier:1
                                constant:0],
    [NSLayoutConstraint constraintWithItem:bannerView
                               attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                               attribute:NSLayoutAttributeCenterX
                              multiplier:1
                                constant:0]
                                ]];
}

#pragma mark - GADBannerViewDelegate

-   (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd");
}

-   (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

-   (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
}

-   (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillPresentScreen");
}

-   (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillDismissScreen");
}

-   (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidDismissScreen");
}
  


@end
