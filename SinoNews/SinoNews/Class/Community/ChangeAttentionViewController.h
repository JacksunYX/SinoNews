//
//  ChangeAttentionViewController.h
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//
//切换关注版块的界面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeAttentionViewController : BaseViewController
//修改关注版块完成回调
@property (nonatomic,copy) void(^changeFinishBlock)(NSArray *selectArr);
@end

NS_ASSUME_NONNULL_END
