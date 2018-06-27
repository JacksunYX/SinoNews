//
//  UIViewController+emptyView.m
//  SinoNews
//
//  Created by Michael on 2018/6/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UIViewController+emptyView.h"

static int tags = 206118;
@implementation UIViewController (emptyView)

//显隐加载背景
-(void)showOrHideLoadView:(BOOL)show page:(NSInteger)pageType
{
    if ([[self.view viewWithTag:tags] isKindOfClass:[UIImageView class]]) {

        [self show:show view:[self.view viewWithTag:tags]];
        
    }else{
        UIImageView *loadingImg = [UIImageView new];
        loadingImg.tag = tags;
        loadingImg.userInteractionEnabled = YES;
        [self.view addSubview:loadingImg];
        [self.view bringSubviewToFront:loadingImg];
        loadingImg.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
        UIImage *img;
        switch (pageType) {
            case 1: //首页
                img = UIImageNamed(@"homePage_loadingImg");
                break;
            case 2: //普通新闻
                img = UIImageNamed(@"newsDetail_loadingImg");
                break;
            default:
                img = UIImageNamed(@"homePage_loadingImg");
                break;
        }
        loadingImg.image = img;
        
        [self show:show view:loadingImg];
    }
}

//显隐
-(void)show:(BOOL)show view:(UIView *)view
{
    if (!show) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }else{
        [view setHidden:NO];
    }
}

@end
