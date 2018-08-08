//
//  HomePageChildVCViewController.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageChildVCViewController : BaseViewController

@property (nonatomic, strong) NSString * news_id;       //频道id

@property (nonatomic, strong) NSString * channel_name;  //频道名称

//滚动至顶部
-(void)scrollToTop;

@end
