//
//  EditSelectViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "EditSelectViewController.h"

#import "FastPostingViewController.h"
#import "SeniorPostingViewController.h"
#import "VotePostingViewController.h"

@interface EditSelectViewController ()
@property (nonatomic,strong) UIButton *closeBtn;
@end

@implementation EditSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //必须这么写，不然推出时导航栏会出现
    self.navigationController.navigationBar.hidden = YES;
}

-(void)setUI
{
    _closeBtn = [UIButton new];
    [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_closeBtn];
    _closeBtn.sd_layout
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 20)
    .centerXEqualToView(self.view)
    .widthIs(50)
    .heightIs(50)
    ;
//    _closeBtn.sd_cornerRadius = @25;
    [_closeBtn setNormalTitleColor:BlackColor];
    [_closeBtn setNormalImage:UIImageNamed(@"selectEditType_close")];
    [_closeBtn setBtnFont:PFFontL(18)];
    
//    _closeBtn.layer.borderColor = UIColor.grayColor.CGColor;
//    _closeBtn.layer.borderWidth = 1;
    
    [self addSelectView];
}

-(void)close:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addSelectView
{
    UIButton *btn1 = [UIButton new];
//    btn1.backgroundColor = GreenColor;
    [btn1 setNormalTitleColor:HexColor(#3A4152)];
    [btn1 setBtnFont:PFFontL(15)];
    
    UIButton *btn2 = [UIButton new];
//    btn2.backgroundColor = GreenColor;
    [btn2 setNormalTitleColor:HexColor(#3A4152)];
    [btn2 setBtnFont:PFFontL(15)];
    
    UIButton *btn3 = [UIButton new];
//    btn3.backgroundColor = GreenColor;
    [btn3 setNormalTitleColor:HexColor(#3A4152)];
    [btn3 setBtnFont:PFFontL(15)];
    
    [self.view sd_addSubviews:@[
                                btn2,
                                btn1,
                                btn3,
                                ]];
    CGFloat intervalX = 40;
    btn2.sd_layout
    .bottomSpaceToView(_closeBtn, 50)
    .centerXEqualToView(self.view)
    .widthIs(73)
    .heightIs(100)
    ;
    btn2.imageEdgeInsets = UIEdgeInsetsMake(-30, 5, 0, 0);
    btn2.titleEdgeInsets = UIEdgeInsetsMake(70, -60, 0, 0);
    
    btn1.sd_layout
    .rightSpaceToView(btn2, intervalX)
    .centerYEqualToView(btn2)
    .widthIs(73)
    .heightIs(100)
    ;
    btn1.imageEdgeInsets = UIEdgeInsetsMake(-30, 5, 0, 0);
    btn1.titleEdgeInsets = UIEdgeInsetsMake(70, -60, 0, 0);
    
    btn3.sd_layout
    .leftSpaceToView(btn2, intervalX)
    .centerYEqualToView(btn2)
    .widthIs(73)
    .heightIs(100)
    ;
    btn3.imageEdgeInsets = UIEdgeInsetsMake(-30, 5, 0, 0);
    btn3.titleEdgeInsets = UIEdgeInsetsMake(70, -60, 0, 0);
    
    [btn1 setNormalTitle:@"快速发帖"];
    [btn1 setNormalImage:UIImageNamed(@"FastPosting_icon")];
    [btn2 setNormalTitle:@"高级发帖"];
    [btn2 setNormalImage:UIImageNamed(@"SeniorPosts_icon")];
    [btn3 setNormalTitle:@"发起投票"];
    [btn3 setNormalImage:UIImageNamed(@"Avote_icon")];
    
    btn1.tag = 10058+0;
    btn2.tag = 10058+1;
    btn3.tag = 10058+2;
    [btn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

//点击事件
-(void)clickAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 10058;
    GGLog(@"下标：%ld",index);
    UIViewController *presentVC;
    switch (index) {
        case 0:
        {
            FastPostingViewController *fpVC = [FastPostingViewController new];
            presentVC = fpVC;
        }
            break;
        case 1:
        {
            SeniorPostingViewController *spVC = [SeniorPostingViewController new];
            presentVC = spVC;
        }
            break;
        case 2:
        {
            VotePostingViewController *vpVC = [VotePostingViewController new];
            presentVC = vpVC;
        }
            break;
            
        default:
            break;
    }
    //跳转的同时移除界面
    [self.rt_navigationController pushViewController:presentVC animated:YES complete:^(BOOL finished) {
        [self.rt_navigationController removeViewController:self];
    }];
    
}



@end
