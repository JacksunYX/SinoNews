//
//  FindPasswordViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
{
    TXLimitedTextField *oldPassword;    //当前密码
    TXLimitedTextField *newPassword;    //新密码
    TXLimitedTextField *againPassword;  //确认新密码
    
    UIButton *confirmBtn;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setUI
{
    //背景图
    UIImageView *backImg = [UIImageView new];
    backImg.userInteractionEnabled = YES;
    [self.view addSubview:backImg];
    
    backImg.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [backImg updateLayout];
    backImg.backgroundColor = WhiteColor;
    //    backImg.image = UIImageNamed(@"login_backgroundImg");
    @weakify(self)
    [backImg whenTap:^{
        @strongify(self)
        [self tap];
    }];
    
    //输入框
    oldPassword = [self getTextField];
    
    newPassword = [self getTextField];
    
    againPassword = [self getTextField];
    
    confirmBtn = [UIButton new];
    [confirmBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    confirmBtn.backgroundColor = RGBA(62, 159, 252, 1);
    confirmBtn.titleLabel.font = PFFontL(17);
    
    [backImg sd_addSubviews:@[
                              oldPassword,
                              newPassword,
                              againPassword,
                              confirmBtn,
                              ]];
    oldPassword.sd_layout
    .topEqualToView(backImg)
    .leftSpaceToView(backImg, 10)
    .rightSpaceToView(backImg, 10)
    .heightIs(50)
    ;
    [oldPassword updateLayout];
    oldPassword.placeholder = @"当前密码";
    [oldPassword addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    newPassword.sd_layout
    .topSpaceToView(oldPassword, 0)
    .leftSpaceToView(backImg, 10)
    .rightSpaceToView(backImg, 10)
    .heightIs(50)
    ;
    [newPassword updateLayout];
    newPassword.placeholder = @"新密码";
    [newPassword addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    againPassword.sd_layout
    .topSpaceToView(newPassword, 0)
    .leftSpaceToView(backImg, 10)
    .rightSpaceToView(backImg, 10)
    .heightIs(50)
    ;
    [againPassword updateLayout];
    againPassword.placeholder = @"确认密码";
    [againPassword addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    confirmBtn.sd_layout
    .leftSpaceToView(backImg, 24)
    .rightSpaceToView(backImg, 24)
    .topSpaceToView(againPassword, 58)
    .heightIs(35)
    ;
    [confirmBtn setSd_cornerRadius:@4];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    //集合信号
    RAC(confirmBtn,enabled) = [RACSignal combineLatest:@[oldPassword.rac_textSignal,newPassword.rac_textSignal,againPassword.rac_textSignal] reduce:^id (NSString *text1,NSString *text2,NSString *text3){
        return @(text1.length>=6&&text2.length>=6&&text3.length>=6);
    }];
}

-(TXLimitedTextField *)getTextField
{
    TXLimitedTextField *textfield = [TXLimitedTextField new];
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.delegate = self;
    textfield.secureTextEntry = YES;
    return textfield;
}

//收回键盘
-(void)tap
{
    [self.view endEditing:YES];
}

//确认操作
-(void)confirmAction
{
    if (kStringIsEmpty(oldPassword.text)) {
        LRToast(@"请输入旧密码");
    }else if (kStringIsEmpty(newPassword.text)){
        LRToast(@"请输入新密码");
    }else if (kStringIsEmpty(againPassword.text)){
        LRToast(@"请输入确认密码");
    }else if(!CompareString(newPassword.text, againPassword.text)){
        LRToast(@"两次输入的密码不一致哦～");
    }else{
        if (![oldPassword.text checkPassWord]) {
            LRToast(@"旧密码为6-16位数字、字母和下划线组成");
        }else if (![newPassword.text checkPassWord]){
            LRToast(@"新密码为6-16位数字、字母和下划线组成");
        }else{
            [self requestChangePassword];
        }
    }
}

#pragma mark ----- UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == oldPassword) {
        [oldPassword resignFirstResponder];
        [newPassword becomeFirstResponder];
    }else if (textField == newPassword) {
        [newPassword resignFirstResponder];
        [againPassword becomeFirstResponder];
    }else{
        [againPassword resignFirstResponder];
        [confirmBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

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


#pragma mark ---- 请求发送
//修改密码
-(void)requestChangePassword
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"oldPassword"] = oldPassword.text;
    parameters[@"newsPassword"] = newPassword.text;
    [HttpRequest postWithURLString:User_editPassword parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"修改密码成功");
        GCDAfterTime(1, ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:nil RefreshAction:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}



@end
