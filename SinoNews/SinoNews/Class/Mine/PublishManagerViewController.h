//
//  PublishManagerViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//目前已作为发布管理的子页面


#import <UIKit/UIKit.h>

@interface PublishManagerViewController : BaseViewController

@property (nonatomic,assign) NSInteger type;    //0已审核 1待审核 2草稿箱

@end
