//
//  YXGifHeader.m
//  SinoNews
//
//  Created by Michael on 2018/5/31.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "YXGifHeader.h"

@implementation YXGifHeader

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"马上刷新" forState:MJRefreshStateWillRefresh];
    
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
    
    //隐藏时间
//    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
//    self.stateLabel.hidden = YES;
}



@end
