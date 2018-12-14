//
//  RechargeViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RechargeViewController.h"


@interface RechargeViewController ()<UITextFieldDelegate>
{
    UIImageView *userIcon;  //头像
    UILabel     *userName;  //昵称
    UILabel     *integer;   //积分
    TXLimitedTextField *moneyInput;
    UIButton    *payBtn;    //充值按钮
    NSInteger   payType;    //充值方式
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *rechargeType;
@property (nonatomic,strong) NSMutableArray *payBtnArr;
@property (nonatomic,strong) NSMutableArray *moneyBtnArr;

@property (nonatomic ,strong) UserModel *user;

@end

@implementation RechargeViewController

-(NSMutableArray *)rechargeType
{
    if (!_rechargeType) {
        NSArray *title = @[
                           @"微信",
                           @"支付宝",
                           @"微信",
                           @"支付宝",
                           @"微信",
                           @"支付宝",
                           ];
        NSArray *img = @[
                         @"recharge_wechat",
                         @"recharge_alipay",
                         @"recharge_wechat",
                         @"recharge_alipay",
                         @"recharge_wechat",
                         @"recharge_alipay",
                         ];
        
        _rechargeType = [NSMutableArray new];
        for (int i = 0; i < title.count; i ++) {
            NSDictionary *dic = @{
                                  @"payTitle"   :   title[i],
                                  @"payImg"     :   img[i],
                                  };
            [_rechargeType addObject:dic];
        }
    }
    return _rechargeType;
}

-(NSMutableArray *)payBtnArr
{
    if (!_payBtnArr) {
        _payBtnArr = [NSMutableArray new];
    }
    return _payBtnArr;
}

-(NSMutableArray *)moneyBtnArr
{
    if (!_moneyBtnArr) {
        _moneyBtnArr = [NSMutableArray new];
    }
    return _moneyBtnArr;
}

-(UserModel *)user
{
    if (!_user) {
        _user = [UserModel getLocalUserModel];
    }
    return _user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值";

    
    
//    [self updatePayBtnStatus:0 endEdite:YES];
    
    //监听登录
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserLoginSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self requestToGetUserInfo];
    }];
    //监听退出
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserLoginOutNotify object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self updateDataSource];
    }];
    //监听积分变动
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserIntegralOrAvatarChanged object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        GGLog(@"积分-管理数据更新");
        [self updateDataSource];
    }];
    
//    if (self.user) {
//        [self setTopViews];
//    }else{
        [self requestToGetUserInfo];
//    }
    
    self.view.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noProduct" refreshBlock:^{
        @strongify(self);
        [self requestToGetUserInfo];
    }];
}

//更新
-(void)updateDataSource
{
    self.user = [UserModel getLocalUserModel];
    [self setTopViews];
}

//设置上部分数据
-(void)setTopViews
{
    [userIcon sd_setImageWithURL:UrlWithStr(GetSaveString(self.user.avatar))];
    userName.text = GetSaveString(self.user.username);
    [userName updateLayout];
    if (self.user.integral) {
        integer.text = [NSString stringWithFormat:@"%ld积分",self.user.integral];
    }else{
        integer.text = @"";
    }
    
    [integer updateLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addViews
{
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    [self.scrollView activateConstraints:^{
        self.scrollView.top_attr = self.view.top_attr_safe;
        self.scrollView.left_attr = self.view.left_attr_safe;
        self.scrollView.right_attr = self.view.right_attr_safe;
        self.scrollView.bottom_attr = self.view.bottom_attr_safe;
    }];
    [self.scrollView addBakcgroundColorTheme];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tap];
    
    [self setupTopViews];
//    [self setupCenterViews];
    [self setupBottomViews];
}

-(void)endEditing
{
    [self.view endEditing:YES];
}

//上部分
-(void)setupTopViews
{
    userIcon = [UIImageView new];
    userIcon.contentMode = 2;
    userIcon.layer.masksToBounds = YES;
    userName = [UILabel new];
    userName.font = FontScale(15);
    [userName addTitleColorTheme];
    
    integer = [UILabel new];
    integer.font = FontScale(15);
//    [integer addContentColorTheme];
    integer.textColor = HexColor(#1282EE);
    
    UIView *line = [UIView new];
    line.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        [(UIView *)item setBackgroundColor:CutLineColor];
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:CutLineColorNight];
        }
    });
    
    [self.scrollView sd_addSubviews:@[
                                      userIcon,
                                      userName,
                                      integer,
                                      line,
                                      ]];
    userIcon.sd_layout
    .leftSpaceToView(_scrollView, 10)
    .topSpaceToView(_scrollView, 10)
    .widthIs(44)
    .heightEqualToWidth()
    ;
    [userIcon setSd_cornerRadius:@22];
//    userIcon.image = UIImageNamed(@"userIcon");
    
    userName.sd_layout
    .leftSpaceToView(userIcon, 7)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(15))
    ;
    [userName setSingleLineAutoResizeWithMaxWidth:150];
//    userName.text = @"春风十里不如你";
    
    integer.sd_layout
    .rightSpaceToView(_scrollView, 10)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(14))
    ;
    [integer setSingleLineAutoResizeWithMaxWidth:150];
//    integer.text = @"1000000积分";
    
    line.sd_layout
    .topSpaceToView(userIcon, 10)
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .heightIs(1)
    ;
    
    
    [self.payBtnArr addObject:line];
}

//中部分
-(void)setupCenterViews
{
    UILabel *rechargeNotice = [UILabel new];
    rechargeNotice.font = FontScale(15);
    [rechargeNotice addTitleColorTheme];
    [self.scrollView sd_addSubviews:@[
                                      rechargeNotice,
                                      ]];
    rechargeNotice.sd_layout
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .topSpaceToView(userIcon, 20)
    .autoHeightRatio(0)
    ;
    [rechargeNotice updateLayout];
    rechargeNotice.text = @"充值方式";
    
    //构建支付按钮
    CGFloat lrMargin = 10;
    CGFloat tbMargin = 10;
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(rechargeNotice.frame) + 12;
    
    for (int i = 0; i < self.rechargeType.count; i ++) {
        if (i%3 == 0) {  //需要换行
            x = lrMargin;
            y += tbMargin;
        }else{          //不需要换行
            x +=lrMargin;
        }
        
        NSDictionary *dic = self.rechargeType[i];
        UIButton *title = [UIButton new];
        title.titleLabel.font = Font(15);
        
        title.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
            if (UserGetBool(@"NightMode")) {
                [(UIButton *)item setNormalTitleColor:value];
            }else{
                [(UIButton *)item setNormalTitleColor:RGBA(50, 50, 50, 1)];
            }
        });
        [title setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateSelected];
        [title setTitle:GetSaveString(dic[@"payTitle"]) forState:UIControlStateNormal];
        [title setImage:UIImageNamed(GetSaveString(dic[@"payImg"])) forState:UIControlStateNormal];
        title.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        title.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        title.frame = CGRectMake(x, y, (ScreenW - 4 * lrMargin)/3, 35);
        [self.scrollView addSubview:title];
        title.layer.cornerRadius = 4;
        title.layer.borderColor = RGBA(152, 152, 152, 1).CGColor;
        title.layer.borderWidth = 1;
        title.tag = 10010 + i;
        [title addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.payBtnArr addObject:title];
        
        x = CGRectGetMaxX(title.frame);
        if ((i + 1)%3 == 0) {
            y += CGRectGetHeight(title.frame);
        }
    }
    
    UIView *line = [UIView new];
    line.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        [(UIView *)item setBackgroundColor:CutLineColor];
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:CutLineColorNight];
        }
    });
    
    [self.scrollView addSubview:line];
    line.sd_layout
    .topSpaceToView(_scrollView, y + 15)
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .heightIs(1)
    ;
    
}

//下部分
-(void)setupBottomViews
{
//    UIButton *lastBtn = (UIButton *)[self.payBtnArr lastObject];
    UIView *lastBtn = (UIView *)[self.payBtnArr lastObject];
    UILabel *notice = [UILabel new];
    notice.font = FontScale(15);
    [notice addTitleColorTheme];
    notice.isAttributedContent = YES;
    
    [self.scrollView addSubview:notice];
    notice.sd_layout
    .topSpaceToView(lastBtn, 26)
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .autoHeightRatio(0)
    ;

    NSString *str1 = @"充值比例： 1元 = ";
    NSString *integer = @"100";
    NSString *str2 = @" 积分";
    NSString *totalStr = [[str1 stringByAppendingString:integer] stringByAppendingString:str2];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSDictionary *dic = @{
                          NSFontAttributeName : FontScale(15),
                          NSForegroundColorAttributeName : RGBA(18, 130, 238, 1),
                          
                          };
    [attStr addAttributes:dic range:NSMakeRange(str1.length, integer.length)];
    notice.attributedText = attStr;
    
    //输入框
    moneyInput = [TXLimitedTextField new];
    moneyInput.delegate = self;
    moneyInput.font = Font(21);
    moneyInput.textColor = RGBA(18, 130, 238, 1);
    
    moneyInput.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        [(TXLimitedTextField *)item setBackgroundColor:HexColor(#f6f6f6)];
        if (UserGetBool(@"NightMode")) {
            [(TXLimitedTextField *)item setBackgroundColor:HexColor(#292D30)];
        }
    });
    // 自定义输入限制类型
    moneyInput.limitedType = TXLimitedTextFieldTypeCustom;
    moneyInput.limitedRegExs = @[kTXLimitedTextFieldNumberOnlyRegex];
    // 限制输入长度
    moneyInput.limitedNumber = 5;
    // 保留整数位
    moneyInput.limitedPrefix = 5;
    // 保留小数位
    moneyInput.limitedSuffix = 0;
    
    [self.scrollView addSubview:moneyInput];
    
    moneyInput.sd_layout
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .topSpaceToView(notice, 20)
    .heightIs(45)
    ;
    
    [moneyInput setSd_cornerRadius:@16];
    NSString *placeholder = @"请输入充值金额";
    NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc]initWithString:placeholder];
    NSDictionary *attDic = @{
                          NSFontAttributeName : FontScale(15),
                          NSForegroundColorAttributeName : HexColor(#d1d1d1),
                          };
    [placeholderAtt addAttributes:attDic range:NSMakeRange(0, placeholder.length)];
    moneyInput.attributedPlaceholder = placeholderAtt;
    
    UIImageView *leftImg = [[UIImageView alloc]initWithImage:UIImageNamed(@"input_money")];
    leftImg.lee_theme.LeeConfigImage(@"integral_input_money");
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    leftImg.center = leftView.center;
    [leftView addSubview:leftImg];
    leftImg.sd_layout
    .rightSpaceToView(leftView, 10)
    .centerYEqualToView(leftView)
    .widthIs(15)
    .heightIs(20)
    ;
    
    moneyInput.leftViewMode = UITextFieldViewModeAlways;
    moneyInput.leftView = leftView;

    //金额直选
    NSArray *moneyArr = @[
                          @"100",
                          @"300",
                          @"500",
                          @"1000",
                          @"2000",
                          @"5000",
                          ];
    CGFloat lrMargin = 10;
    CGFloat xMargin = 5;
    CGFloat btnWid = (ScreenW - 2 * lrMargin - xMargin * (moneyArr.count - 1))/moneyArr.count;
    CGFloat btnHei = 30;
    CGFloat x = lrMargin;

    for (int i = 0; i < moneyArr.count; i ++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:moneyArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateSelected];
        
        btn.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
            UIButton *currentBtn = (UIButton *)item;
            if (UserGetBool(@"NightMode")) {
                [currentBtn setNormalTitleColor:value];
                currentBtn.layer.borderColor = [value CGColor];
            }else{
                [currentBtn setNormalTitleColor:RGBA(50, 50, 50, 1)];
                currentBtn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
            }
            if (currentBtn.selected == YES) {
                currentBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
            }
        });
        
        [self.scrollView addSubview:btn];
        btn.sd_layout
        .topSpaceToView(moneyInput, 20)
        .leftSpaceToView(self.scrollView, x)
        .widthIs(btnWid)
        .heightIs(btnHei)
        ;
        btn.layer.cornerRadius = 4;
        btn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = 10086 + i;
        [btn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.moneyBtnArr addObject:btn];
        x += xMargin + btnWid;
    }
    
    payBtn = [UIButton new];
    [self.scrollView addSubview:payBtn];
    payBtn.sd_layout
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .topSpaceToView((UIButton *)[self.moneyBtnArr lastObject], 50)
    .heightIs(45)
    ;
    [payBtn setTitleColor:RGBA(255, 254, 254, 1) forState:UIControlStateNormal];
    
    payBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        [(UIButton *)item setBackgroundColor:RGBA(144, 194, 243, 1)];
        if (UserGetBool(@"NightMode")) {
            [(UIButton *)item setBackgroundColor:HexColor(#0063C3)];
        }
    });
    
    payBtn.titleLabel.font = Font(16);
    [payBtn setSd_cornerRadius:@20];
    [payBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [self setpayBtnTitleWithString:@""];
    [payBtn addTarget:self action:@selector(goToPay:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)payAction:(UIButton *)btn
{
    if (btn.tag >= 10086) {
        [self updateMoneyBtnStatus:btn.tag - 10086 endEdite:YES];
    }else{
        [self updatePayBtnStatus:btn.tag - 10010 endEdite:YES];
    }
}

//修改支付方式的按钮状态
-(void)updatePayBtnStatus:(NSInteger)index endEdite:(BOOL)end
{
    if (end) {
        [self endEditing];
    }
    [self.payBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *payBtn = (UIButton*)obj;
        if (index == idx) {
            payBtn.selected = YES;
            payBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
            self->payType = idx;
        }else{
            payBtn.selected = NO;
            payBtn.layer.borderColor = RGBA(152, 152, 152, 1).CGColor;
        }
    }];
}
//修改支付金额的按钮状态
-(void)updateMoneyBtnStatus:(NSInteger)index endEdite:(BOOL)end
{
    if (end) {
        [self endEditing];
    }
    [self.moneyBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *moneyBtn = (UIButton*)obj;
        if (index == idx) {
            moneyBtn.selected = YES;
            moneyBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
            [self setpayBtnTitleWithString:moneyBtn.titleLabel.text];
            self->moneyInput.text = moneyBtn.titleLabel.text;
        }else{
            moneyBtn.selected = NO;
            if (UserGetBool(@"NightMode")) {
                moneyBtn.layer.borderColor = HexColor(#cfd3d6).CGColor;
            }else{
                moneyBtn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
            }   
        }
    }];
}

//充值
-(void)goToPay:(UIButton *)btn
{
    NSInteger money = [moneyInput.text integerValue];
    if (!kStringIsEmpty(moneyInput.text)&&money>0) {
//        NSDictionary *dic = self.rechargeType[payType];
//        NSString *str = [NSString stringWithFormat:@"充值金额为：%@,充值方式：%@",moneyInput.text,dic[@"payTitle"]];
//        LRToast(str);
        [self requestMall_rechargeWithAmount:[moneyInput.text doubleValue]];
    }else{
        LRToast(@"请填入需要的金额再进行充值");
    }
    
}

#pragma mark --- UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self updateMoneyBtnStatus:self.moneyBtnArr.count endEdite:NO];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self setpayBtnTitleWithString:textField.text];
    return YES;
}
//将数字转为文字
-(void)setpayBtnTitleWithString:(NSString *)text
{
    NSInteger money = [GetSaveString(text) integerValue];
    NSString *payStr;
    if (money) {
        payStr = [NSString stringWithFormat:@"立即充值 %ld 元（%ld 积分）",money,money*100];
    }else{
        payStr = @"立即充值";
    }
    [payBtn setTitle:payStr forState:UIControlStateNormal];
}

#pragma mark ---- 请求发送
//获取用户信息
-(void)requestToGetUserInfo
{
    @weakify(self)
    [HttpRequest getWithURLString:GetCurrentUserInformation parameters:@{} success:^(id responseObject) {
        @strongify(self)
        NSDictionary *data = responseObject[@"data"];
        //后台目前的逻辑是，如果没有登录，只给默认头像这一个字段,只能靠这个来判断
        if ([data allKeys].count>1) {
            UserModel *model = [UserModel mj_objectWithKeyValues:data];
            //覆盖之前保存的信息
            [UserModel coverUserData:model];
            self.user = model;
//            [self->userIcon sd_setImageWithURL:UrlWithStr(model.avatar)];
//            self->userName.text = GetSaveString(model.username);
//            [self->userName updateLayout];
//            self->integer.text = [NSString stringWithFormat:@"%ld积分",model.integral];
//            [self->integer updateLayout];
        }else{
            [UserModel clearLocalData];
//            [self->userIcon sd_setImageWithURL:UrlWithStr(GetSaveString(data[@"avatar"]))];
//            self->userName.text = @"";
//            self->integer.text = @"";
        }
        [self addViews];
        [self setTopViews];
    } failure:nil];
}

//积分充值
-(void)requestMall_rechargeWithAmount:(double)amount
{
    [HttpRequest postWithURLString:Mall_recharge parameters:@{@"amount":@(amount)} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        NSString *rechargeUrl = response[@"data"][@"rechargeUrl"];
        GGLog(@"充值地址：%@",rechargeUrl);
        NSString *result = [rechargeUrl getUTF8String];
        NSURL *url = UrlWithStr(result);
        [[UIApplication sharedApplication] openURL:url];
        /*
        WebViewController *wVC = [WebViewController new];
        wVC.baseUrl = rechargeUrl;
        [self.navigationController pushViewController:wVC animated:YES];
        */
    } failure:^(NSError *error) {
        
    } RefreshAction:^{
        
    }];
}

@end
