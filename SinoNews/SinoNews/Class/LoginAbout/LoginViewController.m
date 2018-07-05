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
@property (nonatomic,strong)TXLimitedTextField *username;
@property (nonatomic,strong)TXLimitedTextField *password;
@property (nonatomic,strong)UIButton *secureBtn;    //密码可视
@property (nonatomic,strong)UIButton *forgetBtn;
@property (nonatomic,strong)UIButton *confirmBtn;
@end

@implementation LoginViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    self.username = [TXLimitedTextField new];
    self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.username.delegate = self;
    
    UIView *passwordBackView = [UIView new];
    passwordBackView.backgroundColor = WhiteColor;
    
    self.password = [TXLimitedTextField new];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    
    self.secureBtn = [UIButton new];
    
    self.confirmBtn = [UIButton new];
    [self.confirmBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = PFFontL(16);
    
    self.forgetBtn = [UIButton new];
    [self.forgetBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.font = PFFontL(12);
    
    [backImg sd_addSubviews:@[
                              closeBtn,
                              registBtn,
                              logo,
                              self.username,
                              passwordBackView,
                              self.forgetBtn,
                              self.confirmBtn,
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
        [self popAction];
    }];
 
    registBtn.sd_layout
    .rightSpaceToView(backImg, 15)
    .centerYEqualToView(closeBtn)
    .widthIs(32)
    .heightIs(16)
    ;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [[registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
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
    
    self.username.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(logo, 20)
    .heightIs(56)
    ;
    [self.username updateLayout];
    self.username.placeholder = @"请输入手机/邮箱";
    [self.username addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    passwordBackView.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(self.username, 0)
    .heightIs(56)
    ;
    [passwordBackView updateLayout];
    [passwordBackView addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    
    [passwordBackView sd_addSubviews:@[
                                       self.secureBtn,
                                       self.password,
                                       
                                       ]];
    
    self.secureBtn.sd_layout
    .centerYEqualToView(passwordBackView)
    .rightEqualToView(passwordBackView)
    .widthIs(22)
    .heightIs(15)
    ;
    [self.secureBtn setImage:UIImageNamed(@"login_invisible") forState:UIControlStateNormal];
    [self.secureBtn setImage:UIImageNamed(@"login_visible") forState:UIControlStateSelected];
    [[self.secureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.secureBtn.selected = !self.secureBtn.selected;
        self.password.secureTextEntry = !self.secureBtn.selected;
        
    }];
    
    self.password.sd_layout
    .leftEqualToView(passwordBackView)
    .topEqualToView(passwordBackView)
    .bottomEqualToView(passwordBackView)
    .rightSpaceToView(self.self.secureBtn, 0)
    ;
    self.password.placeholder = @"请输入密码";
    
    self.forgetBtn.sd_layout
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(passwordBackView, 10)
    .widthIs(60)
    .heightIs(15)
    ;
    [self.forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [[self.forgetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ForgetPasswordViewController *fpVC = [ForgetPasswordViewController new];
        [self.navigationController pushViewController:fpVC animated:YES];
    }];
    
    self.confirmBtn.sd_layout
    .leftSpaceToView(backImg, 30)
    .rightSpaceToView(backImg, 30)
    .topSpaceToView(passwordBackView, 57)
    .heightIs(50)
    ;
    [self.confirmBtn setSd_cornerRadius:@25];
    [self.confirmBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setBackgroundImage:UIImageNamed(@"login_confirmBackS") forState:UIControlStateNormal];
    
    //集合信号
    RAC(self.confirmBtn,enabled) = [RACSignal combineLatest:@[self.username.rac_textSignal,self.password.rac_textSignal] reduce:^id(NSString *username,NSString *password){
        return @(username.length>=6&&password.length>=6);
    }];
    
}

-(void)popAction
{
    [self.view endEditing:YES];
    if (self.normalBack) {
        if (self.backHandleBlock) {
            self.backHandleBlock();
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//收回键盘
-(void)tap
{
    [self.view endEditing:YES];
}

//确认登陆操作
-(void)confirmAction
{
    if (kStringIsEmpty(self.username.text)) {
        LRToast(@"账号不能为空！");
    }else if (kStringIsEmpty(self.password.text)){
        LRToast(@"密码不能为空！");
    }else{
        //先检测帐号
        //先做邮箱判断
        if ([self.username.text containsString:@"@"]) {
            if (![self.username.text isValidEmail]) {
                LRToast(@"邮箱有误！");
                return;
            }
            
        }else{
            if (![self.username.text isValidPhone]) {
                LRToast(@"手机号有误！");
                return;
            }
        }
        //再检测密码
        if ([self.password.text checkPassWord]) {
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            parameters[@"account"] = self.username.text;
            parameters[@"password"] = self.password.text;
            
            [HttpRequest postWithURLString:Login parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
                LRToast(@"登陆成功");
                [YXHeader loginSuccessSaveWithData:response];
                GCDAfterTime(1, ^{
                    [self popAction];
                });
            } failure:nil  RefreshAction:nil];
        }else{
            LRToast(@"密码为6-16位数字、字母和下划线组成");
        }
        
    }
}

#pragma mark ----- UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.username) {
        [self.username resignFirstResponder];
        [self.password becomeFirstResponder];
    }else{
        [self.password resignFirstResponder];
        [self.confirmBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return NO;
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
