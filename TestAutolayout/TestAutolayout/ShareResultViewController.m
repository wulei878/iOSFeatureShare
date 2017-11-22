//
//  ShareResultViewController.m
//  TestAutolayout
//
//  Created by Owen on 2017/11/22.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "ShareResultViewController.h"
#import <AVKit/AVKit.h>
#import <Photos/Photos.h>

@interface ShareResultViewController ()
@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) AVPlayer *player;
@end

@implementation ShareResultViewController
+ (ShareResultViewController *)getInstance {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShareResultViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isImageAttachment = YES;
    [self updateUI];
}

- (void)updateUI {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.io.fanlv.potatso"];
    NSURL *url =  [NSURL URLWithString:[userDefaults objectForKey:self.isImageAttachment ? @"com.owen.iosfeature.shareextension.shareImage" : @"com.owen.iosfeature.shareextension.shareVideo"]];
    if (self.isImageAttachment) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.includeHiddenAssets = YES;
        PHFetchResult *asset = [PHAsset fetchAssetsWithOptions:options];
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            CGImageRef iref = [rep fullScreenImage];
            self.imageView.image = [UIImage imageWithCGImage:iref];
        } failureBlock:nil];
        [self.player pause];
    } else {
        AVPlayer *player = [AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        [self.playerContainer.layer addSublayer:playerLayer];
        playerLayer.frame = self.playerContainer.bounds;
        [player play];
        self.player = player;
    }
    self.playerContainer.hidden = self.isImageAttachment;
    self.imageView.hidden = !self.playerContainer.hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
