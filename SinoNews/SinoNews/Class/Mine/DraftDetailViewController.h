//
//  DraftDetailViewController.h
//  SinoNews
//
//  Created by Michael on 2018/8/14.
//  Copyright © 2018年 Sino. All rights reserved.
//
//草稿详情页

#import "BaseViewController.h"

@interface DraftDetailViewController : BaseViewController
@property (nonatomic,assign) NSInteger newsId;
@property (nonatomic,assign) NSInteger type;    //0普通文章 1问答
@property (nonatomic,assign) BOOL isToAudit;    //是否是待审核

@property (nonatomic,copy) void(^refreshBlock)(void); //发布成功后刷新回调
@end
