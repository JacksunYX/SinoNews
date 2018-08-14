//
//  ChannelSelectView.h
//  SinoNews
//
//  Created by Michael on 2018/8/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//文章发布界面用于多选频道的视图

#import <UIKit/UIKit.h>

@interface ChannelSelectView : UIView
//选择的频道回调
@property (nonatomic,copy) void(^selectBlock)(NSString *channelIdStr);
//根据传递过来的数组构建视图
-(void)setViewWithChannelArr:(NSMutableArray *)channelArr;

@end
