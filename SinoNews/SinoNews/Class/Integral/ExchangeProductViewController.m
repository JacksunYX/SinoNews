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
    topView.image = UIImageNamed(@"product_topBackImg");
    
    centerView.sd_layout
    .topSpaceToView(topView, 0)
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    .heightIs(138)
    ;
//    centerView.backgroundColor = YellowColor;
    
    bottomView.sd_layout
    .topSpaceToView(centerView, 0)
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    ;
    bottomView.backgroundColor = BlueColor;
    
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
    
}

@end
