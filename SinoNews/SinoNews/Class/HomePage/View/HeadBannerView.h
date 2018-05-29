//
//  HeadBannerView.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页的自定义滚动视图

#import <UIKit/UIKit.h>

typedef void(^clickHandleBlock)(NSInteger index);

@interface HeadBannerView : UIView
@property (nonatomic,copy) clickHandleBlock selectBlock;

-(void)setupUIWithImageUrls:(NSArray *)imgs;

@end
