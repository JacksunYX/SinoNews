//
//  EditAddressViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "EditAddressViewController.h"

@interface EditAddressViewController ()<UITextFieldDelegate>
{
    TXLimitedTextField *receiver;    //收件人姓名
    TXLimitedTextField *phoneNum;    //手机号
    UILabel *cityLabel;  //省/市/行政区
    TXLimitedTextField *detailAddress;  //详细地址
    
    UIButton *confirmBtn;
}

@property (nonatomic,copy) NSString *province;  //省
@property (nonatomic,copy) NSString *city;      //市
@property (nonatomic,copy) NSString *area;      //区


@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑地址";
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setUI
{
    [self.view creatTapWithSelector:@selector(tap)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(saveAdress) image:nil hightimage:nil andTitle:@"保存"];
    
    UIView *view0 = [self getBackViewWithNum:0];
    UIView *view1 = [self getBackViewWithNum:1];
    UIView *view2 = [self getBackViewWithNum:2];
    [view2 creatTapWithSelector:@selector(showCitySelectView)];
    UIView *view3 = [self getBackViewWithNum:3];
    
    [self.view sd_addSubviews:@[
                                 view0,
                                 view1,
                                 view2,
                                 view3,
                                 ]];

    receiver = [self getTextField];
    phoneNum = [self getTextField];
    phoneNum.limitedType = TXLimitedTextFieldTypeCustom;
    phoneNum.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
    phoneNum.limitedNumber = 11;
    
    detailAddress = [self getTextField];
    
    [view0 addSubview:receiver];
    receiver.sd_layout
    .topEqualToView(view0)
    .leftSpaceToView(view0, 10)
    .rightSpaceToView(view0, 10)
    .bottomEqualToView(view0)
    ;
    receiver.placeholder = @"收件人姓名";
    
    [view1 addSubview:phoneNum];
    phoneNum.sd_layout
    .topEqualToView(view1)
    .leftSpaceToView(view1, 10)
    .rightSpaceToView(view1, 10)
    .bottomEqualToView(view1)
    ;
    phoneNum.placeholder = @"手机号";
    
    UILabel *leftCity = [self getLabel];
    [view2 addSubview:leftCity];
    leftCity.sd_layout
    .topEqualToView(view2)
    .leftSpaceToView(view2, 10)
    .bottomEqualToView(view2)
    .widthIs((ScreenW - 20)/2)
    ;
    [leftCity setSingleLineAutoResizeWithMaxWidth:100];
    leftCity.text = @"省/市/行政区";
    
    cityLabel = [self getLabel];
    cityLabel.textAlignment = NSTextAlignmentRight;
    [view2 addSubview:cityLabel];
    cityLabel.sd_layout
    .topEqualToView(view2)
    .leftSpaceToView(leftCity, 10)
    .rightSpaceToView(view2, 10)
    .bottomEqualToView(view2)
//    .widthIs((ScreenW - 20)/2)
    ;
    
    UILabel *topAddress = [self getLabel];
    [view3 addSubview:topAddress];
    topAddress.sd_layout
    .topSpaceToView(view3, 14)
    .leftSpaceToView(view3, 10)
    .rightSpaceToView(view3, 10)
    .heightIs(15)
    ;
    topAddress.text = @"详细地址";
    
    detailAddress = [self getTextField];
    [view3 addSubview:detailAddress];
    detailAddress.sd_layout
    .topSpaceToView(topAddress, 5)
    .leftSpaceToView(view3, 10)
    .rightSpaceToView(view3, 10)
    .bottomSpaceToView(view3, 0)
    ;
    
}

//统一创建方法
-(UIView *)getBackViewWithNum:(NSInteger)num
{
    CGFloat height = 45;
    CGFloat space = 0;
    if (num == 3) {
        height = 74;
    }
    
    if (num>=3) {
        space = 74*(num - 3) + 45 *3;
    }else{
        space = 45 * num;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, space, ScreenW, height)];
    view.backgroundColor = WhiteColor;
    [view addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
    return view;
}

-(UILabel *)getLabel
{
    UILabel *label = [UILabel new];
    label.textColor = RGBA(152, 152, 152, 1);
    label.font = PFFontL(15);
    return label;
}

-(TXLimitedTextField *)getTextField
{
    TXLimitedTextField *textField = [TXLimitedTextField new];
    textField.font = PFFontL(15);
    textField.delegate = self;
    return textField;
}

//保存地址
-(void)saveAdress
{
    
    if (kStringIsEmpty(receiver.text)||[NSString isEmpty:receiver.text]) {
        LRToast(@"请输入收件人姓名~");
    }else if (kStringIsEmpty(phoneNum.text)||[NSString isEmpty:phoneNum.text]||![GetSaveString(phoneNum.text) isValidPhone]){
        LRToast(@"请输入正确的手机号~");
    }else if (kStringIsEmpty(cityLabel.text)){
        LRToast(@"请选择省/市/行政区～");
    }else if (kStringIsEmpty(detailAddress.text)||[NSString isEmpty:detailAddress.text]){
        LRToast(@"请输入详细地址～");
    }else{
        [self requestSaveAddress];
    }
}

//收回键盘
-(void)tap
{
    [self.view endEditing:YES];
}

//显示区域选择器
-(void)showCitySelectView
{
    @weakify(self)
    [self.view endEditing:YES];
    [CZHAddressPickerView areaPickerViewWithProvince:self.province city:self.city area:self.area areaBlock:^(NSString *province, NSString *city, NSString *area) {
        @strongify(self)
        self.province = province;
        self.city = city;
        self.area = area;
        NSString *addressStr;
        if (CompareString(province, city)) {
            addressStr = [NSString stringWithFormat:@"%@ %@",province,area];
        }else{
            addressStr = [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
        }
        self->cityLabel.text = addressStr;
    }];
}

#pragma mark ----- UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == receiver) {
        [receiver resignFirstResponder];
        [phoneNum becomeFirstResponder];
    }else{
        [self.view endEditing: YES];
    }
    return NO;
}

//检测空格
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
//    if (![string isEqualToString:tem]) {
//        return NO;
//    }
//    return YES;
//}

//禁止粘贴、全选
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    if (action == @selector(paste:))//禁止粘贴
//        return NO;
//    if (action == @selector(select:))// 禁止选择
//        return NO;
//    if (action == @selector(selectAll:))// 禁止全选
//        return NO;
    return [super canPerformAction:action withSender:sender];
}

#pragma mark ---- 请求发送
-(void)requestSaveAddress
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"consignee"] = receiver.text;
    parameters[@"mobile"] = phoneNum.text;
    //后台暂时没有地址库，只能先拼接了传过去
    parameters[@"fullAddress"] = [cityLabel.text stringByAppendingString:detailAddress.text];
    [HttpRequest postWithURLString:Mall_saveAddress parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"保存地址成功");
        GCDAfterTime(1.2, ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    } failure:nil RefreshAction:nil];
}




@end
