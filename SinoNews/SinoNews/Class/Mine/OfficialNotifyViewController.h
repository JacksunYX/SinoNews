//
//  OfficialNotifyViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/9.
//  Copyright © 2018年 Sino. All rights reserved.
//
//官方聊天界面

#import <UIKit/UIKit.h>

@interface OfficialNotifyViewController : BaseViewController
//获取私信列表(0loadTime之前的，1之后的)
-(void)requestListMessagesWithLoadType:(NSInteger)loadType;
@end
