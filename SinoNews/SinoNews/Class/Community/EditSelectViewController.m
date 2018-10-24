//
//  EditSelectViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "EditSelectViewController.h"

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
    .bottomSpaceToView(self.view, BOTTOM_MARGIN+20)
    .centerXEqualToView(self.view)
    .widthIs(50)
    .heightIs(50)
    ;
    _closeBtn.sd_cornerRadius = @25;
    [_closeBtn setNormalTitleColor:BlackColor];
    [_closeBtn setNormalTitle:@"X"];
    [_closeBtn setBtnFont:PFFontL(18)];
    
    _closeBtn.layer.borderColor = UIColor.grayColor.CGColor;
    _closeBtn.layer.borderWidth = 1;
    
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
    [btn1 setNormalTitleColor:BlackColor];
    [btn1 setBtnFont:PFFontL(12)];
    
    UIButton *btn2 = [UIButton new];
//    btn2.backgroundColor = GreenColor;
    [btn2 setNormalTitleColor:BlackColor];
    [btn2 setBtnFont:PFFontL(12)];
    
    UIButton *btn3 = [UIButton new];
//    btn3.backgroundColor = GreenColor;
    [btn3 setNormalTitleColor:BlackColor];
    [btn3 setBtnFont:PFFontL(12)];
    
    [self.view sd_addSubviews:@[
                                btn2,
                                btn1,
                                btn3,
                                ]];
    CGFloat intervalX = 40;
    btn2.sd_layout
    .bottomSpaceToView(_closeBtn, 20)
    .centerXEqualToView(self.view)
    .widthIs(60)
    .heightIs(80)
    ;
    btn2.imageEdgeInsets = UIEdgeInsetsMake(-30, 13, 0, 0);
    btn2.titleEdgeInsets = UIEdgeInsetsMake(40, -35, 0, 0);
    
    btn1.sd_layout
    .rightSpaceToView(btn2, intervalX)
    .centerYEqualToView(btn2)
    .widthIs(60)
    .heightIs(80)
    ;
    btn1.imageEdgeInsets = UIEdgeInsetsMake(-30, 12, 0, 0);
    btn1.titleEdgeInsets = UIEdgeInsetsMake(40, -28, 0, 0);
    
    btn3.sd_layout
    .leftSpaceToView(btn2, intervalX)
    .centerYEqualToView(btn2)
    .widthIs(60)
    .heightIs(80)
    ;
    btn3.imageEdgeInsets = UIEdgeInsetsMake(-30, 13, 0, 0);
    btn3.titleEdgeInsets = UIEdgeInsetsMake(40, -30, 0, 0);
    
    [btn1 setNormalTitle:@"普通发帖"];
    [btn1 setNormalImage:UIImageNamed(@"share_qq")];
    [btn2 setNormalTitle:@"高级发帖"];
    [btn2 setNormalImage:UIImageNamed(@"share_wechat")];
    [btn3 setNormalTitle:@"投票发帖"];
    [btn3 setNormalImage:UIImageNamed(@"share_sina")];
}





@end
