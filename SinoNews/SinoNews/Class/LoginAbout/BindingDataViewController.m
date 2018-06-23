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
    UIButton *getCodeBtn;
    UIButton *confirmBtn;
}
@end

@implementation BindingDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.bindingType) {
        self.navigationItem.title = @"绑定手机";
    }else{
        self.navigationItem.title = @"绑定邮箱";
    }
    self.view.backgroundColor = WhiteColor;
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
//    backImg.image = UIImageNamed(@"login_backgroundImg");
    [backImg creatTapWithSelector:@selector(tap)];
    
    //输入框
    username = [TXLimitedTextField new];
    username.clearButtonMode = UITextFieldViewModeWhileEditing;
    username.delegate = self;
    
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
    
    confirmBtn = [UIButton new];
    [confirmBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = PFFontL(17);
    
    [backImg sd_addSubviews:@[
                              username,
                              seccodeBackView,
                              confirmBtn,
                              ]];
    username.sd_layout
    .topEqualToView(backImg)
    .leftSpaceToView(backImg, 10)
    .rightSpaceToView(backImg, 10)
    .heightIs(50)
    ;
    [username updateLayout];
    username.placeholder = @"请输入邮箱";
    if (self.bindingType) {
        username.placeholder = @"请输入手机/邮箱";
    }
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
    
    confirmBtn.sd_layout
    .leftSpaceToView(backImg, 24)
    .rightSpaceToView(backImg, 24)
    .topSpaceToView(seccodeBackView, 108)
    .heightIs(35)
    ;
    [confirmBtn setSd_cornerRadius:@4];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    //集合信号
    RAC(confirmBtn,enabled) = [RACSignal combineLatest:@[username.rac_textSignal,seccode.rac_textSignal] reduce:^id(NSString *username,NSString *seccode){
        return @(username.length>=6&&seccode.length>=4);
    }];
}

//收回键盘
-(void)tap
{
    [self.view endEditing:YES];
}

-(void)confirmAction
{
    GGLog(@"确认");
}

-(void)getSeccode:(UIButton *)sender
{
    //检测帐号
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
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account"] = username.text;
    
    [HttpRequest getWithURLString:SendValidCode parameters:parameters success:^(id responseObject) {
        LRToast(@"验证码已发送");
        //发送成功后
        [sender startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:WhiteColor countColor:WhiteColor];
    } failure:nil];
    
}













@end
