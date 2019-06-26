//
//  HotContentViewController.m
//  SinoNews
//
//  Created by 玉潇  孙 on 2019/6/26.
//  Copyright © 2019 Sino. All rights reserved.
//

#import "HotContentViewController.h"
#import "HotContentTableViewCell.h"

@interface HotContentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) LXSegmentBtnView *segmentView;

@property (nonatomic, strong) BaseTableView *tableLeft;
@property (nonatomic, strong) BaseTableView *tableCenter;
@property (nonatomic, strong) BaseTableView *tableRight;

@property (nonatomic, strong) NSMutableArray *centerDataSource;
@property (nonatomic, strong) NSMutableArray *leftDataSource;
@property (nonatomic, strong) NSMutableArray *rightDataSource;

@end

@implementation HotContentViewController

-(LXSegmentBtnView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [LXSegmentBtnView new];
        [self.view addSubview:_segmentView];
        
        _segmentView.btnTitleNormalColor = HexColor(#1282EE);
        _segmentView.btnTitleSelectColor = WhiteColor;
        _segmentView.btnBackgroundNormalColor = WhiteColor;
        _segmentView.btnBackgroundSelectColor = HexColor(#1282EE);
        _segmentView.bordColor = HexColor(#1282EE);
        
        _segmentView.sd_layout
        .topSpaceToView(self.view, 10)
        .centerXEqualToView(self.view)
        .widthIs(330)
        .heightIs(30)
        ;
        [_segmentView updateLayout];
        _segmentView.btnTitleArray = [NSArray arrayWithObjects:@"热门帖子",@"热门新闻",@"热门点赞",nil];
        @weakify(self);
        _segmentView.lxSegmentBtnSelectIndexBlock = ^(NSInteger index, UIButton *btn) {
            @strongify(self);
            [self reloadTableWithIndex:index];
        };
    }
    return _segmentView;
}

-(NSMutableArray *)centerDataSource
{
    if (!_centerDataSource) {
        _centerDataSource = [NSMutableArray new];
    }
    return _centerDataSource;
}

-(NSMutableArray *)leftDataSource
{
    if (!_leftDataSource) {
        _leftDataSource = [NSMutableArray new];
    }
    return _leftDataSource;
}

-(NSMutableArray *)rightDataSource
{
    if (!_rightDataSource) {
        _rightDataSource = [NSMutableArray new];
    }
    return _rightDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.leftDataSource.count<=0&&_segmentView.selectedIndex==0) {
        [self.tableLeft.mj_header beginRefreshing];
    }
    
    if (self.centerDataSource.count<=0&&_segmentView.selectedIndex==1) {
        
    }
    
    if (self.rightDataSource.count<=0&&_segmentView.selectedIndex==2) {
        [self.tableRight.mj_header beginRefreshing];
    }
}

//添加视图
-(void)addViews
{
    self.segmentView.titleFont = PFFontM(14);
    
    [self createTableLeft];

    [self createCenterTable];

    [self createTableRight];
}

-(void)createTableLeft
{
    self.tableLeft = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableLeft addBakcgroundColorTheme];
    self.tableLeft.delegate = self;
    self.tableLeft.dataSource = self;
    self.tableLeft.showsVerticalScrollIndicator = NO;
    //取消cell边框
    self.tableLeft.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableLeft.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:self.tableLeft];
    self.tableLeft.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    
    [self.tableLeft registerClass:[HotContentTableViewCell class] forCellReuseIdentifier:HotContentTableViewCellID];
    
    @weakify(self);
    self.tableLeft.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestHotNews];
    }];
}

-(void)createCenterTable
{
    self.tableCenter = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableCenter addBakcgroundColorTheme];
    self.tableCenter.delegate = self;
    self.tableCenter.dataSource = self;
    self.tableCenter.showsVerticalScrollIndicator = NO;
    //取消cell边框
    self.tableCenter.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableCenter.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:self.tableCenter];
    self.tableCenter.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    
    [self.tableCenter registerClass:[HotContentTableViewCell class] forCellReuseIdentifier:HotContentTableViewCellID];
    
    @weakify(self);
    self.tableCenter.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestHotPost];
    }];
}

-(void)createTableRight
{
    self.tableRight = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableRight addBakcgroundColorTheme];
    self.tableRight.delegate = self;
    self.tableRight.dataSource = self;
    self.tableRight.showsVerticalScrollIndicator = NO;
    //取消cell边框
    self.tableRight.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableRight.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:self.tableRight];
    self.tableRight.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    //注册
    [self.tableRight registerClass:[HotContentTableViewCell class] forCellReuseIdentifier:HotContentTableViewCellID];
    
    @weakify(self);
    self.tableRight.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestHotPraise];
    }];
}

//根据不同情况显隐试图
-(void)reloadTableWithIndex:(NSInteger)index
{
    if (index==1) {
        [self.tableLeft setHidden:YES];
        [self.tableCenter setHidden:NO];
        [self.tableRight setHidden:YES];
        [self.tableCenter reloadData];
        if (self.centerDataSource.count<=0) {
            
        }
    }else if (index==2) {
        [self.tableLeft setHidden:YES];
        [self.tableCenter setHidden:YES];
        [self.tableRight setHidden:NO];
        [self.tableRight reloadData];
        if (self.rightDataSource.count<=0) {
            [self.tableRight.mj_header beginRefreshing];
        }
    }else{
        [self.tableLeft setHidden:NO];
        [self.tableCenter setHidden:YES];
        [self.tableRight setHidden:YES];
        [self.tableLeft reloadData];
    }
}

#pragma mark ---- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.tableLeft) {
//        return self.leftDataSource.count;
//    }
//    if (tableView == self.tableCenter) {
//        return self.centerDataSource.count;
//    }
//    return self.rightDataSource.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotContentTableViewCell *cell = (HotContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HotContentTableViewCellID];
    
    [cell addBakcgroundColorTheme];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark ----- 请求发送
//请求热门新闻
-(void)requestHotNews
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [HttpRequest getWithURLString:HotContent_hotNews parameters:parameters success:^(id responseObject) {
        NSArray *data = [HotContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableLeft.mj_header endRefreshing];
        self.leftDataSource = [data mutableCopy];
        
        [self.tableLeft reloadData];
    } failure:^(NSError *error) {
        [self.tableLeft.mj_header endRefreshing];
    }];
}

//请求热门帖子
-(void)requestHotPost
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [HttpRequest getWithURLString:HotContent_hotPost parameters:parameters success:^(id responseObject) {
        NSArray *data = [HotContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableCenter.mj_header endRefreshing];
        self.centerDataSource = [data mutableCopy];
        
        [self.tableCenter reloadData];
    } failure:^(NSError *error) {
        [self.tableCenter.mj_header endRefreshing];
    }];
}

//请求热门点赞
-(void)requestHotPraise
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [HttpRequest getWithURLString:HotContent_hotPraise parameters:parameters success:^(id responseObject) {
        NSArray *data = [HotContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableRight.mj_header endRefreshing];
        self.rightDataSource = [data mutableCopy];
        
        [self.tableRight reloadData];
    } failure:^(NSError *error) {
        [self.tableRight.mj_header endRefreshing];
    }];
}

@end
