//
//  BandingAlipayViewController.m
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BandingAlipayViewController.h"

@interface BandingAlipayViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)TXLimitedTextField *username;
@property (nonatomic,strong)TXLimitedTextField *password;
@property (nonatomic,strong)UIButton *confirmBtn;   //绑定按钮
@end

@implementation BandingAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定支付宝";
    [self setUI];
}

-(void)setUI
{
    UILabel *accountLabel = [UILabel new];
    accountLabel.font = PFFontL(16);
    accountLabel.textColor = HexColor(#161A24);
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = PFFontL(16);
    nameLabel.textColor = HexColor(#161A24);
    //分割线
    UIView *speLine1 = [UIView new];
    [speLine1 addCutLineColor];
    UIView *speLine2 = [UIView new];
    [speLine2 addCutLineColor];
    
    self.username = [TXLimitedTextField new];
    self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.username.delegate = self;
    self.username.font = PFFontL(16);
    
    self.password = [TXLimitedTextField new];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.delegate = self;
    self.password.font = PFFontL(16);
    
    self.confirmBtn = [UIButton new];
    [self.confirmBtn setNormalTitleColor:WhiteColor];
    [self.confirmBtn setBtnFont:PFFontL(17)];
    self.confirmBtn.backgroundColor = HexColor(#3E9FFC);
    
    [self.view sd_addSubviews:@[
                                self.username,
                                accountLabel,
                                speLine1,
                                
                                self.password,
                                nameLabel,
                                speLine2,
                                
                                self.confirmBtn,
                                ]];
    self.username.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(self.view, 70)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
    self.username.placeholder = @"请输入支付宝账号";
    
    accountLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.username)
    .heightIs(16)
    ;
    [accountLabel setSingleLineAutoResizeWithMaxWidth:50];
    accountLabel.text = @"账号";
    
    speLine1.sd_layout
    .topSpaceToView(self.username, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    ;
    
    self.password.sd_layout
    .topEqualToView(speLine1)
    .leftSpaceToView(self.view, 70)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
    self.password.placeholder = @"请输入账号姓名";
    
    nameLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.password)
    .heightIs(16)
    ;
    [nameLabel setSingleLineAutoResizeWithMaxWidth:50];
    nameLabel.text = @"姓名";
    
    speLine2.sd_layout
    .topSpaceToView(self.password, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    ;
    
    self.confirmBtn.sd_layout
    .topSpaceToView(speLine2, 55)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(40)
    ;
    [self.confirmBtn setSd_cornerRadius:@4];
    [self.confirmBtn setNormalTitle:@"确认绑定"];
    [self.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)confirmAction:(UIButton *)sender
{
    if ([NSString isEmpty:self.username.text]){
        LRToast(@"请输入支付宝账号");
    }else if([NSString isEmpty:self.password.text]){
        LRToast(@"请输入账号姓名");
    }else{
        //确认绑定
        
    }
}

@end
