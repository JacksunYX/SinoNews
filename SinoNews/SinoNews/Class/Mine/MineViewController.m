//
//  MineViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "BrowsingHistoryVC.h"
#import "MessageViewController.h"
#import "MyCollectViewController.h"
#import "PublishPageViewController.h"
#import "MyAttentionViewController.h"
#import "MyFansViewController.h"
#import "PersonalDataViewController.h"
#import "SignInViewController.h"
#import "IntegralViewController.h"

#import "PraisePopView.h"


@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *shakeImg;
}
//下方广告视图
@property (nonatomic ,strong) UICollectionView *adCollectionView;
@property (nonatomic ,strong) NSMutableArray *adDatasource;
//上方
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *mainDatasource;
//用户信息
@property (nonatomic ,strong) UIImageView *userImg;
@property (nonatomic ,strong) UILabel *userName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic ,strong) UILabel *integral;
@property (nonatomic ,strong) UIButton *signIn;
@property (nonatomic ,strong) UILabel *publish;     //文章
@property (nonatomic ,strong) UILabel *attention;   //关注
@property (nonatomic ,strong) UILabel *fans;        //粉丝
@property (nonatomic ,strong) UILabel *praise;      //获赞

@property (nonatomic ,strong) UserModel *user;
@property (nonatomic ,strong) MineTipsModel *tipsmodel;    //保存提示信息

@end

@implementation MineViewController
// 重力弹跳动画效果
void shakerAnimation (UIView *view ,NSTimeInterval duration,float height){
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTx = view.transform.ty;
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    animation.values = @[@(currentTx), @(currentTx + height), @(currentTx + height/3*2), @(currentTx), @(currentTx + height/3), @(currentTx)];
    animation.keyTimes = @[ @(0), @(0.3), @(0.5), @(0.7), @(0.9), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

-(NSMutableArray *)adDatasource
{
    if (!_adDatasource) {
        _adDatasource  = [NSMutableArray new];
//        for (int i = 0; i < 4; i ++) {
//            NSString *imgStr = [NSString stringWithFormat:@"ad_banner%d",i];
//            [_adDatasource addObject:imgStr];
//        }
    }
    return _adDatasource;
}

-(NSMutableArray *)mainDatasource
{
    if (!_mainDatasource) {
        NSArray *title = @[
                              @"消息",
                              @"收藏",
                              @"历史",
                              @"分享",
                              @"设置",
                              @"积分充值",
                              @"积分游戏",
                              @"积分商城",
                              @"积分管理",
                              ];
        NSArray *img = @[
                         @"mine_message",
                         @"mine_collect",
                         @"mine_history",
                         @"mine_share",
                         @"mine_setting",
                         @"mine_integralRecharge",
                         @"mine_integralGame",
                         @"mine_integralShop",
                         @"mine_integralManager",
                         ];
        
        NSArray *rightTitle = @[
                                @"最新消息标题",
                                @"收藏娱乐城快速进入",
                                @"",
                                @"分享的积分",
                                @"",
                                @"1元=100积分",
                                @"玩游戏赢积分",
                                @"",
                                @"",
                                ];
        NSMutableArray *section0 = [NSMutableArray new];
        NSMutableArray *section1 = [NSMutableArray new];
        for (int i = 0 ; i < title.count; i ++) {
            NSDictionary *dic = @{
                                  @"title"      :   title[i],
                                  @"img"        :   img[i],
                                  @"rightTitle" :   rightTitle[i],
                                  };
            if (i < 5) {
                [section0 addObject:dic];
            }else{
                [section1 addObject:dic];
            }
        }
        _mainDatasource = [NSMutableArray new];
        [_mainDatasource addObjectsFromArray:@[section0,section1]];
        
    }
    return _mainDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self addViews];
    
    if (!UserGetBool(MineNotice)) {
        [PopNoticeView showWithData:@[
                                      @"mineNotice_0",
                                      @"mineNotice_1",
                                      @"mineNotice_2",
                                      @"mineNotice_3",
                                      @"mineNotice_4",
                                      @"mineNotice_5",
                                      ]];
        UserSetBool(YES, MineNotice);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (CompareString(UserGet(@"isLogin"), @"YES")) {
//        self.user = [UserModel getLocalUserModel];
//        if (self.user) {
//            [self setHeadViewData:YES];
//        }else{
//            [self requestToGetUserInfo];
//        }
//    }else{
        [self requestToGetUserInfo];
//    }
    
    [self requestUser_tips];
    [self requestGetCountOfUnreadMessage];
    if (self.adDatasource.count<=0) {
        [self requestBottomBanner];
    }
    
    shakerAnimation(shakeImg, 2, -15);
}

//添加视图
-(void)addViews
{
    [self addBottomADView];
    [self addTopTableView];
    [self addHeadView];
}

//添加下方广告视图
-(void)addBottomADView
{
    //下方的
    UICollectionViewFlowLayout *adLayout = [UICollectionViewFlowLayout new];
    adLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemW = (ScreenW - 35)/4;
    CGFloat itemH = itemW * 60 / 85;
    adLayout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
    adLayout.itemSize = CGSizeMake(itemW, itemH);
    adLayout.minimumLineSpacing = 5;
    self.adCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:adLayout];
    self.adCollectionView.showsHorizontalScrollIndicator = NO;
    [self.adCollectionView addBakcgroundColorTheme];
    [self.view addSubview:self.adCollectionView];

    [self setBottomView];
    
    self.adCollectionView.dataSource = self;
    self.adCollectionView.delegate = self;
    [self.adCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ADCellID"];
    
}

-(void)setBottomView
{
    CGFloat itemW = (ScreenW - 35)/4;
    CGFloat itemH = itemW * 60 / 85;
    CGFloat collectionViewH = 0;
    [self.view addSubview:self.adCollectionView];
    if (self.adDatasource.count>0) {
        collectionViewH = 30 + itemH;
    }
    
    self.adCollectionView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(collectionViewH)
    ;
    [self.adCollectionView reloadData];
}

//添加上方的tableview
-(void)addTopTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    self.tableView.sd_layout
//    .topEqualToView(self.view)
    .topSpaceToView(self.view, StatusBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.adCollectionView, 0)
    ;
    
    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(BaseTableView *)item setBackgroundColor:value];
            [(BaseTableView *)item setSeparatorColor:CutLineColorNight];
        }else{
            [(BaseTableView *)item setBackgroundColor:HexColor(F2F6F7)];
            [(BaseTableView *)item setSeparatorColor:CutLineColor];
        }
    });
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
}

-(void)addHeadView
{
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 210)];
    headView.userInteractionEnabled = YES;
//    headView.backgroundColor = RGBA(196, 222, 247, 1);
//    headView.image = UIImageNamed(@"mine_topBackImg");
    headView.lee_theme.LeeConfigImage(@"mineBackImg");
    self.tableView.tableHeaderView = headView;
    
    _userImg = [UIImageView new];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = ClearColor;
    
    _userName = [UILabel new];
    _userName.font = PFFontL(18);
//    _userName.textColor = RGBA(72, 72, 72, 1);
    [_userName addTitleColorTheme];
    
    _idView = [UIView new];
    _idView.backgroundColor = ClearColor;
//    [_idView addBakcgroundColorTheme];
    
    
    _integral = [UILabel new];
    _integral.font = PFFontL(14);
//    _integral.textColor = RGBA(50, 50, 50, 1);
    [_integral addTitleColorTheme];
    
    _signIn = [UIButton new];
    shakeImg = [UIImageView new];
    
    _publish = [self getLabel];
    _attention = [self getLabel];
    _fans = [self getLabel];
    _praise = [self getLabel];
    _publish.tag = 0;
    _attention.tag = 1;
    _fans.tag = 2;
    _praise.tag = 3;
    
    [headView sd_addSubviews:@[
                               _userImg,
                               
                               backView,
                               
                               _signIn,
                               shakeImg,
                               
                               _publish,
                               _attention,
                               _fans,
                               _praise
                               ]];
    
    _userImg.sd_layout
    .topSpaceToView(headView, 54)
    .leftSpaceToView(headView, 10)
    .widthIs(63)
    .heightEqualToWidth()
    ;
    [_userImg setSd_cornerRadius:@32];
    @weakify(self)
    [_userImg whenTap:^{
        @strongify(self)
        [self userTouch];
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
                               ]];
    
    _userName.sd_layout
//    .bottomSpaceToView(_userImg, -27)
//    .centerYEqualToView(self.userImg)
//    .leftSpaceToView(_userImg, 18 * ScaleW)
    .topEqualToView(backView)
    .leftEqualToView(backView)
    .heightIs(20)
    ;
    [_userName setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
    
    _idView.sd_layout
    .heightIs(20)
    .centerYEqualToView(_userName)
    .leftSpaceToView(_userName, 10)
    ;
    
    _integral.sd_layout
//    .topSpaceToView(_userName, 10)
//    .leftEqualToView(_userName)
    .leftEqualToView(backView)
    .bottomEqualToView(backView)
    .heightIs(14)
    ;
    [_integral setSingleLineAutoResizeWithMaxWidth:100];
    
    [backView setupAutoWidthWithRightView:_userName rightMargin:10];
    
    _signIn.sd_layout
    .rightEqualToView(headView)
    .centerYEqualToView(_userImg)
    .heightIs(26)
    .widthIs(113 * ScaleW)
    ;
//    _signIn.backgroundColor = RGBA(178, 217, 249, 1);
    _signIn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIButton *)item setBackgroundColor:HexColor(#0E2643)];
        }else{
            [(UIButton *)item setBackgroundColor:RGBA(178, 217, 249, 1)];
        }
    });
    [_signIn setTitle:@"签到领金币" forState:UIControlStateNormal];
    _signIn.titleLabel.font = FontScale(13);
//    [_signIn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    [_signIn addButtonTextColorTheme];
//    [_signIn setImage:UIImageNamed(@"mine_gold") forState:UIControlStateNormal];
//    _signIn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5 * ScaleW);
    _signIn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25 * ScaleW);
    [self cutCornerradiusWithView:_signIn];
    _signIn.hidden = YES;
    
    [[_signIn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
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
    
    _publish.sd_layout
    .topSpaceToView(_userImg, 40)
    .leftEqualToView(headView)
    .bottomSpaceToView(headView, 10)
    .widthIs(ScreenW/4)
    ;
    [_publish updateLayout];
    
    _publish.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            [self.publish addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:HexColor(#C1D6E9)];
        }else{
            [self.publish addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
        }
    });
    
    
    [_publish whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:0];
    }];
    
    _attention.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_publish, 0)
//    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_attention updateLayout];
    _attention.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            [self.attention addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:HexColor(#C1D6E9)];
        }else{
            [self.attention addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
        }
    });
    
    [_attention whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:1];
    }];
    
    _fans.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_attention, 0)
//    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_fans updateLayout];
    _fans.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            [self.fans addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:HexColor(#C1D6E9)];
        }else{
            [self.fans addBorderTo:BorderTypeRight borderSize:CGSizeMake(1, 16) borderColor:RGBA(193, 214, 233, 1)];
        }
    });
    
    [_fans whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:2];
    }];
    
    _praise.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_fans, 0)
//    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_praise whenTap:^{
        @strongify(self)
        [self tapViewWithIndex:3];
    }];
    
}

//重新设置头部内容
-(void)setHeadViewData:(BOOL)login
{
    NSString *pub = @"0";
    NSString *att = @"0";
    NSString *fan = @"0";
    NSString *pra = @"0";
    _userName.text = @"登 陆";
    _integral.text = @"";
    _signIn.hidden = YES;
    shakeImg.hidden = YES;
    _idView.hidden = YES;
    if (login) {
        
        [_userImg sd_setImageWithURL:UrlWithStr(self.user.avatar)];
        _userName.text = GetSaveString(self.user.username);
        _integral.text = [NSString stringWithFormat:@"%ld 积分",self.user.integral];
        pub = [NSString stringWithFormat:@"%lu",(unsigned long)self.user.postCount];
        att = [NSString stringWithFormat:@"%lu",(unsigned long)self.user.followCount];
        fan = [NSString stringWithFormat:@"%lu",(unsigned long)self.user.fansCount];
        pra = [NSString stringWithFormat:@"%lu",(unsigned long)self.user.praisedCount];
        _signIn.hidden = NO;
        shakeImg.hidden = NO;
        _idView.hidden = NO;
    }
    
    [self setIdViewWithIDs];
    
    _publish.attributedText = [NSString leadString:pub tailString:@"发表" font:Font(12) color:RGBA(134, 144, 153, 1) lineBreak:YES];
    _attention.attributedText = [NSString leadString:att tailString:@"关注" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    _fans.attributedText = [NSString leadString:fan tailString:@"粉丝" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    _praise.attributedText = [NSString leadString:pra tailString:@"获赞" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    
}

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    for (UIView *subview in _idView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.user.identifications.count>0) {
        CGFloat wid = 20;
        CGFloat hei = 20;
        CGFloat spaceX = 5;
        
        for (int i = 0; i < self.user.identifications.count; i ++) {
            NSDictionary *model = self.user.identifications[i];
            UIImageView *approveView = [UIImageView new];
            [_idView addSubview:approveView];
            approveView.sd_layout
            .topEqualToView(_idView)
            .leftSpaceToView(_idView, (spaceX + wid)*i)
            .widthIs(wid)
            .heightIs(hei)
            ;
            [approveView setSd_cornerRadius:@(wid/2)];
//            if (CompareString(model[@"text"], @"官方账号")) {
//                approveView.image = UIImageNamed(@"id_official");
//            }else if (CompareString(model[@"text"], @"认证用户")) {
//                approveView.image = UIImageNamed(@"id_company");
//            }
//            approveView.backgroundColor = Arc4randomColor;
            [approveView sd_setImageWithURL:UrlWithStr(model[@"avatar"])];
            if (i == self.user.identifications.count - 1) {
                [_idView setupAutoWidthWithRightView:approveView rightMargin:0];
            }
        }
    }
}

-(void)tapViewWithIndex:(NSInteger)index
{
    if (![YXHeader checkNormalBackLogin]) {
        return;
    }
    switch (index) {
        case 0:
        {
            PublishPageViewController *ppVC = [PublishPageViewController new];
            [self.navigationController pushViewController:ppVC animated:YES];
        }
            break;
        case 1:
        {
            MyAttentionViewController *maVC = [MyAttentionViewController new];
            [self.navigationController pushViewController:maVC animated:YES];
        }
            break;
        case 2:
        {
            MyFansViewController *mfvc = [MyFansViewController new];
            [self.navigationController pushViewController:mfvc animated:YES];
        }
            break;
        case 3:
        {
            [self requsetgetMyPraises];
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

//获取统一label
-(UILabel *)getLabel
{
    UILabel *label = [UILabel new];
//    label.textColor = RGBA(50, 50, 50, 1);
    [label addTitleColorTheme];
    label.font = PFFontL(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.isAttributedContent = YES;
    return label;
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

#pragma mark ----- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.adDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (collectionView == self.adCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADCellID" forIndexPath:indexPath];
        if (cell.contentView.subviews.count) {
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
        }
        UIImageView *adImg = [UIImageView new];
        [cell.contentView addSubview:adImg];
        adImg.sd_layout
        .leftEqualToView(cell.contentView)
        .topEqualToView(cell.contentView)
        .rightEqualToView(cell.contentView)
        .bottomEqualToView(cell.contentView)
        ;
        ADModel *model = self.adDatasource[indexPath.row];
        //        adImg.image = UIImageNamed(self.adDatasource[indexPath.row]);
        [adImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.url))];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.adCollectionView) {
        ADModel *model = self.adDatasource[indexPath.row];
        [UniversalMethod jumpWithADModel:model];
    }
}


#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mainDatasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainDatasource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"MineCell"];
        cell.textLabel.font = PFFontL(14);
//        [cell.textLabel addTitleColorTheme];
        cell.detailTextLabel.font = PFFontL(14);
        cell.detailTextLabel.textColor = RGBA(188, 188, 188, 1);
        cell.accessoryType = 1;
    }
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
            UITableViewCell *cell1 = (UITableViewCell *)item;
            cell1.textLabel.textColor = value;
            if (UserGetBool(@"MessageNotice")) {
                cell1.textLabel.attributedText = [NSString leadString:GetSaveString(model[@"title"]) tailString:@" ·" font:Font(18) color:RGBA(248, 52, 52, 1)  lineBreak:NO];
            }else{
                cell1.textLabel.attributedText = [NSString leadString:GetSaveString(model[@"title"]) tailString:@"" font:Font(18) color:RGBA(248, 52, 52, 1)  lineBreak:NO];
            }
        });
    }else{
        cell.textLabel.text = GetSaveString(model[@"title"]);
        [cell addTitleColorTheme];
    }
    
//    cell.detailTextLabel.text = GetSaveString(model[@"rightTitle"]);
    if (!kStringIsEmpty(self.tipsmodel.messageTip)) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.detailTextLabel.text = GetSaveString(self.tipsmodel.messageTip);
        }
    }
    if (!kStringIsEmpty(self.tipsmodel.shareTip)) {
        if (indexPath.section == 0 && indexPath.row == 3) {
            cell.detailTextLabel.text = GetSaveString(self.tipsmodel.shareTip);
        }
    }
    if (!kStringIsEmpty(self.tipsmodel.pointRechargeTip)) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.detailTextLabel.text = GetSaveString(self.tipsmodel.pointRechargeTip);
        }
    }
    if (!kStringIsEmpty(self.tipsmodel.pointGameTip)) {
        if (indexPath.section == 1 && indexPath.row == 1) {
            cell.detailTextLabel.text = GetSaveString(self.tipsmodel.pointGameTip);
        }
    }
    
//    cell.imageView.image = UIImageNamed(GetSaveString(model[@"img"]));
    
    cell.imageView.lee_theme.LeeCustomConfig(@"mineBackImg", ^(id item, id value) {
        NSString *imgStr = GetSaveString(model[@"img"]);
        if (UserGetBool(@"NightMode")) {
            imgStr = [GetSaveString(model[@"img"]) stringByAppendingString:@"_night"];
        }
        
        [(UIImageView *)item setImage:UIImageNamed(imgStr)];
    });
    if (indexPath.section == 0 && indexPath.row == 0){
        
    }
    
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //是否登录
    if (![YXHeader checkNormalBackLogin]) {
        return;
    }
    NSArray *section = self.mainDatasource[indexPath.section];
    NSString *title = GetSaveString(section[indexPath.row][@"title"]);
    MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (indexPath.section == 0) {
        if (CompareString(title, @"设置")) {
            SettingViewController *stVC = [SettingViewController new];
            [self.navigationController pushViewController:stVC animated:YES];
        }else if (CompareString(title, @"历史")){
            BrowsingHistoryVC *bhVC = [BrowsingHistoryVC new];
            [self.navigationController pushViewController:bhVC animated:YES];
        }else if (CompareString(title, @"消息")){
            MessageViewController *mVC = [MessageViewController new];
            mVC.tipsModel = self.tipsmodel;
            [self.navigationController pushViewController:mVC animated:YES];
        }else if (CompareString(title, @"收藏")){
            MyCollectViewController *mVC = [MyCollectViewController new];
            [self.navigationController pushViewController:mVC animated:YES];
        }else if (CompareString(title, @"分享")){
            
        }
        
    }else if(indexPath.section == 1){
        RTRootNavigationController *bvc = keyVC.viewControllers[3];
        IntegralViewController *ivC = (IntegralViewController *)bvc.rt_viewControllers[0];
        
        if (CompareString(title, @"积分充值")){
            [keyVC setSelectedIndex:3];
            [ivC setSelectIndex:2];
        }else if (CompareString(title, @"积分游戏")){
            [keyVC setSelectedIndex:3];
            [ivC setSelectIndex:1];
        }else if (CompareString(title, @"积分商城")){
            [keyVC setSelectedIndex:3];
            [ivC setSelectIndex:0];
        }else if (CompareString(title, @"积分管理")){
            [keyVC setSelectedIndex:3];
            [ivC setSelectIndex:3];
        }
        
    }
    
}

#pragma  mark ----- 网络请求
//获取头像
-(void)requestToGetUserAvatar
{
    [HttpRequest getWithURLString:UserAvatar parameters:@{} success:^(id responseObject) {
//        UserSet(responseObject[@"data"], @"userAvatar")
//        [self.userImg sd_setImageWithURL:UrlWithStr(responseObject[@"data"])];
    } failure:nil];
}

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
            [UserModel clearLocalData];
            [self.userImg sd_setImageWithURL:UrlWithStr(GetSaveString(data[@"avatar"]))];
            [self setHeadViewData:NO];
        }
    } failure:nil];
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

//请求下部广告
-(void)requestBottomBanner
{
    [RequestGather requestBannerWithADId:9 success:^(id response) {
        self.adDatasource = response;
        [self setBottomView];
    } failure:nil];
}

//获取用户提示信息
-(void)requestUser_tips
{
    [HttpRequest getWithURLString:User_tips parameters:nil success:^(id responseObject) {
        self.tipsmodel = [MineTipsModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

//获取用户未读消息数量
-(void)requestGetCountOfUnreadMessage
{
    [HttpRequest getWithURLString:GetCountOfUnreadMessage parameters:nil success:^(id responseObject) {
        if ([responseObject[@"data"][@"count"] integerValue]) {
            UserSetBool(YES, @"MessageNotice");
        }else{
            UserSetBool(NO, @"MessageNotice");
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}




@end
