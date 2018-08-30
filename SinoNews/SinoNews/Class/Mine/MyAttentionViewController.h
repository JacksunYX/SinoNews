//
//  MyAttentionViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//我的关注

#import <UIKit/UIKit.h>

@interface MyAttentionViewController : BaseViewController

@property(nonatomic,assign) BOOL isSearch;  //是否是搜索
@property(nonatomic,copy) NSString *keyword;

@end
