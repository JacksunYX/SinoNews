//
//  BandingBankCardViewController.m
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BandingBankCardViewController.h"

@interface BandingBankCardViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)TXLimitedTextField *cardNumber;
@property (nonatomic,strong)TXLimitedTextField *cardHolder;
@property (nonatomic,strong)UILabel *bankName;
@property (nonatomic,strong)TXLimitedTextField *openingBank;
@property (nonatomic,strong)NSString *oldNum;   //记录上次编辑的卡号
@property (nonatomic,strong)UIButton *confirmBtn;   //绑定按钮
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@end
static CGFloat noticMaxWidth = 100;
static CGFloat leftMargin = 110;
@implementation BandingBankCardViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡";
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
    accountLabel.textColor = HexColor(#1A1A1A);
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = PFFontL(16);
    nameLabel.textColor = HexColor(#1A1A1A);
    
    UILabel *banknameLabel = [UILabel new];
    banknameLabel.font = PFFontL(16);
    banknameLabel.textColor = HexColor(#1A1A1A);
    
    self.bankName = [UILabel new];
    self.bankName.font = PFFontR(16);
    self.bankName.textColor = HexColor(#3E9FFC);
    
    UILabel *openingBankLabel = [UILabel new];
    openingBankLabel.font = PFFontL(16);
    openingBankLabel.textColor = HexColor(#1A1A1A);
    
    //分割线
    UIView *speLine1 = [UIView new];
    [speLine1 addCutLineColor];
    UIView *speLine2 = [UIView new];
    [speLine2 addCutLineColor];
    UIView *speLine3 = [UIView new];
    [speLine3 addCutLineColor];
    UIView *speLine4 = [UIView new];
    [speLine4 addCutLineColor];
    
    self.cardNumber = [TXLimitedTextField new];
    self.cardNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cardNumber.delegate = self;
    self.cardNumber.font = PFFontL(16);
    self.cardNumber.limitedType = TXLimitedTextFieldTypeCustom;
    self.cardNumber.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
    
    self.cardHolder = [TXLimitedTextField new];
    self.cardHolder.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cardHolder.delegate = self;
    self.cardHolder.font = PFFontL(16);
    
    self.openingBank = [TXLimitedTextField new];
    self.openingBank.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.openingBank.delegate = self;
    self.openingBank.font = PFFontL(16);
    
    self.confirmBtn = [UIButton new];
    [self.confirmBtn setNormalTitleColor:WhiteColor];
    [self.confirmBtn setBtnFont:PFFontL(17)];
    self.confirmBtn.backgroundColor = HexColor(#3E9FFC);
    
    [self.view sd_addSubviews:@[
                                self.cardHolder,
                                nameLabel,
                                speLine2,
                                
                                self.cardNumber,
                                accountLabel,
                                speLine1,

                                self.bankName,
                                banknameLabel,
                                speLine3,
                                
                                self.openingBank,
                                openingBankLabel,
                                speLine4,
                                
                                self.confirmBtn,
                                ]];
    
    
    self.cardHolder.sd_layout
//    .topEqualToView(speLine1)
    .topEqualToView(self.view)
    .leftSpaceToView(self.view, leftMargin)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
    self.cardHolder.placeholder = @"请输入持卡人";
    
    nameLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.cardHolder)
    .heightIs(16)
    ;
    [nameLabel setSingleLineAutoResizeWithMaxWidth:noticMaxWidth];
    nameLabel.text = @"持卡人";
    
    speLine2.sd_layout
    .topSpaceToView(self.cardHolder, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    ;
    
    self.cardNumber.sd_layout
//    .topEqualToView(self.view)
    .topEqualToView(speLine2)
    .leftSpaceToView(self.view, leftMargin)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
    self.cardNumber.placeholder = @"请输入您本人的卡号";
    
    accountLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.cardNumber)
    .heightIs(16)
    ;
    [accountLabel setSingleLineAutoResizeWithMaxWidth:noticMaxWidth];
    accountLabel.text = @"卡号";
    
    speLine1.sd_layout
    .topSpaceToView(self.cardNumber, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    ;
    
    self.bankName.sd_layout
    .topEqualToView(speLine1)
    .leftSpaceToView(self.view, leftMargin)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
//    self.bankName.text = @"工商银行";
    @weakify(self);
    [self.bankName whenTap:^{
        @strongify(self);
        if ([self.bankName.text containsString:@"检测出错"]) {
            [self checkBankNum:self.cardNumber.text];
        }
    }];
    
    banknameLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.bankName)
    .heightIs(16)
    ;
    [banknameLabel setSingleLineAutoResizeWithMaxWidth:noticMaxWidth];
    banknameLabel.text = @"开户行";
    
    speLine3.sd_layout
    .topSpaceToView(self.bankName, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    ;
    
    self.openingBank.sd_layout
    .topEqualToView(speLine3)
    .leftSpaceToView(self.view, leftMargin)
    .rightSpaceToView(self.view, 10)
    .heightIs(50)
    ;
    self.openingBank.placeholder = @"格式:xxx支行";
    
    openingBankLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .centerYEqualToView(self.openingBank)
    .heightIs(16)
    ;
    [openingBankLabel setSingleLineAutoResizeWithMaxWidth:noticMaxWidth];
    openingBankLabel.text = @"银行网点";
    
    speLine4.sd_layout
    .topSpaceToView(self.openingBank, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(1)
    ;
    
    //键盘监听
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.cardNumber,self.cardHolder,self.openingBank, nil];
    }];
    
    self.confirmBtn.sd_layout
    .topSpaceToView(speLine4, 55)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(40)
    ;
    [self.confirmBtn setSd_cornerRadius:@4];
    [self.confirmBtn setNormalTitle:@"确认绑定"];
    [self.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    //记录
    self.oldNum = self.cardNumber.text;
}

-(void)confirmAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([NSString isEmpty:self.cardNumber.text]){
        LRToast(@"请输入银行卡号");
    }else if([NSString isEmpty:self.cardHolder.text]){
        LRToast(@"请输入持卡人姓名");
    }else if([NSString isEmpty:self.openingBank.text]){
        LRToast(@"请输入开户行名称");
    }else if([NSString isEmpty:self.bankName.text]||![self.bankName.text containsString:@"银行"]){
        LRToast(@"银行名称有误");
    }else{
        //确认绑定
        [self addBankCard];
    }
}

#pragma mark --- UITextfieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.cardNumber) {
        GGLog(@"卡号结束编辑");
        
        //先检测是否为空
        if (![NSString isEmpty:textField.text]) {
            //再判断是否有旧值，且新值位数小于6
            if (![NSString isEmpty:self.oldNum]) {
                if (textField.text.length<6) {
                    //提醒输入正确的卡号
                    self.bankName.text = @"请输入正确的卡号";
                }else{
                    //检测是否前后2个值相等
                    if (!CompareString(textField.text, self.oldNum)) {
                        //触发卡号检测，然后记录
                        self.oldNum = textField.text;
                        //发送检测请求
                        [self checkBankNum:self.oldNum];
                    }
                }
            }else{
                self.bankName.text = @"";
                if (textField.text.length<6) {
                    //提醒输入正确的卡号
                    self.bankName.text = @"请输入正确的卡号";
                }else{
                    //触发卡号检测，然后记录
                    self.oldNum = textField.text;
                    //发送检测请求
                    [self checkBankNum:self.oldNum];
                }
            }
        }else{
            //提醒输入正确的卡号
            self.bankName.text = @"请输入正确的卡号";
        }
    }
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


#pragma mark --- 网络请求
//检测卡号正确性及银行归属
-(void)checkBankNum:(NSString *)num
{
    self.bankName.text = @"卡号检测中...";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"cardNo"] = GetSaveString(self.cardNumber.text);
    [HttpRequest getWithURLString:CheckBankCard parameters:parameters success:^(id responseObject) {
        HiddenHudOnly;
        self.bankName.text = responseObject[@"data"];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
        self.bankName.text = @"检测出错，点击重试";
    }];
}

//添加银行卡信息
-(void)addBankCard
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"cardNo"] = GetSaveString(self.cardNumber.text);
    parameters[@"cardholderName"] = GetSaveString(self.cardHolder.text);
    parameters[@"bankName"] = GetSaveString(self.bankName.text);
    parameters[@"depositBankName"] = GetSaveString(self.openingBank.text);
    
    [HttpRequest postWithURLString:AddBankCard parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"绑定成功");
        GCDAfterTime(0.5, ^{
            if (self.refreshCard) {
                self.refreshCard();
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:nil RefreshAction:nil];
}

@end
