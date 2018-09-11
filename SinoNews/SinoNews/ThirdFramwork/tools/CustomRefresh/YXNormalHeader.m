//
//  YXNormalHeader.m
//  SinoNews
//
//  Created by Michael on 2018/5/31.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "YXNormalHeader.h"

#define BALLOON_GIF_DURATION 0.15

@interface YXNormalHeader()

@property (strong, nonatomic) UIImageView *stateGIFImageView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;

@end


@implementation YXNormalHeader

#pragma mark - 懒加载
- (UIImageView *)stateGIFImageView{
    if (!_stateGIFImageView) {
        _stateGIFImageView = [[UIImageView alloc] init];
        [self addSubview:_stateGIFImageView];
    }
    return _stateGIFImageView;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state {
    
    if (images == nil) {
        return;
    }
    self.stateImages[@(state)] = images;
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
    
}


#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    //所有的自定义东西都放在这里
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"马上刷新" forState:MJRefreshStateWillRefresh];
    [self setTitle:@"已显示全部内容" forState:MJRefreshStateNoMoreData];
    //一些其他属性设置
    
    self.labelLeftInset = 50;
    
    // 资源数据（GIF每一帧）
    NSArray *idleImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:6];
    NSArray *refreshingImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:6];
    // 普通状态
    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 即将刷新状态
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 正在刷新状态
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    
    /*
     // 设置字体
     self.stateLabel.font = [UIFont systemFontOfSize:15];
     self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
     
     // 设置颜色
     self.stateLabel.textColor = [UIColor redColor];
     self.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
     // 隐藏时间
     self.lastUpdatedTimeLabel.hidden = YES;
     // 隐藏状态
     self.stateLabel.hidden = YES;
     // 设置自动切换透明度(在导航栏下面自动隐藏)
     self.automaticallyChangeAlpha = YES;
     */
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) {
        return;
    }
    [self.stateGIFImageView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) {
        index = images.count - 1;
    }
    self.stateGIFImageView.image = images[index];
    
}

- (void)placeSubviews{
    
    [super placeSubviews];
    
    if (self.stateGIFImageView.constraints.count) {
        return;
    }
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.arrowView.hidden = YES;
    
    self.stateGIFImageView.frame = self.bounds;
    self.stateGIFImageView.contentMode = UIViewContentModeCenter;
    
}

- (void)setState:(MJRefreshState)state{
    
    MJRefreshCheckState
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        [self startGIFViewAnimationWithImages:images];
    } else if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing && state == MJRefreshStateIdle) {
            NSArray *endImages = [self getRefreshingImageArrayWithStartIndex:8 endIndex:13];
            
            [self startGIFViewAnimationWithImages:endImages];
        }else{
            [self.stateGIFImageView stopAnimating];
        }
    }
    
}

#pragma mark - 开始动画
- (void)startGIFViewAnimationWithImages:(NSArray *)images{
    
    if (images.count <= 0){
        return;
    }
    [self.stateGIFImageView stopAnimating];
    // 单张
    if (images.count == 1) {
        self.stateGIFImageView.image = [images lastObject];
        return;
    }
    // 多张
    self.stateGIFImageView.animationImages = images;
    self.stateGIFImageView.animationDuration = images.count * BALLOON_GIF_DURATION;
    [self.stateGIFImageView startAnimating];
    
}


#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_pic_%zd", i]];
        if (image) {
            [result addObject:image];
        }
    }
    return result;
    
}





@end
