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
#import "MyAttentionViewController.h"
#import "PersonalDataViewController.h"

@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
//下方广告视图
@property (nonatomic ,strong) UICollectionView *adCollectionView;
@property (nonatomic ,strong) NSMutableArray *adDatasource;
//上方
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *mainDatasource;
//用户信息
@property (nonatomic ,strong) UIImageView *userImg;
@property (nonatomic ,strong) UILabel *userName;
@property (nonatomic ,strong) UILabel *integral;
@property (nonatomic ,strong) UIButton *signIn;
@property (nonatomic ,strong) UILabel *publish;     //文章
@property (nonatomic ,strong) UILabel *attention;   //关注
@property (nonatomic ,strong) UILabel *fans;        //粉丝
@property (nonatomic ,strong) UILabel *praise;      //获赞

@property (nonatomic ,strong) UserModel *user;

@end

@implementation MineViewController

-(NSMutableArray *)adDatasource
{
    if (!_adDatasource) {
        _adDatasource  = [NSMutableArray new];
        for (int i = 0; i < 4; i ++) {
            NSString *imgStr = [NSString stringWithFormat:@"ad_banner%d",i];
            [_adDatasource addObject:imgStr];
        }
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
    self.view.backgroundColor = WhiteColor;
    [self addViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([UserGet(@"isLogin") isEqualToString:@"YES"]) {
        NSArray* findAlls = [UserModel bg_findAll:nil];
        if (kArrayIsEmpty(findAlls)) {
            [self requestToGetUserInfo];
        }else{
            self.user = [findAlls firstObject];
            [self setHeadViewData:YES];
        }
    }else{
        [self requestToGetUserInfo];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    self.adCollectionView.backgroundColor = WhiteColor;
    [self.view addSubview:self.adCollectionView];
    [self.adCollectionView activateConstraints:^{
        self.adCollectionView.bottom_attr = self.view.bottom_attr_safe;
        self.adCollectionView.left_attr = self.view.left_attr_safe;
        self.adCollectionView.right_attr = self.view.right_attr_safe;
        self.adCollectionView.height_attr.constant = 30 + itemH;
    }];
    
    self.adCollectionView.dataSource = self;
    self.adCollectionView.delegate = self;
    [self.adCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ADCellID"];
}

//添加上方的tableview
-(void)addTopTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.adCollectionView.top_attr;
    }];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
}

-(void)addHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 210)];
    headView.backgroundColor = RGBA(196, 222, 247, 1);
    self.tableView.tableHeaderView = headView;
    
    _userImg = [UIImageView new];
    
    _userName = [UILabel new];
    _userName.font = PFFontL(18);
    _userName.textColor = RGBA(72, 72, 72, 1);
    
    _integral = [UILabel new];
    _integral.font = PFFontL(14);
    _integral.textColor = RGBA(50, 50, 50, 1);
    
    _signIn = [UIButton new];
    
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
                               _userName,
                               _integral,
                               _signIn,
                               
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
    [_userImg creatTapWithSelector:@selector(userTouch)];
    
    _userName.sd_layout
//    .bottomSpaceToView(_userImg, -27)
    .centerYEqualToView(self.userImg)
    .leftSpaceToView(_userImg, 18 * ScaleW)
    .heightIs(20)
    ;
    [_userName setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
    
    _integral.sd_layout
    .topSpaceToView(_userName, 10)
    .leftEqualToView(_userName)
    .heightIs(20)
    ;
    [_integral setSingleLineAutoResizeWithMaxWidth:100];
    
    _signIn.sd_layout
    .rightEqualToView(headView)
    .centerYEqualToView(_userImg)
    .heightIs(26)
    .widthIs(113 * ScaleW)
    ;
    _signIn.backgroundColor = RGBA(178, 217, 249, 1);
    [_signIn setTitle:@"签到领金币" forState:UIControlStateNormal];
    _signIn.titleLabel.font = FontScale(13);
    [_signIn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    [_signIn setImage:UIImageNamed(@"mine_gold") forState:UIControlStateNormal];
    _signIn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5 * ScaleW);
    [self cutCornerradiusWithView:_signIn];
    _signIn.hidden = YES;
    
    _publish.sd_layout
    .topSpaceToView(_userImg, 40)
    .leftEqualToView(headView)
    .bottomSpaceToView(headView, 10)
    .widthIs(ScreenW/4)
    ;
    [_publish creatTapWithSelector:@selector(tapView:)];
    
    _attention.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_publish, 0)
//    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_attention creatTapWithSelector:@selector(tapView:)];
    
    _fans.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_attention, 0)
//    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_fans creatTapWithSelector:@selector(tapView:)];
    
    _praise.sd_layout
    .topEqualToView(_publish)
    .leftSpaceToView(_fans, 0)
//    .bottomSpaceToView(headView, 20)
    .bottomEqualToView(_publish)
    .widthIs(ScreenW/4)
    ;
    [_praise creatTapWithSelector:@selector(tapView:)];
    
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
    if (login) {
        [_userImg sd_setImageWithURL:UrlWithStr(self.user.avatar)];
        _userName.text = GetSaveString(self.user.username);
        _integral.text = [NSString stringWithFormat:@"%ld 积分",self.user.integral];
        pub = [NSString stringWithFormat:@"%lu",self.user.postCount];
        att = [NSString stringWithFormat:@"%lu",self.user.followCount];
        fan = [NSString stringWithFormat:@"%lu",self.user.fansCount];
        pra = [NSString stringWithFormat:@"%lu",self.user.postCount];
        _signIn.hidden = NO;
    }
    
    _publish.attributedText = [self leadString:pub tailString:@"文章" font:Font(12) color:RGBA(134, 144, 153, 1) lineBreak:YES];
    _attention.attributedText = [self leadString:att tailString:@"关注" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    _fans.attributedText = [self leadString:fan tailString:@"粉丝" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    _praise.attributedText = [self leadString:pra tailString:@"获赞" font:Font(12) color:RGBA(134, 144, 153, 1)  lineBreak:YES];
    
}

-(void)tapView:(UITapGestureRecognizer *)tap
{
    if (![YXHeader checkNormalBackLogin]) {
        return;
    }
    switch (tap.view.tag) {
        case 0:
        {
            
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
            
        }
            break;
        case 3:
        {
            
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
    label.textColor = RGBA(50, 50, 50, 1);
    label.font = PFFontL(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.isAttributedContent = YES;
    return label;
}

//返回定制文字
-(NSMutableAttributedString *)leadString:(NSString *)str1 tailString:(NSString *)str2 font:(UIFont *)font color:(UIColor *)color lineBreak:(BOOL)tab
{
    NSString *totalStr;
    if (tab) {
        totalStr = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    }else{
        totalStr = [str1 stringByAppendingString:str2];
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSDictionary *attDic = @{
                             NSFontAttributeName:font,
                             NSForegroundColorAttributeName:color,
                             };
    [attStr addAttributes:attDic range:NSMakeRange((totalStr.length - str2.length), str2.length)];
    return attStr;
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
        adImg.image = UIImageNamed(self.adDatasource[indexPath.row]);
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        cell.textLabel.textColor = RGBA(50, 50, 50, 1);
        cell.detailTextLabel.font = PFFontL(14);
        cell.detailTextLabel.textColor = RGBA(188, 188, 188, 1);
        cell.accessoryType = 1;
    }
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.attributedText = [self leadString:GetSaveString(model[@"title"]) tailString:@" ·" font:Font(18) color:RGBA(248, 52, 52, 1)  lineBreak:NO];
    }else{
        cell.textLabel.text = GetSaveString(model[@"title"]);
    }
    
    cell.detailTextLabel.text = GetSaveString(model[@"rightTitle"]);
    
    cell.imageView.image = UIImageNamed(GetSaveString(model[@"img"]));
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
    if (indexPath.section == 0) {
        NSArray *section = self.mainDatasource[indexPath.section];
        NSString *title = GetSaveString(section[indexPath.row][@"title"]);
        if (![YXHeader checkNormalBackLogin]) {
            return;
        }
        if (CompareString(title, @"设置")) {
            SettingViewController *stVC = [SettingViewController new];
            [self.navigationController pushViewController:stVC animated:YES];
        }else if (CompareString(title, @"历史")){
            BrowsingHistoryVC *bhVC = [BrowsingHistoryVC new];
            [self.navigationController pushViewController:bhVC animated:YES];
        }else if (CompareString(title, @"消息")){
            MessageViewController *mVC = [MessageViewController new];
            [self.navigationController pushViewController:mVC animated:YES];
        }else if (CompareString(title, @"收藏")){
            MyCollectViewController *mVC = [MyCollectViewController new];
            [self.navigationController pushViewController:mVC animated:YES];
        }else if (CompareString(title, @"分享")){
            
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
        //后台目前的逻辑是，如果没有登陆，只给默认头像这一个字段,只能靠这个来判断
        if ([data allKeys].count>1) {
            UserModel *model = [UserModel mj_objectWithKeyValues:data];
            //覆盖之前保存的信息
            [UserModel coverUserData:model];
            self.user = model;
            [self setHeadViewData:YES];
        }else{
            [self.userImg sd_setImageWithURL:UrlWithStr(GetSaveString(data[@"avatar"]))];
            [self setHeadViewData:NO];
        }
    } failure:nil];
}

@end
