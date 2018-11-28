//
//  RegisterViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/15.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    TXLimitedTextField *username;   //账号
    TXLimitedTextField *nickname;   //昵称
    TXLimitedTextField *password;   //密码
    TXLimitedTextField *seccode;    //验证码
    TXLimitedTextField *promoteCode;//推广码
    UIButton *getCodeBtn;
    UIButton *registerBtn;
}
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@end

@implementation RegisterViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(void)dealloc
{
    GGLog(@"注册界面已释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationController.navigationBar.hidden = YES;
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI
{
    @weakify(self);
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
    backImg.image = UIImageNamed(@"login_backgroundImg");
    
    [backImg whenTap:^{
        @strongify(self)
        [self tap];
    }];
    
    UIButton *popBtn = [UIButton new];
    
    UILabel *title = [UILabel new];
    title.font = PFFontL(16);
    
    [backImg sd_addSubviews:@[
                              title,
                              popBtn
                              ]];
    title.sd_layout
    .centerXEqualToView(backImg)
    .topSpaceToView(backImg, StatusBarHeight)
    .heightIs(44)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:100];
    title.text = @"注册";
    
    popBtn.sd_layout
    .leftSpaceToView(backImg, 15)
    .centerYEqualToView(title)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    [popBtn setImage:UIImageNamed(@"return_left") forState:UIControlStateNormal];
    [[popBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //输入框
    username = [TXLimitedTextField new];
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    username.delegate = self;
//    username.limitedType = TXLimitedTextFieldTypeCustom;
//    username.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
//    username.limitedNumber = 11;
    
    nickname = [TXLimitedTextField new];
    nickname.clearButtonMode = UITextFieldViewModeWhileEditing;
    nickname.delegate = self;
    
    password = [TXLimitedTextField new];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.secureTextEntry = YES;
    password.delegate = self;
    
    UIView *seccodeBackView = [UIView new];
    seccodeBackView.backgroundColor = WhiteColor;
    
    seccode = [TXLimitedTextField new];
    seccode.clearButtonMode = UITextFieldViewModeWhileEditing;
    seccode.limitedType = TXLimitedTextFieldTypeCustom;
    seccode.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
    seccode.limitedNumber = 6;
    seccode.delegate = self;
    
    getCodeBtn = [UIButton new];
    getCodeBtn.titleLabel.font = PFFontL(14);
    [getCodeBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    promoteCode = [TXLimitedTextField new];
    promoteCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    promoteCode.delegate = self;
    
    registerBtn = [UIButton new];
    [registerBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    registerBtn.titleLabel.font = PFFontL(16);
    
    [backImg sd_addSubviews:@[
                              username,
                              nickname,
                              password,
                              seccodeBackView,
                              promoteCode,
                              registerBtn,
                              ]];
    username.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(title, 40)
    .heightIs(56)
    ;
    [username updateLayout];
    username.placeholder = @"请输入手机号或邮箱";
    [username addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    nickname.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(username, 0)
    .heightIs(56)
    ;
    [nickname updateLayout];
    nickname.limitedNumber = 10;
    nickname.placeholder = @"请输入昵称(最多10个字符)";
    [nickname addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    password.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(nickname, 0)
    .heightIs(56)
    ;
    [password updateLayout];
    password.placeholder = @"设置密码(6-16位数字和字母)";
    [password addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    seccodeBackView.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(password, 0)
    .heightIs(56)
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
    seccode.placeholder = @"请输入验证码";
    
    promoteCode.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(seccodeBackView, 0)
    .heightIs(56)
    ;
    [promoteCode updateLayout];
    promoteCode.placeholder = @"请输入推广码(选填)";
    [promoteCode addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    registerBtn.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(promoteCode, 57)
    .heightIs(50)
    ;
    [registerBtn setSd_cornerRadius:@25];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setBackgroundImage:UIImageNamed(@"login_confirmBackS") forState:UIControlStateNormal];
    
    //键盘监听
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.view, nil];
    }];
    
    //集合信号
    RAC(registerBtn,enabled) = [RACSignal combineLatest:@[username.rac_textSignal,nickname.rac_textSignal,password.rac_textSignal,seccode.rac_textSignal] reduce:^id(NSString *username,NSString *nickname,NSString *password,NSString *seccode){
        return @(username.length>=6&&nickname.length>=2&&password.length>=6&&seccode.length>=4);
    }];
}

//收回键盘
-(void)tap
{
    [self.view endEditing:YES];
}

-(void)getSeccode:(UIButton *)sender
{
    //检测帐号
    //先做邮箱判断
    if ([username.text containsString:@"@"]) {
        if (![username.text isValidEmail]) {
            LRToast(@"邮箱有误");
            return;
        }
        
    }else{
        if (![username.text isValidPhone]) {
            LRToast(@"手机号有误");
            return;
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account"] = username.text;
    NSString *str = AppendingString(AppendKey, username.text);
    NSString * str2 = [str md5String].lowercaseString;
    parameters[@"sign"] = str2;
    ShowHudOnly;
    
    [HttpRequest getWithURLString:SendValidCode parameters:parameters success:^(id responseObject) {
        LRToast(@"验证码已发送");
        HiddenHudOnly;
        
        //发送成功后
        [sender startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:WhiteColor countColor:WhiteColor];
    } failure:^(NSError *error) {
        HiddenHudOnly;
        
    }];
    
}

//注册操作
-(void)registerAction
{
    if (kStringIsEmpty(username.text)) {
        LRToast(@"请输入手机号/邮箱");
    }else if (kStringIsEmpty(nickname.text)){
        LRToast(@"请输入昵称(最多10个字符)");
    }else if (kStringIsEmpty(password.text)){
        LRToast(@"请输入密码(6-16位数字和字母)");
    }else if (kStringIsEmpty(seccode.text)){
        LRToast(@"请输入验证码");
    }else{
        //检测帐号
        //先做邮箱判断
        if ([username.text containsString:@"@"]) {
            if (![username.text isValidEmail]) {
                LRToast(@"邮箱有误");
                return;
            }
            
        }else{
            if (![username.text isValidPhone]) {
                LRToast(@"手机号有误");
                return;
            }
        }
        //此处再检测一下昵称
        if ([NSString isEmpty:nickname.text]||nickname.text.length>10) {
            LRToast(@"昵称为不能超过10位字符的任意字母下划线汉字的组合");
            return;
        }
        //再检测密码
        if ([password.text checkPassWord]) {
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            parameters[@"account"] = username.text;
            parameters[@"nickname"] = nickname.text;
            parameters[@"password"] = password.text;
            parameters[@"valid"] = seccode.text;
            parameters[@"source"] = @"2";
            parameters[@"promoCode"] = promoteCode.text;
            
            [HttpRequest postWithURLString:DoRegister parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
                LRToast(@"注册成功");
                GCDAfterTime(1, ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.registerSuccess) {
                        self.registerSuccess(self->username.text, self->password.text);
                    }
                });
            } failure:^(NSError *error) {
                LRToast(@"注册失败");
            }  RefreshAction:nil];
        }else{
            LRToast(@"密码为6-16位数字、字母和下划线组成");
        }
        
    }
}

#pragma mark ----- UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == username) {
        [username resignFirstResponder];
        [nickname becomeFirstResponder];
    }else if(textField == nickname){
        [nickname resignFirstResponder];
        [password becomeFirstResponder];
    }else if(textField == password){
        [password resignFirstResponder];
        [seccode becomeFirstResponder];
    }else{
        [seccode resignFirstResponder];
        [registerBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
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

@end
