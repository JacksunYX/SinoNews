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

-(void)showTopLine
{
    [[self getLineViewInNavigationBar:self.navigationController.navigationBar] setHidden:NO];
}
-(void)hiddenTopLine
{
    [[self getLineViewInNavigationBar:self.navigationController.navigationBar] setHidden:YES];
}

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
        
        switch (pageType) {
            case 1: //首页
                loadingImg.lee_theme.LeeConfigImage(@"homeLoad");
                
                break;
            case 2: //普通新闻
                loadingImg.lee_theme.LeeConfigImage(@"articleLoad");
                
                break;
            default:
                loadingImg.lee_theme.LeeConfigImage(@"homeLoad");
                break;
        }
        
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
        [view.superview bringSubviewToFront:view];
    }
}


//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}




@end
