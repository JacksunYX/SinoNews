//
//  YXAutoNormalFooter.m
//  SinoNews
//
//  Created by Michael on 2018/5/31.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "YXAutoNormalFooter.h"

@implementation YXAutoNormalFooter
- (void)prepare{
    [super prepare];
    
    //所有的自定义东西都放在这里
    [self setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"上拉刷新" forState:MJRefreshStateWillRefresh];
    [self setTitle:@"已显示全部内容" forState:MJRefreshStateNoMoreData];
    //一些其他属性设置
    
    // 设置字体
//    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.stateLabel.textColor = RGB(183, 183, 183);
    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    self.automaticallyChangeAlpha = YES;
//
//    self.refreshingTitleHidden = NO;
//    self.ignoredScrollViewContentInsetBottom = 40;
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_pic_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    //设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_pic_%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //每次拖拽只调用一次
    self.onlyRefreshPerDrag = YES;
    
    /*
     // 设置颜色
     
     self.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
     // 隐藏时间
     self.lastUpdatedTimeLabel.hidden = YES;
     // 隐藏状态
     self.stateLabel.hidden = YES;
     
     */
}

@end
