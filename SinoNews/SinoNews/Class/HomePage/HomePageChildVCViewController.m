//
//  HomePageChildVCViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageChildVCViewController.h"

#import "HeadBannerView.h"

@interface HomePageChildVCViewController ()

@end

@implementation HomePageChildVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testBanner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//测试轮播图
-(void)testBanner
{
    if (self.index != 0) {
        return;
    }
    
    HeadBannerView *headView = [HeadBannerView new];
    
    [self.view addSubview:headView];
    
    headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(ScreenW * 9 / 16)
    ;
    [headView updateLayout];
    
    NSMutableArray *imgs = [NSMutableArray new];
    for (int i = 0; i < 4; i ++) {
        NSString *imgStr = [NSString stringWithFormat:@"banner%d",i];
        [imgs addObject:imgStr];
    }
    [headView setupUIWithImageUrls:imgs];
    
    headView.selectBlock = ^(NSInteger index) {
        
    };
}



@end
