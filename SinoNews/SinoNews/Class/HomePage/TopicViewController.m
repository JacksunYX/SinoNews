//
//  TopicViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicModel.h"

#import "HomePageFirstKindCell.h"

@interface TopicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIView *headView;
@end

@implementation TopicViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    
    [self addTableView];
    
    [self addHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    
    @weakify(self)
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
//        if (self.tableView.mj_footer.isRefreshing) {
//            [self.tableView.mj_header endRefreshing];
//        }
        [self requestShowTopicDetail];
    }];
    
//    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
//        @strongify(self)
//        if (self.tableView.mj_header.isRefreshing) {
//            [self.tableView.mj_footer endRefreshing];
//        }
//
//    }];
    
    [_tableView.mj_header beginRefreshing];
}

-(void)addHeadView
{
    if (!self.headView) {
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 270)];
        self.headView.backgroundColor = WhiteColor;
        
        UIImageView *titltImg = [UIImageView new];
        titltImg.backgroundColor = Arc4randomColor;
        
        UILabel *title = [UILabel new];
        title.font = PFFontL(18);
        title.numberOfLines = 1;
        
        UILabel *subTitle = [UILabel new];
        subTitle.font = PFFontL(15);
        subTitle.textColor = RGBA(136, 136, 136, 1);
        
        [self.headView sd_addSubviews:@[
                                        titltImg,
                                        title,
                                        subTitle,
                                        
                                        ]];
        
        titltImg.sd_layout
        .topEqualToView(self.headView)
        .leftEqualToView(self.headView)
        .rightEqualToView(self.headView)
        .heightIs(125)
        ;
        
        title.sd_layout
        .topSpaceToView(titltImg, 25)
        .leftSpaceToView(self.headView, 10)
        .rightSpaceToView(self.headView, 10)
        .heightIs(18)
        ;
        title.text = @"朝美领导人历史性会晤";
        
        subTitle.sd_layout
        .topSpaceToView(title, 10)
        .leftSpaceToView(self.headView, 10)
        .rightSpaceToView(self.headView, 10)
        .autoHeightRatio(0)
        ;
        [subTitle setMaxNumberOfLinesToShow:3];
        subTitle.text = @"美国总统特朗普将于6月12日在新加坡会见朝鲜最高领 导人金正恩。这是朝美在任领导人历史上首次举行会 晤。";
    }
    
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataSource.count;
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageFirstKindCell *cell = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
    
//    HomePageModel *model = self.dataSource[indexPath.row];
//    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
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
    
}


#pragma mark ----- 请求发送
//展示专题详情
-(void)requestShowTopicDetail
{
    [HttpRequest getWithURLString:ShowTopicDetails parameters:@{@"topicId":@(self.topicId)} success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}






@end
