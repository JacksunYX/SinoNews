//
//  PaidEditViewController.h
//  SinoNews
//
//  Created by Michael on 2018/10/22.
//  Copyright © 2018 Sino. All rights reserved.
//
//单独用来处理付费文章编辑两部分的界面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaidEditViewController : BaseViewController
//编辑回调block
@property (nonatomic,copy) void(^editBlock)(NSString *editContent);
@property (nonatomic,strong) NSString *content; //默认内容
@property (nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
