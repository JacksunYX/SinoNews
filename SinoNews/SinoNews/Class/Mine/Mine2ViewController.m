//
//  Mine2ViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/26.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "Mine2ViewController.h"
#import "SignInViewController.h"
#import "PersonalDataViewController.h"
#import "SettingViewController.h"
#import "NewSettingViewController.h"
#import "MyAttentionViewController.h"
#import "MyFansViewController.h"

#import "Mine2FirstTableViewCell.h"
#import "Mine2SecondTableViewCell.h"
#import "SharePopCopyView.h"
#import "PraisePopView.h"

@interface Mine2ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *shakeImg;
}
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *mainDatasource;

//用户信息
@property (nonatomic ,strong) UIImageView *userImg;
@property (nonatomic ,strong) UILabel *userName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic ,strong) UILabel *integral;
@property (nonatomic ,strong) UILabel *level;   //等级
@property (nonatomic ,strong) UIButton *messageBtn; //消息
@property (nonatomic ,strong) UIButton *signIn;

@property (nonatomic ,strong) UIButton *attention;   //关注
@property (nonatomic ,strong) UIButton *praise;      //获赞
@property (nonatomic ,strong) UIButton *fans;        //粉丝

@property (nonatomic ,strong) UserModel *user;
@property (nonatomic ,strong) MineTipsModel *tipsmodel;    //保存提示信息

@end

@implementation Mine2ViewController
//金币重力弹跳动画效果
void shakerAnimation2 (UIView *view ,NSTimeInterval duration,float height){
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTx = view.transform.ty;
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    animation.values = @[@(currentTx), @(currentTx + height), @(currentTx + height/3*2), @(currentTx), @(currentTx + height/3), @(currentTx)];
    animation.keyTimes = @[ @(0), @(0.3), @(0.5), @(0.7), @(0.9), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

-(NSMutableArray *)mainDatasource
{
    if (!_mainDatasource) {
        _mainDatasource = [NSMutableArray new];
        NSMutableArray *section0 = [NSMutableArray new];
        NSMutableDictionary *section1 = [NSMutableDictionary new];
        NSMutableDictionary *section2 = [NSMutableDictionary new];
        NSMutableArray *section3 = [NSMutableArray new];
        
        [_mainDatasource addObjectsFromArray:@[
                                               section0,
                                               section1,
                                               section2,
                                               section3,
                                               
                                               ]];
        //分区1
        section1[@"title"] = @"个人服务";
        NSArray *subTitle = @[
                              @"我的帖子",
                              @"我的新闻",
                              @"我的收藏",
                              @"浏览历史",
                              ];
        NSArray *icon = @[
                          @"myPost_icon",
                          @"myNews_icon",
                          @"myCollects_icon",
                          @"myHistory_icon",
                          ];
        NSMutableArray *section1Arr = [NSMutableArray new];
        for (int i = 0; i < subTitle.count; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"subTitle"] = subTitle[i];
            dic[@"icon"] = icon[i];
            [section1Arr addObject:dic];
        }
        section1[@"dataArr"] = section1Arr;
        
        //分区2
        section2[@"title"] = @"积分功能";
        NSArray *subTitle2 = @[
                               @"积分充值",
                               @"积分游戏",
                               @"积分商城",
                               @"积分管理",
                               ];
        NSArray *icon2 = @[
                          @"myIntegerRecharge_icon",
                          @"myIntegerGame_icon",
                          @"myIntegerMall_icon",
                          @"myIntegerManager_icon",
                          ];
        NSMutableArray *section2Arr = [NSMutableArray new];
        for (int i = 0; i < subTitle2.count; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"subTitle"] = subTitle2[i];
            dic[@"icon"] = icon2[i];
            [section2Arr addObject:dic];
        }
        section2[@"dataArr"] = section2Arr;
        
        //分区3
        NSArray *title = @[
                           @"分享",
                           @"设置",
                           ];
        
        NSArray *img = @[
                         @"mine_share",
                         @"mine_setting",
                         ];
        NSArray *rightTitle = @[
                                @"分享的积分",
                                @"",
                                ];
        for (int i = 0 ; i < title.count; i ++) {
            NSDictionary *dic = @{
                                  @"title"      :   title[i],
                                  @"img"        :   img[i],
                                  @"rightTitle" :   rightTitle[i],
                                  };
            [section3 addObject:dic];
        }
        
    }
    return _mainDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestToGetUserInfo];
    
    [self requestUser_tips];
    
    if (self.user.hasSignIn){
        [shakeImg.layer removeAllAnimations];
    }else{
        shakerAnimation2(shakeImg, 2, -15);
    }
    
}

-(void)setUI
{
    [self addTableView];
    
    [self addHeadView];
}

//添加头部视图
-(void)addHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 217)];
    [headView addBakcgroundColorTheme];
    UIImageView *headBackImg = [UIImageView new];
    headBackImg.userInteractionEnabled = YES;
    
    UIImageView *bottomView = [UIImageView new];
    bottomView.contentMode = 2;
    bottomView.userInteractionEnabled = YES;
    
    _signIn = [UIButton new];
    shakeImg = [UIImageView new];
    shakeImg.hidden = YES;
    
    [headView sd_addSubviews:@[
                               headBackImg,
                               bottomView,
                               _signIn,
                               shakeImg,
                               
                               ]];
    headBackImg.sd_layout
    .topEqualToView(headView)
    .leftEqualToView(headView)
    .rightEqualToView(headView)
    .heightIs(184)
    ;
    headBackImg.lee_theme.LeeConfigImage(@"mineBackImg");
    
    bottomView.sd_layout
    .leftSpaceToView(headView, 10)
    .rightSpaceToView(headView, 10)
    .heightIs(46)
    .bottomSpaceToView(headView, 10)
    ;
    bottomView.lee_theme.LeeConfigImage(@"mine_Shadow_small");
    
    [self setAttentionAbout:bottomView];
    
    _signIn.sd_layout
    .rightEqualToView(headBackImg)
    .bottomSpaceToView(bottomView, 27)
    .heightIs(30)
    .widthIs(110 * ScaleW)
    ;
    
//    _signIn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
//        if (UserGetBool(@"NightMode")) {
//            [(UIButton *)item setBackgroundColor:HexColor(#0E2643)];
//        }else{
//            [(UIButton *)item setBackgroundColor:RGBA(178, 217, 249, 1)];
//        }
//    });
    [_signIn setNormalTitle:@"签到领积分"];
    _signIn.titleLabel.font = FontScale(13);
    
    _signIn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25 * ScaleW);
    [self cutCornerradiusWithView:_signIn];
    _signIn.hidden = YES;
    @weakify(self)
    [[_signIn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        //是否登录
        if (![YXHeader checkNormalBackLogin]) {
            return;
        }
        SignInViewController *siVC = [SignInViewController new];
        [self.navigationController pushViewController:siVC animated:YES];
    }];
    
    shakeImg.sd_layout
    .centerYEqualToView(_signIn)
    .rightSpaceToView(_signIn, -30)
    .heightIs(24)
    .widthEqualToHeight()
    ;
    shakeImg.image = UIImageNamed(@"mine_gold");
    
    self.tableView.tableHeaderView = headView;
    
    _userImg = [UIImageView new];
    
    UIView *backView = [UIView new];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = ClearColor;
    
    
    _userName = [UILabel new];
    _userName.font = PFFontL(18);
//    [_userName addTitleColorTheme];
    _userName.textColor = HexColor(#FFFFFF);
    
    _idView = [UIView new];
    _idView.backgroundColor = ClearColor;
    
    _integral = [UILabel new];
    _integral.font = PFFontL(14);
    _integral.textAlignment = NSTextAlignmentCenter;
//    [_integral addTitleColorTheme];
    _integral.textColor = WhiteColor;
    _integral.backgroundColor = HexColor(#087ADB);
    _integral.hidden = YES;
    
    _level = [UILabel new];
    _level.font = PFFontL(12);
    _level.textAlignment = NSTextAlignmentCenter;
    _level.textColor = WhiteColor;
    _level.backgroundColor = HexColor(#087ADB);
    _level.hidden = YES;
    
    _messageBtn = [UIButton new];
    _messageBtn.hidden = YES;
    
    [headBackImg sd_addSubviews:@[
                               _userImg,
                               _messageBtn,
                               backView,
                               
                               ]];
    
    _userImg.sd_layout
    .topSpaceToView(headBackImg, 54)
    .leftSpaceToView(headBackImg, 20)
    .widthIs(63)
    .heightEqualToWidth()
    ;
    [_userImg setSd_cornerRadius:@32];
    _userImg.image = UIImageNamed(@"userDefault_icon");
    
    [_userImg whenTap:^{
        @strongify(self)
        [self userTouch];
    }];
    
    _messageBtn.sd_layout
    .rightSpaceToView(headBackImg, 20)
    .topSpaceToView(headBackImg, 26)
    .widthIs(24)
    .heightEqualToWidth()
    ;
    [_messageBtn setNormalImage:UIImageNamed(@"myMessage_icon")];
    [[_messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        MessageViewController *mVC = [MessageViewController new];
        mVC.tipsModel = self.tipsmodel;
        [self.navigationController pushViewController:mVC animated:YES];
    }];
    
    backView.sd_layout
    .leftSpaceToView(_userImg, 15)
    .centerYEqualToView(_userImg)
    .heightIs(40)
    ;
    
    [backView sd_addSubviews:@[
                               _userName,
                               _idView,
                               _integral,
                               _level,
                               ]];
    
    _userName.sd_layout
    .topEqualToView(backView)
    .leftEqualToView(backView)
    .heightIs(20)
    ;
    [_userName setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
    _userName.text = @"谢梦一场";
    
    _idView.sd_layout
    .heightIs(20)
    .centerYEqualToView(_userName)
    .leftSpaceToView(_userName, 10)
    ;
    
    _integral.sd_layout
    .leftEqualToView(backView)
    .bottomEqualToView(backView)
    .widthIs(60)
    .heightIs(20)
    ;
    [_integral setSd_cornerRadius:@10];
//    [_integral setSingleLineAutoResizeWithMaxWidth:100];
    //添加点击弹出积分规则
    [_integral whenTap:^{
        @strongify(self);
        WebViewController *wVC = [WebViewController new];
        wVC.showType = 1;
        [self.navigationController pushViewController:wVC animated:YES];
    }];
    
    _level.sd_layout
    .leftSpaceToView(_integral, 10)
    .centerYEqualToView(_integral)
    .widthIs(40)
    .heightIs(18)
    ;
    [_level setSd_cornerRadius:@9];
    [_level whenTap:^{
        @strongify(self);
        WebViewController *wVC = [WebViewController new];
        wVC.showType = 2;
        [self.navigationController pushViewController:wVC animated:YES];
    }];
    
    if (self.user.identifications.count>0){
        [backView setupAutoWidthWithRightView:_idView rightMargin:10];
    }else{
        [backView setupAutoWidthWithRightView:_level rightMargin:10];
    }
    
}

//重新设置头部内容
-(void)setHeadViewData:(BOOL)login
{
    _userName.text = @"登 录";
    _integral.hidden = YES;
    _integral.text = @"";
    _level.hidden = YES;
    _level.text = @"";
    _signIn.hidden = NO;
    shakeImg.hidden = NO;
    _idView.hidden = YES;
    _messageBtn.hidden = YES;
    if (login) {
        
        [_userImg sd_setImageWithURL:UrlWithStr(self.user.avatar) placeholderImage:UIImageNamed(@"userDefault_icon")];
        _userName.text = GetSaveString(self.user.username);
        _integral.hidden = NO;
        _integral.text = [NSString stringWithFormat:@"%ld积分",self.user.integral];
        [_integral updateLayout];
        _idView.hidden = NO;
        _level.hidden = self.user.level?NO:YES;
        _level.text = [NSString stringWithFormat:@"Lv.%lu",self.user.level];
        _messageBtn.hidden = NO;
    }
    
    if (self.user.hasSignIn) {
        [_signIn setNormalTitle:@"任务领积分"];
        _signIn.backgroundColor = RGBA(178, 217, 249, 1);
        shakeImg.image = UIImageNamed(@"mine_gold_gray");
        [shakeImg.layer removeAllAnimations];
    }else{
        [_signIn setNormalTitle:@"签到领积分"];
        _signIn.backgroundColor = HexColor(#FFB133);
        shakeImg.image = UIImageNamed(@"mine_gold");
        shakerAnimation2(shakeImg, 2, -15);
    }
    
    [self setIdViewWithIDs];
    
}

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    for (UIView *subview in _idView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.user.identifications.count>0) {
        CGFloat wid = 25;
        CGFloat hei = 25;
        CGFloat spaceX = 0;
        
        UIView *lastView = _idView;
        for (int i = 0; i < self.user.identifications.count; i ++) {
            NSDictionary *model = self.user.identifications[i];
            UIImageView *approveView = [UIImageView new];
            [_idView addSubview:approveView];
            
            if (i != 0) {
                spaceX = 10;
            }
            
            approveView.sd_layout
            //            .topEqualToView(lastView)
            .centerYEqualToView(_idView)
            .leftSpaceToView(lastView, spaceX)
            .widthIs(wid)
            .heightIs(hei)
            ;
            //            [approveView setSd_cornerRadius:@(wid/2)];
            approveView.contentMode = 1;
            [approveView sd_setImageWithURL:UrlWithStr(model[@"avatar"])];
            
            //现在要加一个label
            UILabel *label = [UILabel new];
            label.font = PFFontR(12);
            [label addTitleColorTheme];
            [_idView addSubview:label];
            label.sd_layout
            //            .topEqualToView(_idView)
            .centerYEqualToView(_idView)
            .leftSpaceToView(approveView, 6)
            .heightIs(hei)
            ;
            [label setSingleLineAutoResizeWithMaxWidth:50];
            //            label.text = GetSaveString(model[@"text"]);
            
            lastView = label;
            if (i == self.user.identifications.count - 1) {
                [_idView setupAutoWidthWithRightView:label rightMargin:0];
            }
        }
    }
}

//设置关注、获赞、粉丝
-(void)setAttentionAbout:(UIView *)fatherView
{
    _attention = [UIButton new];
    _praise = [UIButton new];
    _fans = [UIButton new];
    _attention.tag = 100 + 0;
    _praise.tag = 100 + 1;
    _fans.tag = 100 + 2;
    [_attention setNormalTitleColor:HexColor(#7A8894)];
    [_praise setNormalTitleColor:HexColor(#7A8894)];
    [_fans setNormalTitleColor:HexColor(#7A8894)];
    [_attention setBtnFont:PFFontL(13)];
    [_praise setBtnFont:PFFontL(13)];
    [_fans setBtnFont:PFFontL(13)];
    _attention.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _praise.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _fans.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [fatherView sd_addSubviews:@[
                                 _attention,
                                 _praise,
                                 _fans,
                                 ]];
    _attention.sd_layout
    .leftEqualToView(fatherView)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthRatioToView(fatherView, 1/3.0)
    ;
    [_attention updateLayout];
    [_attention setNormalTitle:@"关注  1"];
    [_attention setNormalImage:UIImageNamed(@"myAttention_icon")];
//    NSMutableAttributedString *astr1 = [NSString leadString:@"关注" tailString:@"  1" font:PFFontR(16) color:HexColor(#1A1A1A) lineBreak:NO];
//    [_attention setNormalAttributedTitle:astr1];
    
    _praise.sd_layout
    .leftSpaceToView(_attention, 0)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthRatioToView(fatherView, 1/3.0)
    ;
    [_praise updateLayout];
    [_praise addBorderTo:BorderTypeLeft borderSize:CGSizeMake(1, 16) borderColor:HexColor(#D2DAE1)];
    [_praise setNormalTitle:@"获赞  6"];
    [_praise setNormalImage:UIImageNamed(@"myPraise_icon")];
    
    _fans.sd_layout
    .leftSpaceToView(_praise, 0)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthRatioToView(fatherView, 1/3.0)
    ;
    [_fans updateLayout];
    [_fans addBorderTo:BorderTypeLeft borderSize:CGSizeMake(1, 16) borderColor:HexColor(#D2DAE1)];
    [_fans setNormalTitle:@"粉丝  8"];
    [_fans setNormalImage:UIImageNamed(@"myFans_icon")];
    
    //添加点击事件
    [_attention addTarget:self action:@selector(tapViewWithIndex:) forControlEvents:UIControlEventTouchUpInside];
    [_praise addTarget:self action:@selector(tapViewWithIndex:) forControlEvents:UIControlEventTouchUpInside];
    [_fans addTarget:self action:@selector(tapViewWithIndex:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tapViewWithIndex:(UIButton *)sender
{
    if (![YXHeader checkNormalBackLogin]) {
        return;
    }
    NSInteger index = sender.tag - 100;
    switch (index) {
        case 0:
        {
            MyAttentionViewController *maVC = [MyAttentionViewController new];
            [self.navigationController pushViewController:maVC animated:YES];
        }
            break;
        case 1:
        {
            [self requsetgetMyPraises];
        }
            break;
        case 2:
        {
            MyFansViewController *mfvc = [MyFansViewController new];
            [self.navigationController pushViewController:mfvc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)userTouch
{
    if ([YXHeader checkNormalBackLogin]) {
        PersonalDataViewController *pdVC = [PersonalDataViewController new];
        [self.navigationController pushViewController:pdVC animated:YES];
    }
    
}

//添加tableview
-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    self.tableView.sd_layout
    .topSpaceToView(self.view, StatusBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    ;
    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(BaseTableView *)item setBackgroundColor:HexColor(#292d30)];
            [(BaseTableView *)item setSeparatorColor:CutLineColorNight];
        }else{
            [(BaseTableView *)item setBackgroundColor:HexColor(#F2F6F7)];
            [(BaseTableView *)item setSeparatorColor:CutLineColor];
        }
    });
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册
    [self.tableView registerClass:[Mine2FirstTableViewCell class] forCellReuseIdentifier:Mine2FirstTableViewCellID];
    [self.tableView registerClass:[Mine2SecondTableViewCell class] forCellReuseIdentifier:Mine2SecondTableViewCellID];
    
}

//给view添加指定圆角
-(void)cutCornerradiusWithView:(UIView *)view
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(view.bounds.size.height/2, view.bounds.size.height/2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section!=3) {
        return 1;
    }
    NSMutableArray *section3 = self.mainDatasource[section];
    return section3.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        Mine2FirstTableViewCell *cell0 = (Mine2FirstTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Mine2FirstTableViewCellID];
        [cell0 setData:@{}];
        cell = cell0;
    }else if (indexPath.section == 1){
        Mine2SecondTableViewCell *cell1 = (Mine2SecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Mine2SecondTableViewCellID];
        [cell1 setData:self.mainDatasource[1]];
        cell1.clickBlock = ^(NSInteger index) {
            GGLog(@"点击了下标:%ld",index);
        };
        cell = cell1;
    }else if (indexPath.section == 2){
        Mine2SecondTableViewCell *cell2 = (Mine2SecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Mine2SecondTableViewCellID];
        [cell2 setData:self.mainDatasource[2]];
        cell2.clickBlock = ^(NSInteger index) {
            GGLog(@"点击了下标:%ld",index);
        };
        cell = cell2;
    }else if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MianCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"MineCell"];
            cell.textLabel.font = PFFontL(14);
            cell.detailTextLabel.font = PFFontL(14);
            cell.detailTextLabel.textColor = RGBA(188, 188, 188, 1);
            cell.accessoryType = 1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSMutableArray *section3 = self.mainDatasource[indexPath.section];
        NSDictionary *model = section3[indexPath.row];
        cell.textLabel.text = GetSaveString(model[@"title"]);
        [cell addTitleColorTheme];
        cell.imageView.lee_theme.LeeCustomConfig(@"mineBackImg", ^(id item, id value) {
            NSString *imgStr = GetSaveString(model[@"img"]);
            if (UserGetBool(@"NightMode")) {
                imgStr = [GetSaveString(model[@"img"]) stringByAppendingString:@"_night"];
            }
            
            [(UIImageView *)item setImage:UIImageNamed(imgStr)];
        });
    }
    
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=3) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
            {
                [self getShareData];
            }
                break;
            case 1:
            {
                if ([UserGet(@"isLogin") isEqualToString:@"YES"]) {
                    NewSettingViewController *stVC = [NewSettingViewController new];
                    [self.navigationController pushViewController:stVC animated:YES];
                }else{
                    SettingViewController *sVC = [SettingViewController new];
                    [self.navigationController pushViewController:sVC animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark --- 请求
//获取用户信息
-(void)requestToGetUserInfo
{
    [HttpRequest getWithURLString:GetCurrentUserInformation parameters:@{} success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        //后台目前的逻辑是，如果没有登录，只给默认头像这一个字段,只能靠这个来判断
        if ([data allKeys].count>1) {
            UserModel *model = [UserModel mj_objectWithKeyValues:data];
            //覆盖之前保存的信息
            [UserModel coverUserData:model];
            self.user = model;
            [self setHeadViewData:YES];
        }else{
            if (self.user) {
                [UserModel clearLocalData];
            }
            [self.userImg sd_setImageWithURL:UrlWithStr(GetSaveString(data[@"avatar"]))];
            self.user = [UserModel getLocalUserModel];
            [self setHeadViewData:NO];
        }
    } failure:nil];
}

//获取用户提示信息
-(void)requestUser_tips
{
    [HttpRequest getWithURLString:User_tips parameters:nil success:^(id responseObject) {
        self.tipsmodel = [MineTipsModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.tableView reloadData];
        
        MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        NSInteger count = [responseObject[@"data"][@"hasMessageTip"] integerValue];
        if (count) {
            UserSetBool(YES, @"MessageNotice");
            [keyVC.tabBar showBadgeOnItemIndex:4];
        }else{
            UserSetBool(NO, @"MessageNotice");
            [keyVC.tabBar hideBadgeOnItemIndex:4];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//获取分享链接
-(void)getShareData
{
    ShowHudOnly;
    [HttpRequest getWithURLString:GetShareText parameters:nil success:^(id responseObject) {
        
        HiddenHudOnly;
        
        [SharePopCopyView showWithData:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
    }];
    
}

//获取我的被点赞数
-(void)requsetgetMyPraises
{
    [HttpRequest postWithURLString:MyPraiseNum parameters:nil isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        UserModel *user = [UserModel getLocalUserModel];
        user.praisedCount = [response[@"data"] integerValue];
        //覆盖之前保存的信息
        [UserModel coverUserData:user];
        self.user = user;
        [self setHeadViewData:YES];
        [PraisePopView showWithData:nil];
    } failure:nil RefreshAction:^{
        [self requestToGetUserInfo];
    }];
}

@end
