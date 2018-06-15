//
//  LoginViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/15.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    TXLimitedTextField *username;
    TXLimitedTextField *password;
    UIButton *secureBtn;    //密码可视
    UIButton *forgetBtn;
    UIButton *confirmBtn;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登陆";
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [backImg updateLayout];
    backImg.backgroundColor = WhiteColor;
    backImg.image = UIImageNamed(@"login_backgroundImg");
    [backImg creatTapWithSelector:@selector(tap)];
    
    //其他控件
    UIButton *closeBtn = [UIButton new];
    UIButton *registBtn = [UIButton new];
    registBtn.titleLabel.font = PFFontL(16);
    [registBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    UIImageView *logo = [UIImageView new];
    
    username = [TXLimitedTextField new];
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    username.delegate = self;
    
    UIView *passwordBackView = [UIView new];
    passwordBackView.backgroundColor = WhiteColor;
    
    password = [TXLimitedTextField new];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.delegate = self;
    
    secureBtn = [UIButton new];
    
    confirmBtn = [UIButton new];
    [confirmBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = PFFontL(16);
    
    forgetBtn = [UIButton new];
    [forgetBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = PFFontL(12);
    
    [backImg sd_addSubviews:@[
                              closeBtn,
                              registBtn,
                              logo,
                              username,
                              passwordBackView,
                              forgetBtn,
                              confirmBtn,
                              ]];
    closeBtn.sd_layout
    .leftSpaceToView(backImg, 15)
    .topSpaceToView(backImg, StatusBarHeight)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    [closeBtn setImage:UIImageNamed(@"login_close") forState:UIControlStateNormal];
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.view endEditing:YES];
        if (self.normalBack) {
            if (self.backHandleBlock) {
                self.backHandleBlock();
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    registBtn.sd_layout
    .rightSpaceToView(backImg, 15)
    .centerYEqualToView(closeBtn)
    .widthIs(32)
    .heightIs(16)
    ;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [[registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        RegisterViewController *rVC = [RegisterViewController new];
        [self.navigationController pushViewController:rVC animated:YES];
    }];
    
    CGFloat logoW = 88 * ScaleW;
    logo.sd_layout
    .topSpaceToView(backImg, 81)
    .centerXEqualToView(backImg)
    .widthIs(logoW)
    .heightEqualToWidth()
    ;
    [logo updateLayout];
    [logo setSd_cornerRadius:@(logoW/2)];
    logo.image = UIImageNamed(@"login_logo");
    
    username.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(logo, 20)
    .heightIs(56)
    ;
    [username updateLayout];
    username.placeholder = @"请输入手机/邮箱";
    [username addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    passwordBackView.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(username, 0)
    .heightIs(56)
    ;
    [passwordBackView updateLayout];
    [passwordBackView addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    [passwordBackView sd_addSubviews:@[
                                       secureBtn,
                                       password,
                                       
                                       ]];
    
    secureBtn.sd_layout
    .centerYEqualToView(passwordBackView)
    .rightEqualToView(passwordBackView)
    .widthIs(22)
    .heightIs(15)
    ;
    [secureBtn setImage:UIImageNamed(@"login_invisible") forState:UIControlStateNormal];
    [secureBtn setImage:UIImageNamed(@"login_visible") forState:UIControlStateSelected];
    [[secureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        GGLog(@"x:%@",x);
        self->secureBtn.selected = !self->secureBtn.selected;
        self->password.secureTextEntry = !self->secureBtn.selected;
        
    }];
    
    password.sd_layout
    .leftEqualToView(passwordBackView)
    .topEqualToView(passwordBackView)
    .bottomEqualToView(passwordBackView)
    .rightSpaceToView(secureBtn, 0)
    ;
    password.placeholder = @"请输入密码";
    
    forgetBtn.sd_layout
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(passwordBackView, 10)
    .widthIs(60)
    .heightIs(15)
    ;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [[forgetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ForgetPasswordViewController *fpVC = [ForgetPasswordViewController new];
        [self.navigationController pushViewController:fpVC animated:YES];
    }];
    
    confirmBtn.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(passwordBackView, 57)
    .heightIs(50)
    ;
    [confirmBtn setSd_cornerRadius:@25];
    [confirmBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundImage:UIImageNamed(@"login_confirmBackS") forState:UIControlStateNormal];
    
    //集合信号
    RAC(confirmBtn,enabled) = [RACSignal combineLatest:@[username.rac_textSignal,password.rac_textSignal] reduce:^id(NSString *username,NSString *password){
        return @(username.length>=6&&password.length>=6);
    }];
    
}

//收回键盘
-(void)tap
{
    [self.view endEditing:YES];
}

//确认登陆操作
-(void)confirmAction
{
    if (kStringIsEmpty(username.text)) {
        LRToast(@"账号不能为空！");
    }else if (kStringIsEmpty(password.text)){
        LRToast(@"密码不能为空！");
    }else{
        //先检测帐号
        //先做邮箱判断
        if ([username.text containsString:@"@"]) {
            if (![username.text isValidEmail]) {
                LRToast(@"邮箱有误！");
                return;
            }
            
        }else{
            if (![username.text isValidPhone]) {
                LRToast(@"手机号有误！");
                return;
            }
        }
        //再检测密码
        if ([password.text checkPassWord]) {
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            parameters[@"account"] = username.text;
            parameters[@"password"] = password.text;
            
            [HttpRequest postWithURLString:Login parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
                LRToast(@"登陆成功");
                GCDAfterTime(1, ^{
                    if (self.normalBack) {
                        if (self.backHandleBlock) {
                            self.backHandleBlock();
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                });
            } failure:^(NSError *error) {
                LRToast(@"登陆失败");
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
        [password becomeFirstResponder];
    }else{
        [password resignFirstResponder];
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



@end
