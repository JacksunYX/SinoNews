//
//  BandingVerifierViewController.m
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BandingVerifierViewController.h"

@interface BandingVerifierViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)TXLimitedTextField *password;
@property (nonatomic,strong)UIButton *confirmBtn;   //确认按钮
@end

@implementation BandingVerifierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.view.backgroundColor = WhiteColor;
    @weakify(self);
    [self.view whenTap:^{
        @strongify(self);
        [self.view endEditing:YES];
    }];
}

-(void)setUI
{
    UILabel *topNotice = [UILabel new];
    topNotice.textColor = HexColor(#323232);
//    [topNotice addTitleColorTheme];
    topNotice.font = PFFontL(24);
    UILabel *subNotice = [UILabel new];
    subNotice.textColor = HexColor(#323232);
//    [subNotice addTitleColorTheme];
    subNotice.font = PFFontL(13);
    
    self.password = [TXLimitedTextField new];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    self.password.textAlignment = NSTextAlignmentCenter;
//    self.password.lee_theme.LeeConfigTextColor(@"titleColor");
    
    self.confirmBtn = [UIButton new];
    [self.confirmBtn setNormalTitleColor:WhiteColor];
    [self.confirmBtn setBtnFont:PFFontL(17)];
    self.confirmBtn.backgroundColor = HexColor(#3E9FFC);
    
    [self.view sd_addSubviews:@[
                                topNotice,
                                subNotice,
                                _password,
                                _confirmBtn,
                                ]];
    
    topNotice.sd_layout
    .topSpaceToView(self.view, 55)
    .centerXEqualToView(self.view)
    .heightIs(24)
    ;
    [topNotice setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
    topNotice.text = self.verifierType?@"绑定银行卡":@"绑定支付宝";
    
    subNotice.sd_layout
    .topSpaceToView(topNotice, 20)
    .centerXEqualToView(self.view)
    .heightIs(14)
    ;
    [subNotice setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
    subNotice.text = @"请输入登录密码，以验证身份";
    
    _password.sd_layout
    .topSpaceToView(subNotice, 40)
    .leftSpaceToView(self.view, 50)
    .rightSpaceToView(self.view, 50)
    .heightIs(45)
    ;
    _password.layer.borderWidth = 1;
    _password.layer.borderColor = HexColor(#CFCFCF).CGColor;
    
    self.confirmBtn.sd_layout
    .topSpaceToView(_password, 80)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(40)
    ;
    [self.confirmBtn setSd_cornerRadius:@4];
    [self.confirmBtn setNormalTitle:@"确认"];
    [self.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)confirmAction:(UIButton *)sender
{
    if (kStringIsEmpty(self.password.text)){
        LRToast(@"请输入密码");
    }else{
        //1.发送验证身份的网络请求
        
        //2.完成校验，跳转到对应界面
        [self pushToEditVC];
    }
}

-(void)pushToEditVC
{
    UIViewController *vc;
    switch (self.verifierType) {
        case 0:
            vc = [BandingAlipayViewController new];
            break;
        case 1:
            vc = [BandingBankCardViewController new];
            break;
            
        default:
            break;
    }
    
    //跳转的同时移除当前控制器
    @weakify(self);
    [self.rt_navigationController pushViewController:vc animated:YES complete:^(BOOL finished) {
        @strongify(self);
        if (finished) {
            [self.rt_navigationController removeViewController:self];
        }
    }];
}

//检测空格
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

//禁止粘贴、全选
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
