//
//  ChangeAttentionReusableView.h
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//
//修改关注版块页的自定义分区头尾

#import <UIKit/UIKit.h>

extern NSString * _Nonnull const ChangeAttentionReusableViewID;

NS_ASSUME_NONNULL_BEGIN

@interface ChangeAttentionReusableView : UICollectionReusableView
@property (nonatomic,copy) void (^checkMoreBlock)(void);
-(void)setData:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
