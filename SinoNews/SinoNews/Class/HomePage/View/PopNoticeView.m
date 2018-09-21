//
//  PopNoticeView.m
//  SinoNews
//
//  Created by Michael on 2018/7/24.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PopNoticeView.h"

@implementation PopNoticeView

static CGFloat anumationTime = 0.3;
//显示
+(void)showWithData:(NSArray *)images
{
    
    //背景视图
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//    backView.backgroundColor = RGBA(0, 0, 0, 0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    __block int i = 0;
    if (images.count > 0) {
        [backView setImage:UIImageNamed(images[i])];
    }
    
    @weakify(backView)
    [backView whenTap:^{
        @strongify(backView)
        if (i == images.count - 1) {
            //最后一张图了，移除
            [UIView animateWithDuration:anumationTime animations:^{
                backView.alpha = 0;
            } completion:^(BOOL finished) {
                [backView removeFromSuperview];
            }];
        }else{
            i ++;
            [backView setImage:UIImageNamed(images[i])];
        }
    }];
}

@end
