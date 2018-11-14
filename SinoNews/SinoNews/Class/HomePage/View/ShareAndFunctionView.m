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
#ifdef JoinThirdShare
        if ([MGSocialShareHelper canBeShareToPlatform:MGShareToWechatSession]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToWechatTimeline]) {
            [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_wechat") title:@"微信好友" action:nil]];
            
            [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_wechatFriend") title:@"微信朋友圈" action:nil]];
        }
        
        
        if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
            [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_qq") title:@"QQ好友" action:nil]];
            
            [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_qqZone") title:@"QQ空间" action:nil]];
        }
        
        
        if ([MGSocialShareHelper canBeShareToPlatform:MGShareToSina]) {
            [_shareArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_sina") title:@"新浪微博" action:nil]];
        }
#endif
        
        //        [_shareArray addObject:[[IFMShareItem alloc]initWithImage:UIImageNamed(@"share_email") title:@"邮件分享" actionName:IFMPlatformHandleEmail]];
        
        //                [_shareArray addObject:IFMPlatformNameSms];
        //        [_shareArray addObject:IFMPlatformNameAlipay];
        //        [_shareArray addObject:IFMPlatformNameEmail];
        //        [_shareArray addObject:IFMPlatformNameSina];
        //        [_shareArray addObject:IFMPlatformNameWechat];
        //        [_shareArray addObject:IFMPlatformNameQQ];
        
    }
    return _shareArray;
}

+(void)showWithReturnBlock:(void (^)(NSInteger, NSInteger , MGShareToPlateform))clickBlock
{
    IFMShareView *shareView = [[IFMShareView alloc] initWithItems:[[self new] shareArray] itemSize:CGSizeMake(99,116) DisplayLine:NO];
    shareView.itemSpace = 0;
    shareView.middleTopSpace = 5;
    shareView.middleBottomSpace = 0;
    
    shareView.itemImageTopSpace = 15;
    shareView.iconAndTitleSpace = 10;
    shareView.showCancleButton = NO;
    
    shareView.itemImageSize = CGSizeMake(56, 56);
    
    shareView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        IFMShareView *share = item;
        share.containViewColor = value;
        share.cancleButton.backgroundColor = value;
        
        if (UserGetBool(@"NightMode")) {
            share.itemTitleColor = HexColor(#CFD3D6);
            share.cellimageBackgroundColor = HexColor(#3A4146);
            [shareView.cancleButton addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
        }else{
            share.itemTitleColor = RGBA(152, 152, 152, 1);
            share.cellimageBackgroundColor = WhiteColor;
            [shareView.cancleButton addBorderTo:BorderTypeTop borderColor:CutLineColor];
        }
    });
    
    shareView.itemTitleFont = PFFontL(13);
    shareView.cancleButton.titleLabel.font = PFFontR(17);
    [shareView.cancleButton addButtonTextColorTheme];
    
    [shareView showFromControlle:[HttpRequest getCurrentVC]];
    
    
    __block MGShareToPlateform sharePlateform;
    shareView.clickBlock = ^(NSInteger section, NSInteger row) {
#ifdef JoinThirdShare
        if (section == 0 && row!=5) {
            //1先判断是否有微信
            
            if ([MGSocialShareHelper canBeShareToPlatform:MGShareToWechatSession]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToWechatTimeline]) {
                //有微信
                if (row == 0) {
                    sharePlateform = MGShareToWechatSession;
                }else if (row == 1){
                    sharePlateform = MGShareToWechatTimeline;
                }else{
                    
                    //2.超过2个了,需要先判断有没有qq
                    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
                        //有
                        if (row == 2) {
                            sharePlateform = MGShareToQQ;
                        }else if (row == 3){
                            sharePlateform = MGShareToQzone;
                        }else if (row == 4){
                            sharePlateform = MGShareToSina;
                        }
                    }else{
                        //没有
                        if (row == 2) {
                            sharePlateform = MGShareToSina;
                        }
                    }
                }
                
            }else{
                //没有微信
                //先判断是否有qq
                if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
                    //有
                    if (row == 0) {
                        sharePlateform = MGShareToQQ;
                    }else if (row == 1){
                        sharePlateform = MGShareToQzone;
                    }else if (row == 2){
                        sharePlateform = MGShareToSina;
                    }
                }else{
                    //没有
                    if (row == 0) {
                        sharePlateform = MGShareToSina;
                    }
                }
            }
            
        }
#endif
        
        if (clickBlock) {
            clickBlock(section,row,sharePlateform);
        }
    };
}

+(void)showWithCollect:(BOOL)collect returnBlock:(void (^)(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform))clickBlock
{
    isCollect = collect;
//    IFMShareView *shareView = [[IFMShareView alloc] initWithShareItems:[[self new] shareArray] functionItems:[[self new] getFunctionArr] itemSize:CGSizeMake(99,116)];
    IFMShareView *shareView = [[IFMShareView alloc] initWithShareItems:[NSArray new] functionItems:[[self new] getFunctionArr:YES] itemSize:CGSizeMake(99,116)];
    shareView.itemSpace = 0;
    shareView.middleTopSpace = 5;
    shareView.middleBottomSpace = 0;
    
    shareView.itemImageTopSpace = 15;
    shareView.iconAndTitleSpace = 10;
//    shareView.showCancleButton = NO;
    
    shareView.itemImageSize = CGSizeMake(56, 56);
    
    shareView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        IFMShareView *share = item;
        share.containViewColor = value;
        share.cancleButton.backgroundColor = value;
        
        if (UserGetBool(@"NightMode")) {
            share.itemTitleColor = HexColor(#CFD3D6);
            share.cellimageBackgroundColor = HexColor(#3A4146);
            [shareView.cancleButton addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
        }else{
            share.itemTitleColor = RGBA(152, 152, 152, 1);
            share.cellimageBackgroundColor = WhiteColor;
            [shareView.cancleButton addBorderTo:BorderTypeTop borderColor:CutLineColor];
        }
    });
    
    shareView.itemTitleFont = PFFontL(13);
    shareView.cancleButton.titleLabel.font = PFFontR(17);
    [shareView.cancleButton addButtonTextColorTheme];
    
    [shareView showFromControlle:[HttpRequest currentViewController]];
    
    __block MGShareToPlateform sharePlateform;
    shareView.clickBlock = ^(NSInteger section, NSInteger row) {
#ifdef JoinThirdShare
        
        if (section == 0 && row!=5) {
            //1先判断是否有微信
            
            if ([MGSocialShareHelper canBeShareToPlatform:MGShareToWechatSession]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToWechatTimeline]) {
                //有微信
                if (row == 0) {
                    sharePlateform = MGShareToWechatSession;
                }else if (row == 1){
                    sharePlateform = MGShareToWechatTimeline;
                }else{
                    
                    //2.超过2个了,需要先判断有没有qq
                    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
                        //有
                        if (row == 2) {
                            sharePlateform = MGShareToQQ;
                        }else if (row == 3){
                            sharePlateform = MGShareToQzone;
                        }else if (row == 4){
                            sharePlateform = MGShareToSina;
                        }
                    }else{
                        //没有
                        if (row == 2) {
                            sharePlateform = MGShareToSina;
                        }
                    }
                }
                
            }else{
                //没有微信
                //先判断是否有qq
                if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
                    //有
                    if (row == 0) {
                        sharePlateform = MGShareToQQ;
                    }else if (row == 1){
                        sharePlateform = MGShareToQzone;
                    }else if (row == 2){
                        sharePlateform = MGShareToSina;
                    }
                }else{
                    //没有
                    if (row == 0) {
                        sharePlateform = MGShareToSina;
                    }
                }
            }
            
        }
#endif
        
        if (clickBlock) {
            clickBlock(section,row,sharePlateform);
        }
    };
}

//没有收藏选项的弹出试图
+(void)showWithNoCollectreturnBlock:(void (^)(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform))clickBlock
{
    IFMShareView *shareView = [[IFMShareView alloc] initWithShareItems:[NSArray new] functionItems:[[self new] getFunctionArr:NO] itemSize:CGSizeMake(99,116)];
    shareView.itemSpace = 0;
    shareView.middleTopSpace = 5;
    shareView.middleBottomSpace = 0;
    
    shareView.itemImageTopSpace = 15;
    shareView.iconAndTitleSpace = 10;
    //    shareView.showCancleButton = NO;
    
    shareView.itemImageSize = CGSizeMake(56, 56);
    
    shareView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        IFMShareView *share = item;
        share.containViewColor = value;
        share.cancleButton.backgroundColor = value;
        
        if (UserGetBool(@"NightMode")) {
            share.itemTitleColor = HexColor(#CFD3D6);
            share.cellimageBackgroundColor = HexColor(#3A4146);
            [shareView.cancleButton addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
        }else{
            share.itemTitleColor = RGBA(152, 152, 152, 1);
            share.cellimageBackgroundColor = WhiteColor;
            [shareView.cancleButton addBorderTo:BorderTypeTop borderColor:CutLineColor];
        }
    });
    
    shareView.itemTitleFont = PFFontL(13);
    shareView.cancleButton.titleLabel.font = PFFontR(17);
    [shareView.cancleButton addButtonTextColorTheme];
    
    [shareView showFromControlle:[HttpRequest getCurrentVC]];
    
    __block MGShareToPlateform sharePlateform;
    shareView.clickBlock = ^(NSInteger section, NSInteger row) {
#ifdef JoinThirdShare
        
        if (section == 0 && row!=5) {
            //1先判断是否有微信
            
            if ([MGSocialShareHelper canBeShareToPlatform:MGShareToWechatSession]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToWechatTimeline]) {
                //有微信
                if (row == 0) {
                    sharePlateform = MGShareToWechatSession;
                }else if (row == 1){
                    sharePlateform = MGShareToWechatTimeline;
                }else{
                    
                    //2.超过2个了,需要先判断有没有qq
                    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
                        //有
                        if (row == 2) {
                            sharePlateform = MGShareToQQ;
                        }else if (row == 3){
                            sharePlateform = MGShareToQzone;
                        }else if (row == 4){
                            sharePlateform = MGShareToSina;
                        }
                    }else{
                        //没有
                        if (row == 2) {
                            sharePlateform = MGShareToSina;
                        }
                    }
                }
                
            }else{
                //没有微信
                //先判断是否有qq
                if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]&&[MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
                    //有
                    if (row == 0) {
                        sharePlateform = MGShareToQQ;
                    }else if (row == 1){
                        sharePlateform = MGShareToQzone;
                    }else if (row == 2){
                        sharePlateform = MGShareToSina;
                    }
                }else{
                    //没有
                    if (row == 0) {
                        sharePlateform = MGShareToSina;
                    }
                }
            }
            
        }
#endif
        
        if (clickBlock) {
            clickBlock(section,row,sharePlateform);
        }
    };
}


//创建功能性数组
-(NSMutableArray *)getFunctionArr:(BOOL)haveCollect
{
    
    NSMutableArray *functionArray = [NSMutableArray array];
    [functionArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_fonts") title:@"字体大小" action:^(IFMShareItem *item) {
        //        [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
        //
        //        }];
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
        [ThemeManager changeTheme];
//        if (open) {
//            LRToast(@"夜间模式已关闭");
//            [LEETheme startTheme:@"NormalTheme"];
//        }else{
//            LRToast(@"夜间模式已开启");
//            [LEETheme startTheme:@"NightTheme"];
//        }
        //发送修改了夜间模式的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NightModeChanged object:nil];
    }]];
    
    NSString *collectTitle = @"收藏";
    UIImage *collectImg = UIImageNamed(@"share_collect");
    if (isCollect) {
        collectTitle = @"取消收藏";
        collectImg = UIImageNamed(@"share_collected");
    }
    
    if (haveCollect) {
        [functionArray addObject:[[IFMShareItem alloc] initWithImage:collectImg title:collectTitle action:nil]];
    }
    
    [functionArray addObject:[[IFMShareItem alloc] initWithImage:UIImageNamed(@"share_copy") title:@"复制链接" action:nil]];
    
    return functionArray;
    
}


@end
