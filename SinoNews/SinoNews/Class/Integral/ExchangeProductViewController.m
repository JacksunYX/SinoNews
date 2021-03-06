//
//  ExchangeProductViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/28.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ExchangeProductViewController.h"
#import "ProductDetailModel.h"

@interface ExchangeProductViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
{
    CGFloat topWebHeight;
}
@property(nonatomic,strong) ProductDetailModel *productModel;
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation ExchangeProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"商品兑换";
    
    [self requestGetProduct];
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
    .bottomSpaceToView(self.view, 0)
    ;
    [scrollView updateLayout];
    
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
    .heightIs(153)
    ;
    [centerView updateLayout];
    if (UserGetBool(@"NightMode")) {
        [centerView addBorderTo:BorderTypeBottom borderColor:CutLineColorNight];
    }else{
       [centerView addBorderTo:BorderTypeBottom borderColor:CutLineColor];
    }
    
//    centerView.backgroundColor = YellowColor;
    
    bottomView.sd_layout
    .topSpaceToView(centerView, 5)
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    ;
//    bottomView.backgroundColor = BlueColor;
    
    [self addTopViewWithView:topView];
    [self addCenterViewWithView:centerView];
//    [self addBottomViewWithView:bottomView];
    [self setWebViewLoadWithView:bottomView];
    
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
    productName.text = GetSaveString(self.productModel.productName);
    
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
    [productImg sd_setImageWithURL:UrlWithStr(GetSaveString(self.productModel.imageUrl))];
//    productImg.backgroundColor = Arc4randomColor;
    
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
    @weakify(self)
    [[exchangeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([YXHeader checkLogin]) {
            [self popBuyNotice];
        }
    }];
    
    UILabel *discountLabel = [UILabel new];
//    discountLabel.textColor = RGBA(50, 50, 50, 1);
    [discountLabel addTitleColorTheme];
    discountLabel.font = PFFontL(15);
    discountLabel.isAttributedContent = YES;
    
    UILabel *stock = [UILabel new];
    stock.textColor = HexColor(#989898);
    stock.font = PFFontL(14);
    
    UIImageView *goldImg = [UIImageView new];
    goldImg.image = UIImageNamed(@"product_gold");
    
    [fatherView sd_addSubviews:@[
                                 exchangeBtn,
                                 discountLabel,
                                 goldImg,
                                 stock,
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
    NSString *str2 ;
    if (self.productModel.specialPrice) {
        str2 = [NSString stringWithFormat:@"%ld",self.productModel.specialPrice];
    }else{
        str2 = [NSString stringWithFormat:@"%ld",self.productModel.price];
    }
    NSMutableAttributedString *att1 = [NSString leadString:str1 tailString:str2 font:PFFontL(15) color:RGBA(250, 84, 38, 1) lineBreak:NO];
    NSString *str3 = @" 积分  ";
    
    NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc]initWithString:str3];
    NSString *str4 = [NSString stringWithFormat:@"原价%ld积分",self.productModel.price];
    NSMutableAttributedString *att3 = [NSString leadString:@"" tailString:str4 font:PFFontL(15) color:RGBA(152, 152, 152, 1) lineBreak:NO];
    
    NSDictionary *dic = @{
                          //删除线
                          NSStrikethroughStyleAttributeName : @1,
                          NSStrikethroughColorAttributeName : RGBA(133, 133, 133, 1),
                          };
    [att3 addAttributes:dic range:NSMakeRange(0, att3.length)];
    
    [att1 appendAttributedString:att2];
    if (self.productModel.specialPrice) {
        [att1 appendAttributedString:att3];
    }
    
    discountLabel.attributedText = att1;
    
    goldImg.sd_layout
    .centerYEqualToView(discountLabel)
    .rightSpaceToView(discountLabel, 8)
    .widthIs(22)
    .heightEqualToWidth()
    ;
    
    stock.sd_layout
//    .leftEqualToView(discountLabel)
    .centerXEqualToView(fatherView)
    .topSpaceToView(goldImg, 5)
    .heightIs(14)
    ;
    [stock setSingleLineAutoResizeWithMaxWidth:250];
    stock.text = [NSString stringWithFormat:@"库存：%ld",self.productModel.stock];
}

-(void)addBottomViewWithView:(UIView *)fatherView
{
    UITextField *pruductInfo1 = [self creatTextfield];
    UILabel *pruductInfo2 = [UILabel new];
//    pruductInfo2.textColor = RGBA(50, 50, 50, 1);
    [pruductInfo2 addContentColorTheme];
    pruductInfo2.font = PFFontL(15);
    
    UITextField *validDate1 = [self creatTextfield];
    UILabel *validDate2 = [UILabel new];
//    validDate2.textColor = RGBA(50, 50, 50, 1);
    [validDate2 addContentColorTheme];
    validDate2.font = PFFontL(15);
    
    UITextField *useRaw1 = [self creatTextfield];
    UILabel *useRaw2 = [UILabel new];
//    useRaw2.textColor = RGBA(50, 50, 50, 1);
    [useRaw2 addContentColorTheme];
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

//购买弹框提示
-(void)popBuyNotice
{
    UIAlertController *payPopVc = [UIAlertController alertControllerWithTitle:@"确认购买这件商品?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestBuyProduct];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [payPopVc addAction:confirm];
    [payPopVc addAction:cancel];
    [self presentViewController:payPopVc animated:YES completion:nil];
}

//设置网页
-(void)setWebViewLoadWithView:(UIView *)fatherView
{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0]. appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    // 设置字体大小(最小的字体大小)
    preference.minimumFontSize = [GetCurrentFont contentFont].pointSize;
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = wkUController;
    //    // 设置偏好设置对象
    //    config.preferences = preference;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    [fatherView addSubview:self.webView];
    
    self.webView.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs(0)
    ;
    [fatherView setupAutoHeightWithBottomView:self.webView bottomMargin:0];
    
    //KVO监听web的高度变化
    @weakify(self)
    [RACObserve(self.webView.scrollView, contentSize) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //        GGLog(@"x:%@",x);
        CGFloat newHeight = self.webView.scrollView.contentSize.height;
        if (newHeight != self->topWebHeight) {
            self->topWebHeight = newHeight;
//            GGLog(@"webHeight:%lf",self->topWebHeight);
            self.webView.sd_layout
            .topSpaceToView(fatherView, 10)
            .leftSpaceToView(fatherView, 10)
            .rightSpaceToView(fatherView, 10)
            .heightIs(self->topWebHeight)
            ;
            
        }
    }];
    self.webView.userInteractionEnabled = NO;
    //加载内容
//    [self.webView loadHTMLString:self.productModel.productDescription baseURL:nil];
    NSString *urlStr = AppendingString(DomainString, self.productModel.descriptionUrl);
    GGLog(@"文章h5：%@",urlStr);
    NSString *result = [urlStr getUTF8String];
    NSURL *url = UrlWithStr(result);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
}

#pragma mark ---- 请求发送
//获取商品详情
-(void)requestGetProduct
{
    @weakify(self)
    [HttpRequest getWithURLString:Mall_product parameters:@{@"productId":GetSaveString(self.productId)} success:^(id responseObject) {
        @strongify(self)
        self.productModel = [ProductDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self setUI];
    } failure:nil];
}

//购买商品
-(void)requestBuyProduct
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"productId"] = @(self.productModel.productId);
    
    [HttpRequest postWithURLString:Mall_buy parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        
        UserModel *user = [UserModel getLocalUserModel];
        user.integral = [response[@"data"][@"remainPoints"] longValue];
        [UserModel coverUserData:user];
        //暂时使用登录的监听，只为有积分展示的界面会重新获取用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:UserIntegralOrAvatarChanged object:nil];
        
        NSString *coupon = response[@"data"][@"coupon"];
        [self popPaySuccessWithCoupon:coupon];
    } failure:nil RefreshAction:nil];
}

//虚拟商品返回券号不为空则需要弹窗提示，可以点击按钮复制券号
-(void)popPaySuccessWithCoupon:(NSString *)coupon
{
    if (coupon) {
        UIAlertController *popVC = [UIAlertController alertControllerWithTitle:@"您可以在“管理”->“兑换记录“中查看兑换详情" message:AppendingString(@"卡号：", coupon) preferredStyle:UIAlertControllerStyleAlert];
        
        //修改message字体颜色
        NSString *messageString = AppendingString(@"卡号：", coupon);
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:messageString];
        NSDictionary *dic = @{
                              NSForegroundColorAttributeName:GrayColor,
                              NSFontAttributeName:PFFontL(15),
                              };
        [alertControllerMessageStr addAttributes:dic range:NSMakeRange(0, messageString.length)];
        
        [popVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *copy = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = coupon;
            LRToast(@"卡号已复制");
            GCDAfterTime(1, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        
        [popVC addAction:confirm];
        [popVC addAction:copy];
        
        [self presentViewController:popVC animated:YES completion:nil];
    }else{
        LRToast(@"购买成功");
        GCDAfterTime(1, ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}


@end
