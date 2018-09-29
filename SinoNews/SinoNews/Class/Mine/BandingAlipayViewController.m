//
//  BandingAlipayViewController.m
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BandingAlipayViewController.h"

@interface BandingAlipayViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)TXLimitedTextField *account;
@property (nonatomic,strong)TXLimitedTextField *name;
@property (nonatomic,strong)UIButton *confirmBtn;   //绑定按钮
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@end

@implementation BandingAlipayViewController

-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![NSString isEmpty:self.aliModel.fullName]) {
        self.navigationItem.title = @"支付宝";
    }else{
        self.navigationItem.title = @"绑定支付宝";
    }
    self.view.backgroundColor = WhiteColor;
    [self setUI];
    @weakify(self);
    [self.view whenTap:^{
        @strongify(self);
        [self.view endEditing:YES];
    }];
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
    
    self.account = [TXLimitedTextField new];
    self.account.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.account.delegate = self;
    self.account.font = PFFontL(16);
    
    self.name = [TXLimitedTextField new];
    self.name.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.name.delegate = self;
    self.name.font = PFFontL(16);
    
    self.confirmBtn = [UIButton new];
    [self.confirmBtn setNormalTitleColor:WhiteColor];
    [self.confirmBtn setBtnFont:PFFontL(17)];
    self.confirmBtn.backgroundColor = HexColor(#3E9FFC);
    
    [self.view sd_addSubviews:@[
                                self.account,
                                accountLabel,
                                speLine1,
                                
                                self.name,
                                nameLabel,
                                speLine2,
                                
                                self.confirmBtn,
                                ]];
    self.account.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(self.view, 70)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
    self.account.placeholder = @"请输入支付宝账号";
    
    accountLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.account)
    .heightIs(16)
    ;
    [accountLabel setSingleLineAutoResizeWithMaxWidth:50];
    accountLabel.text = @"账号";
    
    speLine1.sd_layout
    .topSpaceToView(self.account, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    ;
    
    self.name.sd_layout
    .topEqualToView(speLine1)
    .leftSpaceToView(self.view, 70)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
    self.name.placeholder = @"请输入账号姓名";
    
    nameLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.name)
    .heightIs(16)
    ;
    [nameLabel setSingleLineAutoResizeWithMaxWidth:50];
    nameLabel.text = @"姓名";
    
    speLine2.sd_layout
    .topSpaceToView(self.name, 0)
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
    
    //键盘监听
    @weakify(self);
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.account,self.name, nil];
    }];
    
    if (![NSString isEmpty:self.aliModel.fullName]) {
        self.name.text = GetSaveString(self.aliModel.fullName);
        [self.confirmBtn removeFromSuperview];
    }
    UserModel *user = [UserModel getLocalUserModel];
    self.account.text = [NSString stringWithFormat:@"%ld",user.mobile];
}

-(void)confirmAction:(UIButton *)sender
{
    if ([NSString isEmpty:self.account.text]){
        LRToast(@"请输入支付宝账号");
    }else if([NSString isEmpty:self.name.text]){
        LRToast(@"请输入账号姓名");
    }else{
        //确认绑定
        ShowHudOnly;
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"fullName"] = self.name.text;
        [HttpRequest getWithURLString:SaveUserAlipay parameters:parameters success:^(id responseObject) {
            HiddenHudOnly;
            LRToast(@"绑定成功");
            GCDAfterTime(0.5, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            HiddenHudOnly;
        }];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![NSString isEmpty:self.aliModel.fullName]) {
        return NO;
    }
    if (textField==self.account) {
        return NO;
    }
    return YES;
}

@end
