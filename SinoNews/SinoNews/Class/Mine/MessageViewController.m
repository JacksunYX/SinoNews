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
#import "OfficialNotifyViewController.h"

@interface MessageViewController ()

@property (nonatomic,strong) NSMutableArray *tipsArr;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    [self showTopLine];
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
                       @"站内信",
                       ];
    
    self.tipsArr = [NSMutableArray new];
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
        [btn updateLayout];
        btn.tag = 10086 + i;
        [btn addTarget:self action:@selector(touchToPush:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:UIImageNamed(GetSaveString(img[i])) forState:UIControlStateNormal];
        [btn setTitle:GetSaveString(title[i]) forState:UIControlStateNormal];
        
        UIView *redTip = [UIView new];
        redTip.backgroundColor = RedColor;
        [btn addSubview:redTip];
        redTip.sd_layout
        .topSpaceToView(btn, 10)
        .rightSpaceToView(btn, 5)
        .widthIs(6)
        .heightEqualToWidth()
        ;
        [redTip setSd_cornerRadius:@3];
        
        if (!self.tipsModel.hasPraise&&i == 0) {
            redTip.hidden = YES;
        }else if (!self.tipsModel.hasFans&&i == 1) {
            redTip.hidden = YES;
        }else if (!self.tipsModel.hasNotice&&i == 2) {
            redTip.hidden = YES;
        }
        if (i == 2) {
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        }else{
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        }
        
        [self.tipsArr addObject:redTip];
    }
    
    UIView *line1 = [UIView new];
//    line1.backgroundColor = RGBA(227, 227, 227, 1);
    [line1 addCutLineColor];
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
    NSInteger index = btn.tag - 10086;
    UIView *tip = self.tipsArr[index];
    tip.hidden = YES;
    switch (index) {
        case 0:
        {
//            UserSetBool(NO, @"PraiseNotice");
            MessagePraiseViewController *pvc = [MessagePraiseViewController new];
            [self.navigationController pushViewController:pvc animated:YES];
        }
            break;
        case 1:
        {
//            UserSetBool(NO, @"FansNotice");
            MessageFansViewController *fvc = [MessageFansViewController new];
            [self.navigationController pushViewController:fvc animated:YES];
        }
            break;
        case 2:
        {
//            UserSetBool(NO, @"MessageNotice");
//            NewNotifyViewController *nvc = [NewNotifyViewController new];
//            [self.navigationController pushViewController:nvc animated:YES];
            OfficialNotifyViewController *onVC = [OfficialNotifyViewController new];
            [self.navigationController pushViewController:onVC animated:YES];
//            [self.rt_navigationController pushViewController:nvc animated:YES complete:^(BOOL finished) {
//                [self.rt_navigationController removeViewController:self];
//            }];
        }
            break;
            
        default:
            break;
    }
}

//更新指定下标红点
-(void)updataTipStatus:(NSInteger)index
{
    UIView *tip = self.tipsArr[index];
    tip.hidden = NO;
}




@end
