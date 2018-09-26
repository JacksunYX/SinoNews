//
//  MessageViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//
//消息

#import <UIKit/UIKit.h>
#import "MineTipsModel.h"

@interface MessageViewController : BaseViewController

@property (nonatomic,strong) MineTipsModel *tipsModel;

//更新指定下标红点
-(void)updataTipStatus:(NSInteger)index;

@end
