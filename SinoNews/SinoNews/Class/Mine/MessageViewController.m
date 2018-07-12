//
//  MessageViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MessageViewController.h"
#import "MessagePraiseViewController.h"
#import "MessageFansViewController.h"
#import "MessageNotifyViewController.h"
#import "NewNotifyViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    
    [self addTopViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTopViews
{
    UIView *topBackView = [UIView new];
    UIView *fatherView = self.view;
    [fatherView addSubview:topBackView];
    
    topBackView.sd_layout
    .topEqualToView(fatherView)
    .leftEqualToView(fatherView)
    .rightEqualToView(fatherView)
    .heightIs(90)
    ;
    NSArray *img = @[
                     @"message_praise",
                     @"message_attention",
                     @"message_notify",
                     ];
    NSArray *title = @[
                       @"赞",
                       @"粉丝",
                       @"通知",
                       ];
    
    CGFloat wid = ScreenW/3;
    for (int i = 0; i < 3; i ++) {
        UIView *backView = [UIView new];
        [topBackView addSubview:backView];
        backView.sd_layout
        .centerYEqualToView(topBackView)
        .heightRatioToView(topBackView, 1)
        .widthIs(wid)
        .leftSpaceToView(topBackView, wid * i)
        ;
        
        UIButton *btn = [UIButton new];
        btn.titleLabel.font = PFFontL(15);
        [btn addButtonTextColorTheme];
        
        [backView addSubview:btn];
        btn.sd_layout
        .centerYEqualToView(backView)
        .centerXEqualToView(backView)
        .heightIs(50)
        .widthIs(100)
        ;
        btn.tag = 10086 + i;
        [btn addTarget:self action:@selector(touchToPush:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:UIImageNamed(GetSaveString(img[i])) forState:UIControlStateNormal];
        [btn setTitle:GetSaveString(title[i]) forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    }
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = RGBA(227, 227, 227, 1);
    [fatherView addSubview:line1];
    line1.sd_layout
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs(1)
    .topSpaceToView(topBackView, 0)
    ;
    
}

//跳转事件
-(void)touchToPush:(UIButton *)btn
{
    GGLog(@"tag:%ld",btn.tag);
    switch (btn.tag - 10086) {
        case 0:
        {
            MessagePraiseViewController *pvc = [MessagePraiseViewController new];
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;
        case 1:
        {
            MessageFansViewController *fvc = [MessageFansViewController new];
            [self.navigationController pushViewController:fvc animated:YES];
        }
            break;
        case 2:
        {
            NewNotifyViewController *nvc = [NewNotifyViewController new];
            [self.navigationController pushViewController:nvc animated:YES];
        }
            break;
            
        default:
            break;
    }
}






@end
