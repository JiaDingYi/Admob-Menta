//
//  GADMentaNativeCustomEvent.m
//  GoogleMobileAdsMediationMenta
//
//  Created by jdy on 2024/6/28.
//

#import "GADMentaNativeCustomEvent.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <MentaMediationGlobal/MentaMediationGlobal-umbrella.h>

@interface GADMentaNativeCustomEvent ()

@property (nonatomic, strong) MentaMediationNativeSelfRender *nativeAd;
@property (nonatomic, copy) GADMediationNativeLoadCompletionHandler loadCompletionHandler;
@property (nonatomic, weak) id<GADMediationNativeAdEventDelegate> adEventDelegate;

@end

@implementation GADMentaNativeCustomEvent

+ (void)setUpWithConfiguration:(nonnull GADMediationServerConfiguration *)configuration
             completionHandler:(nonnull GADMediationAdapterSetUpCompletionBlock)completionHandler {
    // This is where you initialize the SDK that this custom event is built
    // for. Upon finishing the SDK initialization, call the completion handler
    // with success.
    // {"appID":"A0004","appKey":"510cc7cdaabbe7cb975e6f2538bc1e9d","placementID" : "P0026"}
    GADMediationCredentials *credential = configuration.credentials.firstObject;
    NSLog(@"%@", credential.settings);
    NSLog(@"%ld", credential.format);
    
    NSString *jsonStr = credential.settings[@"parameter"];
    NSDictionary *jsonDic = [self parseJsonParameters:jsonStr];
    
    MentaAdSDK *menta = [MentaAdSDK shared];
    if (menta.isInitialized) {
        return;
    }
    [menta setLogLevel:kMentaLogLevelError];
    
    [menta startWithAppID:jsonDic[@"appID"] appKey:jsonDic[@"appKey"] finishBlock:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [[MentaLogger stdLogger] info:@"menta sdk init success"];
        } else {
            [[MentaLogger stdLogger] info:[NSString stringWithFormat:@"menta sdk init failure, %@", error.localizedDescription]];
        }
    }];
    completionHandler(nil);
}

+ (GADVersionNumber)adSDKVersion {
    NSArray *versionComponents = [[MentaAdSDK shared].sdkVersion componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count >= 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (GADVersionNumber)adapterVersion {
    NSString *customEventVersion = [NSString stringWithFormat:@"%@.0", [MentaAdSDK shared].sdkVersion];
    NSArray *versionComponents = [customEventVersion componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 4) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue] * 100 + [versionComponents[3] integerValue];
    }
    return version;
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
    
}

#pragma mark - private

+ (NSDictionary *)parseJsonParameters:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        return nil;
    } else {
        return jsonDict.copy;
    }
}

@end
