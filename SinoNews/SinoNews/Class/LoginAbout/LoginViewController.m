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
    username.limitedType = TXLimitedTextFieldTypeCustom;
    
    password = [TXLimitedTextField new];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.delegate = self;
    
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
                              password,
                              forgetBtn,
                              confirmBtn,
                              ]];
    closeBtn.sd_layout
    .leftSpaceToView(backImg, 15)
    .topSpaceToView(backImg, 20)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    [closeBtn setImage:UIImageNamed(@"login_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    registBtn.sd_layout
    .rightSpaceToView(backImg, 15)
    .centerYEqualToView(closeBtn)
    .widthIs(32)
    .heightIs(16)
    ;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(pushRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat logoW = 88 * ScaleW;
    logo.sd_layout
    .topSpaceToView(backImg, 81)
    .centerXEqualToView(backImg)
    .widthIs(logoW)
    .heightEqualToWidth()
    ;
    [logo updateLayout];
//    logo.backgroundColor = Arc4randomColor;
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
    
    password.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(username, 0)
    .heightIs(56)
    ;
    [password updateLayout];
    password.placeholder = @"请输入密码";
    password.secureTextEntry = YES;
    [password addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    forgetBtn.sd_layout
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(password, 10)
    .widthIs(60)
    .heightIs(15)
    ;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(pushForgetVC) forControlEvents:UIControlEventTouchUpInside];
    
    confirmBtn.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(password, 57)
    .heightIs(50)
    ;
    [confirmBtn setSd_cornerRadius:@25];
    [confirmBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundImage:UIImageNamed(@"login_confirmBackS") forState:UIControlStateNormal];
    
    //集合信号
    RAC(confirmBtn,enabled) = [RACSignal combineLatest:@[username.rac_textSignal,password.rac_textSignal] reduce:^id(NSString *username,NSString *password){
        return @(username.length>=11&&password.length>=6);
    }];
    
}

//shou收回键盘 hui
-(void)tap
{
    [self.view endEditing:YES];
}

//跳转注册
-(void)pushRegisterVC
{
    RegisterViewController *rVC = [RegisterViewController new];
    [self.navigationController pushViewController:rVC animated:YES];
}

//跳转找回密码
-(void)pushForgetVC
{
    
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
            GGLog(@"发送登陆请求～");
        }else{
            LRToast(@"密码为6-20位数字、字母和下划线组成");
        }
        
    }
}

//返回
-(void)popAction
{
    [self.view endEditing:YES];
    if (self.normalBack) {
        if (self.backHandleBlock) {
            self.backHandleBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
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
    return YES;
}







@end
