//
//  BindingDataViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BindingDataViewController.h"

@interface BindingDataViewController ()<UITextFieldDelegate>
{
    TXLimitedTextField *username;   //账号
    TXLimitedTextField *seccode;    //验证码
    TXLimitedTextField *password;    //验证码
    UIButton *getCodeBtn;
    UIButton *confirmBtn;
}
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@end

@implementation BindingDataViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isUpdate) {
        if (self.bindingType) {
            self.navigationItem.title = @"修改绑定手机";
        }else{
            self.navigationItem.title = @"修改绑定邮箱";
        }
    }else{
        if (self.bindingType) {
            self.navigationItem.title = @"绑定手机";
        }else{
            self.navigationItem.title = @"绑定邮箱";
        }
    }
    
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
    .bottomSpaceToView(self.view, 0)
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
    username = [TXLimitedTextField new];
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    username.delegate = self;
    if (self.bindingType) {
        username.limitedType = TXLimitedTextFieldTypeCustom;
        username.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
        username.limitedNumber = 11;
    }
    
    UIView *seccodeBackView = [UIView new];
    seccodeBackView.backgroundColor = WhiteColor;
    //验证码
    seccode = [TXLimitedTextField new];
    seccode.clearButtonMode = UITextFieldViewModeWhileEditing;
    seccode.limitedType = TXLimitedTextFieldTypeCustom;
    seccode.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
    seccode.limitedNumber = 6;
    seccode.delegate = self;
    
    getCodeBtn = [UIButton new];
    getCodeBtn.titleLabel.font = PFFontL(14);
    [getCodeBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    confirmBtn = [UIButton new];
    [confirmBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    confirmBtn.backgroundColor = RGBA(62, 159, 252, 1);
    confirmBtn.titleLabel.font = PFFontL(17);
    
    password = [TXLimitedTextField new];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.delegate = self;
    CGFloat passwordHeight = 0;
    if (self.isUpdate) {
        passwordHeight = 50;
    }else{
        password.hidden = YES;
    }
    
    [backImg sd_addSubviews:@[
                              username,
                              seccodeBackView,
                              password,
                              confirmBtn,
                              ]];
    username.sd_layout
    .topEqualToView(backImg)
    .leftSpaceToView(backImg, 10)
    .rightSpaceToView(backImg, 10)
    .heightIs(50)
    ;
    [username updateLayout];
    NSMutableString *placeholder;
    placeholder = [@"请输入邮箱" mutableCopy];
    if (self.bindingType) {
        placeholder = [@"请输入手机" mutableCopy];
    }
    if (self.isUpdate) {
        [placeholder insertString:@"新" atIndex:3];
    }
    username.placeholder = placeholder;
    [username addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    seccodeBackView.sd_layout
    .topSpaceToView(username, 0)
    .leftSpaceToView(backImg, 10)
    .rightSpaceToView(backImg, 10)
    .heightIs(50)
    ;
    [seccodeBackView updateLayout];
    [seccodeBackView addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    [seccodeBackView sd_addSubviews:@[
                                      getCodeBtn,
                                      seccode,
                                      
                                      ]];
    getCodeBtn.sd_layout
    .rightEqualToView(seccodeBackView)
    .centerYEqualToView(seccodeBackView)
    .heightIs(30)
    .widthIs(70)
    ;
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(getSeccode:) forControlEvents:UIControlEventTouchUpInside];
    
    seccode.sd_layout
    .leftEqualToView(seccodeBackView)
    .topEqualToView(seccodeBackView)
    .bottomEqualToView(seccodeBackView)
    .rightSpaceToView(getCodeBtn, 0)
    ;
    seccode.placeholder = @"输入验证码";
    
    password.sd_layout
    .topSpaceToView(seccodeBackView, 0)
    .leftSpaceToView(backImg, 10)
    .rightSpaceToView(backImg, 10)
    .heightIs(passwordHeight)
    ;
    [password updateLayout];
    password.secureTextEntry = YES;
    password.placeholder = @"请输入登录密码(6-16位数字和字母)";
    [password addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    confirmBtn.sd_layout
    .leftSpaceToView(backImg, 24)
    .rightSpaceToView(backImg, 24)
    .topSpaceToView(seccodeBackView, 108)
    .heightIs(35)
    ;
    [confirmBtn setSd_cornerRadius:@4];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    //键盘监听
    WeakSelf
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:weakSelf.view, nil];
    }];
    
    //集合信号
    if (self.isUpdate) {
        RAC(confirmBtn,enabled) = [RACSignal combineLatest:@[username.rac_textSignal,seccode.rac_textSignal,password.rac_textSignal] reduce:^id(NSString *username,NSString *seccode,NSString *password){
            return @(username.length>=6&&seccode.length>=4&&password.length>=6);
        }];
    }else{
        RAC(confirmBtn,enabled) = [RACSignal combineLatest:@[username.rac_textSignal,seccode.rac_textSignal] reduce:^id(NSString *username,NSString *seccode){
            return @(username.length>=6&&seccode.length>=4);
        }];
    }
    
}

//收回键盘
-(void)tap
{
    [self.view endEditing:YES];
}

-(void)confirmAction
{
    if (kStringIsEmpty(username.text)) {
        if (_bindingType==1) {
            LRToast(@"请输入手机号");
        }else{
            LRToast(@"请输入邮箱");
        }
        
    }else if (kStringIsEmpty(seccode.text)){
        LRToast(@"请输入验证码");
    }else if (kStringIsEmpty(password.text)&&self.isUpdate){
        LRToast(@"请输入登录密码");
    }else{
        //检测帐号
        if (self.bindingType) {
            if (![username.text isValidPhone]) {
                LRToast(@"手机号有误");
                return;
            }
        }else{
            if (![username.text isValidEmail]) {
                LRToast(@"邮箱有误");
                return;
            }
        }
        if (self.isUpdate) {
            [self requestUpdateBindAccount];
        }else{
            [self requestImproveUserInfo];
        }
    }
}

-(void)getSeccode:(UIButton *)sender
{
    //检测帐号
    if (self.bindingType) {
        if (![username.text isValidPhone]) {
            LRToast(@"手机号有误");
            return;
        }
    }else{
        if (![username.text isValidEmail]) {
            LRToast(@"邮箱有误");
            return;
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account"] = username.text;
    NSString *str = AppendingString(AppendKey, username.text);
    NSString * str2 = [str md5String].lowercaseString;
    parameters[@"sign"] = str2;
    
    ShowHudOnly
    [HttpRequest getWithURLString:SendValidCode parameters:parameters success:^(id responseObject) {
        HiddenHudOnly
        LRToast(@"验证码已发送");
        //发送成功后
        [sender startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:WhiteColor countColor:WhiteColor];
    } failure:^(NSError *error) {
        HiddenHudOnly;
    }];
    
}

#pragma mark ----- UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == username) {
        [username resignFirstResponder];
        [seccode becomeFirstResponder];
    }else{
        [seccode resignFirstResponder];
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
//完善用户资料
-(void)requestImproveUserInfo
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *urlStr = User_bindMobile;
    if (self.bindingType) {
        parameters[@"mobile"] = username.text;
    }else{
        parameters[@"email"] = username.text;
        urlStr = User_bindEmail;
    }
    parameters[@"validCode"] = seccode.text;
    [HttpRequest postWithURLString:urlStr parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"绑定成功");
        GCDAfterTime(1, ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });

    } failure:nil RefreshAction:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//重置绑定手机或邮箱
-(void)requestUpdateBindAccount
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"account"] = username.text;
    parameters[@"validCode"] = seccode.text;
    parameters[@"password"] = password.text;

    [HttpRequest postWithURLString:User_updateBindAccount parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"重新绑定成功");
        GCDAfterTime(1, ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failure:nil RefreshAction:nil];
}






@end
