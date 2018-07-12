//
//  ManagerViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ManagerViewController.h"
#import "ManagerRecordCell.h"

@interface ManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *userIcon;  //头像
    UILabel     *userName;  //昵称
    UILabel     *integer;   //积分
}

@property (nonatomic,strong) LXSegmentBtnView *segmentView;
@property (nonatomic,strong) CAGradientLayer *gradient; //渐变色覆盖物

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;

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

- (CAGradientLayer *)gradient
{
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, (ScreenW - 20)/3, 45);
        _gradient.colors = [NSArray arrayWithObjects:
                           (id)RGBA(79, 160, 238, 1).CGColor,
                           (id)RGBA(173, 208, 241, 1).CGColor, nil];
        _gradient.startPoint = CGPointMake(0, 0.5);
        _gradient.endPoint = CGPointMake(1, 0.5);
        _gradient.locations = @[@0.0, @1];
    }
    return _gradient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理";
    
    [self setupTopViews];
    [self addTableView];
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
    [integer addContentColorTheme];
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
    _segmentView.btnTitleSelectColor = RGBA(18, 130, 238, 1);
    _segmentView.btnTitleNormalColor = RGBA(136, 136, 136, 1);
    WeakSelf
    _segmentView.lxSegmentBtnSelectIndexBlock = ^(NSInteger index, UIButton *btn) {
        [weakSelf setColorWithBtn:btn];
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
    
    @weakify(self)
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        self.page = 1;
        [self requestPointsList];
        [self requestToGetUserInfo];
    }];
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (!self.dataSource.count) {
            self.page = 1;
        }else{
            self.page++;
        }
        [self requestPointsList];
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
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ManagerRecordCell *cell = (ManagerRecordCell *)[tableView dequeueReusableCellWithIdentifier:ManagerRecordCellID];
    cell.model = self.dataSource[indexPath.row];
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenH tableView:tableView];
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (kArrayIsEmpty(self.dataSource)) {
        return 0.01;
    }
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    if (kArrayIsEmpty(self.dataSource)) {
        return nil;
    }
    [headView addBakcgroundColorTheme];
    UIView *topLine = [UIView new];
    topLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = RGBA(227, 227, 227, 1);
    
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
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGLog(@"点击了第%ld个",indexPath.row);
}

#pragma mark ---- 请求发送
//请求积分列表
-(void)requestPointsList
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"page"] = @(self.page);
    [HttpRequest getWithURLString:PointsBalanceSheet parameters:parameters success:^(id responseObject) {
        NSArray *data = [IntegralModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        if (self.page == 1) {
            self.dataSource = [data mutableCopy];
            if (data.count) {
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }else{
            if (data.count) {
                [self.dataSource addObjectsFromArray:data];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//获取用户信息
-(void)requestToGetUserInfo
{
    @weakify(self)
    [HttpRequest getWithURLString:GetCurrentUserInformation parameters:@{} success:^(id responseObject) {
        @strongify(self)
        NSDictionary *data = responseObject[@"data"];
        //后台目前的逻辑是，如果没有登陆，只给默认头像这一个字段,只能靠这个来判断
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






@end
