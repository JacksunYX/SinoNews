//
//  PopReplyViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//
//假弹窗式回复页面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopReplyViewController : BaseViewController
@property (nonatomic ,copy) void(^finishBlock)(NSDictionary *inputData);
@property (nonatomic ,copy) void(^cancelBlock)(NSDictionary *cancelData);

@property (nonatomic,strong) NSMutableDictionary *inputData;
@end

NS_ASSUME_NONNULL_END
