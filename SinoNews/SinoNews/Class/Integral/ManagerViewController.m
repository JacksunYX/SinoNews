//
//  ManagerViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ManagerViewController.h"
#import "ManagerRecordCell.h"
#import "ExchangeRecordCell.h"

#import "ExchangePopView.h"

@interface ManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *userIcon;  //头像
    UILabel     *userName;  //昵称
    UILabel     *integer;   //积分
}

@property (nonatomic,strong) LXSegmentBtnView *segmentView;
@property (nonatomic,strong) CAGradientLayer *gradient; //渐变色覆盖物

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;    //积分记录数据
@property (nonatomic,strong) NSMutableArray *gameRecordArr; //游戏记录数据
@property (nonatomic,strong) NSMutableArray *exchangeRecordArr; //兑换记录数据

@property (nonatomic,assign) NSInteger pageNo1;
@property (nonatomic,assign) NSInteger pageNo2;

@property (nonatomic,assign) NSInteger selectIndex; //选择的下标
@property (nonatomic ,strong) UserModel *user;
@end

@implementation ManagerViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
//        NSArray *behavior = @[
//                              @"签到",
//                              @"猜大小游戏",
//                              @"回答被采纳",
//                              @"发表评论",
//                              @"发表文章",
//                              @"分享得积分",
//                              @"回答问题",
//                              @"兑换iphone8",
//                              ];
//        NSArray *subBehavior = @[
//                                 @"",
//                                 @"投注小",
//                                 @"",
//                                 @"",
//                                 @"",
//                                 @"",
//                                 @"",
//                                 @"",
//                                 ];
//        NSArray *time = @[
//                          @"2018-12-23",
//                          @"2018-12-23",
//                          @"2018-12-23",
//                          @"2018-12-23",
//                          @"2018-12-23",
//                          @"2018-12-23",
//                          @"2018-12-23",
//                          @"2018-12-23",
//                          ];
//
//        NSArray *integerChange = @[
//                                   @"-35",
//                                   @"+1100",
//                                   @"-100",
//                                   @"+500",
//                                   @"+100",
//                                   @"+5100",
//                                   @"-800",
//                                   @"+100",
//                                   ];
//
//        NSArray *balance = @[
//                             @"5500",
//                             @"6500",
//                             @"12000",
//                             @"3500",
//                             @"500",
//                             @"1500",
//                             @"550",
//                             @"2300",
//                             ];
//        for (int i = 0; i < behavior.count; i ++) {
//            NSDictionary *dic = @{
//                                  @"behavior"       :   behavior[i],
//                                  @"subBehavior"    :   subBehavior[i],
//                                  @"time"           :   time[i],
//                                  @"integerChange"  :   integerChange[i],
//                                  @"balance"        :   balance[i],
//                                  };
//            [_dataSource addObject:dic];
//        }
    }
    return _dataSource;
}

-(NSMutableArray *)gameRecordArr
{
    if (!_gameRecordArr) {
        _gameRecordArr = [NSMutableArray new];
    }
    return _gameRecordArr;
}

-(NSMutableArray *)exchangeRecordArr
{
    if (!_exchangeRecordArr) {
        _exchangeRecordArr = [NSMutableArray new];
    }
    return _exchangeRecordArr;
}

- (CAGradientLayer *)gradient
{
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, (ScreenW - 20)/3, 45);
        _gradient.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            [(CAGradientLayer *)item setColors:[NSArray arrayWithObjects:
                                                (id)RGBA(79, 160, 238, 1).CGColor,
                                                (id)RGBA(173, 208, 241, 1).CGColor, nil]];
            if (UserGetBool(@"NightMode")) {
                [(CAGradientLayer *)item setColors:[NSArray arrayWithObjects:
                                                    (id)RGBA(41, 45, 48, 1).CGColor,
                                                    (id)RGBA(106, 112, 116, 1).CGColor, nil]];
            }
            //分界
            [(CAGradientLayer *)item setStartPoint:CGPointMake(0, 0.5)];
            [(CAGradientLayer *)item setEndPoint:CGPointMake(1, 0.5)];
            [(CAGradientLayer *)item setLocations:@[@0.0, @1]];
            
        });
        
//        _gradient.colors = [NSArray arrayWithObjects:
//                           (id)RGBA(79, 160, 238, 1).CGColor,
//                           (id)RGBA(173, 208, 241, 1).CGColor, nil];
//        _gradient.startPoint = CGPointMake(0, 0.5);
//        _gradient.endPoint = CGPointMake(1, 0.5);
//        _gradient.locations = @[@0.0, @1];
    }
    return _gradient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理";
    
    [self setupTopViews];
    [self addTableView];
    
    //监听登录
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserLoginSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self requestToGetUserInfo];
    }];
    
    [self requestToGetUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//上部分
-(void)setupTopViews
{
    userIcon = [UIImageView new];
    userName = [UILabel new];
    userName.font = FontScale(15);
    [userName addTitleColorTheme];
    integer = [UILabel new];
    integer.font = FontScale(15);
    integer.textAlignment = NSTextAlignmentRight;
//    [integer addContentColorTheme];
    integer.textColor = HexColor(#1282EE);
    UIView *line = [UIView new];
    
    [self.view sd_addSubviews:@[
                                userIcon,
                                userName,
                                integer,
                                line,
                                ]];
    userIcon.sd_layout
    .topSpaceToView(self.view, 10)
    .leftSpaceToView(self.view, 10)
    .widthIs(44)
    .heightEqualToWidth()
    ;
    [userIcon setSd_cornerRadius:@22];
    
    userName.sd_layout
    .leftSpaceToView(userIcon, 7)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(15))
    ;
    [userName setSingleLineAutoResizeWithMaxWidth:150];
    
    integer.sd_layout
    .rightSpaceToView(self.view, 10)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(16))
    ;
    [integer setSingleLineAutoResizeWithMaxWidth:150];
    
    _segmentView = [LXSegmentBtnView new];
    [self.view addSubview:_segmentView];
    
    _segmentView.sd_layout
    .topSpaceToView(userIcon, 17)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(45)
    ;
    
    [_segmentView updateLayout];
    _segmentView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        LXSegmentBtnView *item2 = (LXSegmentBtnView *)item;
        item2.btnTitleSelectColor = HexColor(#FFFFFF);
        item2.btnTitleNormalColor = RGBA(136, 136, 136, 1);
        item2.btnBackgroundNormalColor = value;
        item2.btnBackgroundSelectColor = value;
        if (UserGetBool(@"NightMode")) {
            item2.btnTitleSelectColor = RGBA(207, 211, 214, 1);
            item2.btnTitleNormalColor = RGBA(136, 136, 136, 1);
        }
    });
    
    
    @weakify(self)
    _segmentView.lxSegmentBtnSelectIndexBlock = ^(NSInteger index, UIButton *btn) {
        @strongify(self)
        [self setColorWithBtn:btn];
        if (self.selectIndex == index) {
            return ;
        }
        self.selectIndex = index;
        [self.tableView reloadData];
        
        if (index == 1) {
            return;
        }
        
        [self.tableView.mj_header beginRefreshing];
    };
    
    _segmentView.btnTitleArray = @[
                                   @"积分记录",
                                   @"游戏记录",
                                   @"兑换记录",
                                   ];
    
}

-(void)setColorWithBtn:(UIButton *)btn
{
    self.gradient.frame = CGRectMake(0, 0, (ScreenW - 20)/3, 45);
    [btn.layer insertSublayer:self.gradient below:btn.titleLabel.layer];
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        [self.tableView.top_attr equalTo:self.segmentView.bottom_attr constant:10];
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [_tableView addBakcgroundColorTheme];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [_tableView registerClass:[ManagerRecordCell class] forCellReuseIdentifier:ManagerRecordCellID];
    [_tableView registerClass:[ExchangeRecordCell class] forCellReuseIdentifier:ExchangeRecordCellID];
    
    
    @weakify(self)
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        
        if (self.selectIndex == 0) {    //积分记录
            [self requestPointsListWithLoadType:0];
        }else if (self.selectIndex == 1){
            self.pageNo1 = 1;
            
        }else if (self.selectIndex == 2){   //兑换记录
            self.pageNo2 = 1;
            [self requestMall_exchangeRecord];
        }
        
    }];
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if (self.selectIndex == 0) {    //积分记录
            [self requestPointsListWithLoadType:1];
        }else if (self.selectIndex == 1){
            self.pageNo1 ++;
            
        }else if (self.selectIndex == 2){   //兑换记录
            if (self.exchangeRecordArr.count>0) {
                self.pageNo2 ++;
            }else{
                self.pageNo2 = 1;
            }
            [self requestMall_exchangeRecord];
        }
        
    }];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectIndex == 0) {
        return self.dataSource.count;
    }
    if (self.selectIndex == 2) {
        return self.exchangeRecordArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.selectIndex == 0) {
        ManagerRecordCell *cell1 = (ManagerRecordCell *)[tableView dequeueReusableCellWithIdentifier:ManagerRecordCellID];
        cell1.model = self.dataSource[indexPath.row];
        [cell1 addBakcgroundColorTheme];
        cell = cell1;
    }else if (self.selectIndex == 2){
        ExchangeRecordCell *cell1 = (ExchangeRecordCell *)[tableView dequeueReusableCellWithIdentifier:ExchangeRecordCellID];
        cell1.model = self.exchangeRecordArr[indexPath.row];
        [cell1 addBakcgroundColorTheme];
        cell = cell1;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenH tableView:tableView];
    if (self.selectIndex == 0) {
        return 40;
    }else if (self.selectIndex == 2){
        return 94;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.selectIndex == 0&&!kArrayIsEmpty(self.dataSource)) {
        return 35;
    }else if (self.selectIndex == 2){
        return 35;
    }
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (!kArrayIsEmpty(self.dataSource)&&self.selectIndex == 0) {
        headView = [UIView new];
        [headView addBakcgroundColorTheme];
        UIView *topLine = [UIView new];
        
        UIView *leftLine = [UIView new];
        
        UIView *rightLine = [UIView new];
        
        UIView *bottomLine = [UIView new];
        
        headView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            [(UIView *)item setBackgroundColor:value];
            topLine.backgroundColor = CutLineColor;
            leftLine.backgroundColor = CutLineColor;
            rightLine.backgroundColor = CutLineColor;
            bottomLine.backgroundColor = CutLineColor;
            if (UserGetBool(@"NightMode")) {
                topLine.backgroundColor = CutLineColorNight;
                leftLine.backgroundColor = CutLineColorNight;
                rightLine.backgroundColor = CutLineColorNight;
                bottomLine.backgroundColor = CutLineColorNight;
            }
        });
        
        [headView sd_addSubviews:@[
                                   topLine,
                                   leftLine,
                                   rightLine,
                                   bottomLine,
                                   ]];
        topLine.sd_layout
        .topEqualToView(headView)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .heightIs(1)
        ;
        
        leftLine.sd_layout
        .leftSpaceToView(headView, 10)
        .topEqualToView(headView)
        .bottomEqualToView(headView)
        .widthIs(1)
        ;
        
        rightLine.sd_layout
        .rightSpaceToView(headView, 10)
        .topEqualToView(headView)
        .bottomEqualToView(headView)
        .widthIs(1)
        ;
        
        bottomLine.sd_layout
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .bottomEqualToView(headView)
        .heightIs(1)
        ;
        
        NSArray *headTitle = @[
                               @"行为",
                               @"时间",
                               @"积分变化",
                               @"余额",
                               ];
        CGFloat lrMargin = 10;
        CGFloat xMargin = 0;
        CGFloat labelWid = (ScreenW - 2 * lrMargin)/headTitle.count;
        CGFloat labelHei = 35;
        CGFloat x = lrMargin;
        
        for (int i = 0; i < headTitle.count; i ++) {
            UILabel *label = [UILabel new];
            label.font = Font(15);
            [label addTitleColorTheme];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = GetSaveString(headTitle[i]);
            
            [headView addSubview:label];
            label.sd_layout
            .topEqualToView(headView)
            .leftSpaceToView(headView, x)
            .widthIs(labelWid)
            .heightIs(labelHei)
            ;
            
            x += xMargin + labelWid;
        }
    }else if (self.selectIndex == 2)
    {
        headView = [UIView new];
        [headView addBakcgroundColorTheme];
        UIView *topLine = [UIView new];
        
        UIView *leftLine = [UIView new];
        
        UIView *rightLine = [UIView new];
        
        UIView *bottomLine = [UIView new];
        
        headView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            [(UIView *)item setBackgroundColor:value];
            topLine.backgroundColor = CutLineColor;
            leftLine.backgroundColor = CutLineColor;
            rightLine.backgroundColor = CutLineColor;
            bottomLine.backgroundColor = CutLineColor;
            if (UserGetBool(@"NightMode")) {
                topLine.backgroundColor = CutLineColorNight;
                leftLine.backgroundColor = CutLineColorNight;
                rightLine.backgroundColor = CutLineColorNight;
                bottomLine.backgroundColor = CutLineColorNight;
            }
        });
        
        [headView sd_addSubviews:@[
                                   topLine,
                                   leftLine,
                                   rightLine,
                                   bottomLine,
                                   ]];
        topLine.sd_layout
        .topEqualToView(headView)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .heightIs(1)
        ;
        
        leftLine.sd_layout
        .leftSpaceToView(headView, 10)
        .topEqualToView(headView)
        .bottomEqualToView(headView)
        .widthIs(1)
        ;
        
        rightLine.sd_layout
        .rightSpaceToView(headView, 10)
        .topEqualToView(headView)
        .bottomEqualToView(headView)
        .widthIs(1)
        ;
        
        bottomLine.sd_layout
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .bottomEqualToView(headView)
        .heightIs(1)
        ;
        
        NSArray *headTitle = @[
                               @"商品详情",
                               @"时间",
                               @"积分",
                               ];
        CGFloat lrMargin = 10;
        CGFloat xMargin = 0;
        CGFloat labelWid = (ScreenW - 2 * lrMargin)/4;
        CGFloat labelHei = 35;
        CGFloat x = lrMargin;
        
        for (int i = 0; i < headTitle.count; i ++) {
            UILabel *label = [UILabel new];
            label.font = Font(15);
            [label addTitleColorTheme];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = GetSaveString(headTitle[i]);
            
            [headView addSubview:label];
            CGFloat labW = labelWid;
            if (i == 0) {
                labW = labelWid * 2;
            }
            label.sd_layout
            .topEqualToView(headView)
            .leftSpaceToView(headView, x)
            .widthIs(labW)
            .heightIs(labelHei)
            ;
            
            x += xMargin + labW;
        }
    }

    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == 2) {
        [ExchangePopView showWithData:self.exchangeRecordArr[indexPath.row]];
    }
}

#pragma mark ---- 请求发送
//请求积分列表
-(void)requestPointsListWithLoadType:(NSInteger)loadType
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"loadType"] = @(loadType);
    parameters[@"loadTime"] = [self getLoadTimeWithLoadType:loadType];
    [HttpRequest getWithURLString:PointsBalanceSheet parameters:parameters success:^(id responseObject) {
        NSArray *data = [IntegralModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        if (loadType == 0) {
            self.dataSource = [[data arrayByAddingObjectsFromArray:self.dataSource] mutableCopy];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.dataSource addObjectsFromArray:data];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView endAllRefresh];
    }];
}

//请求兑换列表
-(void)requestMall_exchangeRecord
{
    [HttpRequest getWithURLString:Mall_exchangeRecord parameters:@{@"pageNo":@(self.pageNo2)} success:^(id responseObject) {
        NSArray *data = [ExchangeRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.exchangeRecordArr = [self.tableView pullWithPage:self.pageNo2 data:data dataSource:self.exchangeRecordArr];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView endAllRefresh];
    }];
}

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
            [self->userIcon sd_setImageWithURL:UrlWithStr(model.avatar)];
            self->userName.text = GetSaveString(model.username);
            [self->userName updateLayout];
            self->integer.text = [NSString stringWithFormat:@"%ld积分",model.integral];
            [self->integer updateLayout];
        }else{
            
        }
    } failure:nil];
}

//根据loadType来获取loadTime
-(NSString *)getLoadTimeWithLoadType:(NSInteger)loadType
{
    NSString *loadTime = @"";
    //前提是已经有数据了
    if (self.dataSource.count>0) {
        NSUInteger i = 0;
        if (loadType) {
            //取最后一个
            i = self.dataSource.count - 1;
        }
        IntegralModel *model = self.dataSource[i];
        loadTime = model.time;
    }
    
    return loadTime;
}




@end
