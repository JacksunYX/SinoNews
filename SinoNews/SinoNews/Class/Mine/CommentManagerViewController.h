//
//  CommentManagerViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//评论管理页/我的回复页(因为与添加的帖子内容回复界面相同，直接拿来用)


#import <UIKit/UIKit.h>

@interface CommentManagerViewController : BaseViewController
//0默认为评论管理，1为帖子回复
@property (nonatomic,assign) NSInteger type;

@end
