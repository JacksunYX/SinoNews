//
//  ExchangeProductViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/28.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ExchangeProductViewController.h"

@interface ExchangeProductViewController ()

@end

@implementation ExchangeProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"商品兑换";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setUI
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    scrollView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    
    UIImageView *topView = [UIImageView new];
    UIView *centerView = [UIView new];
    UIView *bottomView = [UIView new];
    
    [scrollView sd_addSubviews:@[
                                 topView,
                                 centerView,
                                 bottomView,
                                 
                                 ]];
    topView.sd_layout
    .topEqualToView(scrollView)
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    .heightIs(175)
    ;
    [topView updateLayout];
    topView.image = UIImageNamed(@"product_topBackImg");
    
    centerView.sd_layout
    .topSpaceToView(topView, 0)
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    .heightIs(138)
    ;
    [centerView updateLayout];
    [centerView addBorderTo:BorderTypeBottom borderColor:RGBA(227, 227, 227, 1)];
//    centerView.backgroundColor = YellowColor;
    
    bottomView.sd_layout
    .topSpaceToView(centerView, 0)
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    ;
//    bottomView.backgroundColor = BlueColor;
    
    [self addTopViewWithView:topView];
    [self addCenterViewWithView:centerView];
    [self addBottomViewWithView:bottomView];
    
    [scrollView setupAutoContentSizeWithBottomView:bottomView bottomMargin:20];
}

-(void)addTopViewWithView:(UIView *)fatherView
{
    UIImageView *backImg = [UIImageView new];
    UILabel *productName = [UILabel new];
    productName.font = PFFontL(18);
    productName.textColor = WhiteColor;
    productName.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *productImg = [UIImageView new];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.font = PFFontL(14);
    leftLabel.textColor = RGBA(205, 183, 171, 1);
    leftLabel.numberOfLines = 0;
    
    [fatherView sd_addSubviews:@[
                                 backImg,
                                 productName,
                                 
                                 ]];
    backImg.sd_layout
    .topSpaceToView(fatherView, 22)
    .centerXEqualToView(fatherView)
    .widthIs(207)
    .heightIs(100)
    ;
    backImg.image = UIImageNamed(@"product_img");
    
    productName.sd_layout
    .topSpaceToView(backImg, 20)
    .centerXEqualToView(fatherView)
    .heightIs(18)
    ;
    [productName setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
    productName.text = @"优酷VIP会员一个月";
    
    [backImg sd_addSubviews:@[
                              productImg,
                              leftLabel,
                              ]];
    
    productImg.sd_layout
    .centerYEqualToView(backImg)
    .rightSpaceToView(backImg, 56)
    .widthIs(60)
    .heightEqualToWidth()
    ;
    productImg.backgroundColor = Arc4randomColor;
    
    leftLabel.sd_layout
    .leftSpaceToView(backImg, 16)
    .centerYEqualToView(backImg)
    .widthIs(14)
    .heightIs(40)
    ;
    leftLabel.text = @"礼\n券";
    
    
}

-(void)addCenterViewWithView:(UIView *)fatherView
{
    UIButton *exchangeBtn = [UIButton new];
    [exchangeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    exchangeBtn.titleLabel.font = PFFontL(18);
    exchangeBtn.backgroundColor = RGBA(255, 211, 5, 1);
    [exchangeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    
    UILabel *discountLabel = [UILabel new];
    discountLabel.textColor = RGBA(50, 50, 50, 1);
    discountLabel.font = PFFontL(15);
    discountLabel.isAttributedContent = YES;
    
    UIImageView *goldImg = [UIImageView new];
    goldImg.image = UIImageNamed(@"product_gold");
    
    [fatherView sd_addSubviews:@[
                                 exchangeBtn,
                                 discountLabel,
                                 goldImg,
                                 
                                 ]];
    
    exchangeBtn.sd_layout
    .topSpaceToView(fatherView, 30)
    .centerXEqualToView(fatherView)
    .widthIs(205)
    .heightIs(44)
    ;
    [exchangeBtn setSd_cornerRadius:@4];
    
    discountLabel.sd_layout
    .topSpaceToView(exchangeBtn, 24)
    .heightIs(15)
    .centerXEqualToView(fatherView)
    ;
    [discountLabel setSingleLineAutoResizeWithMaxWidth:ScreenW - 60];
    NSString *str1 = @"优惠价：";
    NSString *str2 = @"5000";
    NSMutableAttributedString *att1 = [NSString leadString:str1 tailString:str2 font:PFFontL(15) color:RGBA(250, 84, 38, 1) lineBreak:NO];
    
    NSString *str3 = @" 积分  ";
    NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc]initWithString:str3];
    
    NSString *str4 = @"原价55000积分";
    NSMutableAttributedString *att3 = [[NSMutableAttributedString alloc]initWithString:str4];
    NSDictionary *dic = @{
                          NSStrikethroughStyleAttributeName : @1,
                          NSStrikethroughColorAttributeName : RGBA(133, 133, 133, 1),
                          };
    [att3 addAttributes:dic range:NSMakeRange(0, att3.length)];
    
    [att1 appendAttributedString:att2];
    [att1 appendAttributedString:att3];
    
    discountLabel.attributedText = att1;
    
    goldImg.sd_layout
    .centerYEqualToView(discountLabel)
    .rightSpaceToView(discountLabel, 8)
    .widthIs(22)
    .heightEqualToWidth()
    ;
}

-(void)addBottomViewWithView:(UIView *)fatherView
{
    UITextField *pruductInfo1 = [self creatTextfield];
    UILabel *pruductInfo2 = [UILabel new];
    pruductInfo2.textColor = RGBA(50, 50, 50, 1);
    pruductInfo2.font = PFFontL(15);
    
    UITextField *validDate1 = [self creatTextfield];
    UILabel *validDate2 = [UILabel new];
    validDate2.textColor = RGBA(50, 50, 50, 1);
    validDate2.font = PFFontL(15);
    
    UITextField *useRaw1 = [self creatTextfield];
    UILabel *useRaw2 = [UILabel new];
    useRaw2.textColor = RGBA(50, 50, 50, 1);
    useRaw2.font = PFFontL(15);
    
    [fatherView sd_addSubviews:@[
                                 pruductInfo1,
                                 pruductInfo2,
                                 validDate1,
                                 validDate2,
                                 useRaw1,
                                 useRaw2,
                                 ]];
    pruductInfo1.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 20)
    .rightSpaceToView(fatherView, 10)
    .heightIs(20)
    ;
    pruductInfo1.text = @"商品介绍";
    
    pruductInfo2.sd_layout
    .topSpaceToView(pruductInfo1, 10)
    .leftSpaceToView(fatherView, 20)
    .rightSpaceToView(fatherView, 20)
    .autoHeightRatio(0)
    ;
    pruductInfo2.text = @"总价值15元的优酷VIP会员一个月";
    
    validDate1.sd_layout
    .topSpaceToView(pruductInfo2, 15)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs(20)
    ;
    validDate1.text = @"使用范围有效期";
    
    validDate2.sd_layout
    .topSpaceToView(validDate1, 10)
    .leftSpaceToView(fatherView, 20)
    .rightSpaceToView(fatherView, 20)
    .autoHeightRatio(0)
    ;
    validDate2.text = @"2018.6.10-7.30";
    
    useRaw1.sd_layout
    .topSpaceToView(validDate2, 15)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs(20)
    ;
    useRaw1.text = @"使用规则流程";
    
    useRaw2.sd_layout
    .topSpaceToView(useRaw1, 10)
    .leftSpaceToView(fatherView, 20)
    .rightSpaceToView(fatherView, 20)
    .autoHeightRatio(0)
    ;
    useRaw2.text = @"奖品数量有限，兑完即下架，先到先得哦～\n1.请在兑换之后七天内留下您的地址，过期视为放弃奖 品，将不再重新发放。 \n2.奖品将邮寄至您填写的地址，请正确填写信息。 \n3.无商品质量问题，兑换后不退不换";
    
    [fatherView setupAutoHeightWithBottomView:useRaw2 bottomMargin:10];
}

-(UITextField *)creatTextfield
{
    UITextField *textfield = [UITextField new];
    textfield.textColor = RGBA(152, 152, 152, 1);
    textfield.font = PFFontL(15);
    textfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIView *colorview = [[UIView alloc]initWithFrame:CGRectMake(8, 0, 4, 20)];
    colorview.backgroundColor = RGBA(255, 213, 170, 1);
    [leftView addSubview:colorview];
    textfield.leftView = leftView;
    return textfield;
}







@end
