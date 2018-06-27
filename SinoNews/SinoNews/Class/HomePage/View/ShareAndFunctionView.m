//
//  ShareAndFunctionView.m
//  SinoNews
//
//  Created by Michael on 2018/6/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ShareAndFunctionView.h"
#import "FontAndNightModeView.h"

@interface ShareAndFunctionView ()

@property(nonatomic, strong) NSMutableArray *shareArray;
@end

@implementation ShareAndFunctionView
static bool isCollect = NO;
- (NSMutableArray *)shareArray
{
    if (!_shareArray) {
        _shareArray = [NSMutableArray array];
        
        [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_qqZone") title:@"QQ空间" action:^(IFMShareItem *item) {
            LRToast(@"点击了QQ空间");
        }]];
        
        [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_qq") title:@"QQ好友" action:^(IFMShareItem *item) {
            LRToast(@"点击了QQ好友");
        }]];
        
        [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_wechat") title:@"微信好友" action:^(IFMShareItem *item) {
            LRToast(@"点击了微信好友");
        }]];
        
        [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_wechatFriend") title:@"微信朋友圈" action:^(IFMShareItem *item) {
            LRToast(@"点击了微信朋友圈");
        }]];
        
        [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_sina") title:@"新浪微博" action:^(IFMShareItem *item) {
            LRToast(@"点击了新浪微博");
        }]];
        
        [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_email") title:@"邮件分享" action:^(IFMShareItem *item) {
            LRToast(@"点击了邮件分享");
        }]];
        
        
        //        [_shareArray addObject:IFMPlatformNameSms];
        //        [_shareArray addObject:IFMPlatformNameAlipay];
        //        [_shareArray addObject:IFMPlatformNameEmail];
        //        [_shareArray addObject:IFMPlatformNameSina];
        //        [_shareArray addObject:IFMPlatformNameWechat];
        //        [_shareArray addObject:IFMPlatformNameQQ];
        
    }
    return _shareArray;
}

+(void)showWithCollect:(BOOL)collect returnBlock:(void (^)(NSInteger, NSInteger))clickBlock
{
    isCollect = collect;
    IFMShareView *shareView = [[IFMShareView alloc] initWithShareItems:[[self new] shareArray] functionItems:[[self new] getFunctionArr] itemSize:CGSizeMake(99,116)];
    shareView.itemSpace = 0;
    shareView.middleTopSpace = 5;
    shareView.middleBottomSpace = 0;
    
    shareView.itemImageTopSpace = 15;
    shareView.iconAndTitleSpace = 10;
    
    shareView.itemImageSize = CGSizeMake(67, 67);
    
    shareView.containViewColor = WhiteColor;
    shareView.itemTitleFont = PFFontR(15);
    shareView.itemTitleColor = RGBA(152, 152, 152, 1);
    shareView.cancleButton.titleLabel.font = PFFontR(17);
    [shareView.cancleButton setTitleColor:RGBA(183, 183, 183, 1) forState:UIControlStateNormal];
    [shareView.cancleButton addBorderTo:BorderTypeTop borderColor:RGBA(219, 219, 219, 1)];
    
    [shareView showFromControlle:[HttpRequest currentViewController]];
    
    shareView.clickBlock = ^(NSInteger section, NSInteger row) {
        if (clickBlock) {
            clickBlock(section,row);
        }
    };
}

//创建功能性数组
-(NSMutableArray *)getFunctionArr
{
    
    NSMutableArray *functionArray = [NSMutableArray array];
    [functionArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_fonts") title:@"字体大小" action:^(IFMShareItem *item) {
        [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
            
        }];
    }]];
    NSString *title = @"夜间模式";
    UIImage *nightModelImg = UIImageNamed(@"share_nightMode");
    if (UserGetBool(@"NightMode")) {
        title = @"日间模式";
        nightModelImg = UIImageNamed(@"share_dayMode");
    }
    [functionArray addObject:[[IFMShareItem alloc] initWithImage:nightModelImg title:title action:^(IFMShareItem *item) {
        BOOL open = UserGetBool(@"NightMode");
        UserSetBool(!open, @"NightMode")
        if (open) {
            LRToast(@"夜间模式已关闭");
        }else{
            LRToast(@"夜间模式已开启");
        }
    }]];
    
    NSString *collectTitle = @"收藏";
    UIImage *collectImg = UIImageNamed(@"share_collect");
    if (isCollect) {
        collectTitle = @"取消收藏";
        collectImg = UIImageNamed(@"share_collected");
    }
    @weakify(self)
    [functionArray addObject:[[IFMShareItem alloc] initWithImage:collectImg title:collectTitle action:^(IFMShareItem *item) {
        @strongify(self)
//        [self requestCollectNews];
    }]];
    [functionArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_copy") title:@"复制链接" action:^(IFMShareItem *item) {
        LRToast(@"点击了复制链接");
    }]];
    
    return functionArray;
    
}


@end
