//
//  StoreChildViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "StoreChildViewController.h"
#import "ExchangeProductViewController.h"
#import "StoreChildCell.h"

@interface StoreChildViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;

@end

@implementation StoreChildViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noProduct" title:@"暂无商品"];
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
    [_tableView addBakcgroundColorTheme];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [_tableView registerClass:[StoreChildCell class] forCellReuseIdentifier:StoreChildCellID];
    @weakify(self)
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self.tableView ly_startLoading];
        self.page = 1;
        [self requestProductsList];
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
        [self requestProductsList];
    }];
    [self.tableView.mj_header beginRefreshing];
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
    StoreChildCell *cell = (StoreChildCell *)[tableView dequeueReusableCellWithIdentifier:StoreChildCellID];
    cell.model = self.dataSource[indexPath.row];
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenH tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GGLog(@"点击了第%ld个",indexPath.row);
    ExchangeProductViewController *epVc = [ExchangeProductViewController new];
    ProductModel *model = self.dataSource[indexPath.row];
    epVc.productId = model.product_id;
    [self.navigationController pushViewController:epVc animated:YES];
}

#pragma mark ----- 请求发送
//请求商品列表
-(void)requestProductsList
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"categoryId"] = [NSString stringWithFormat:@"%ld",self.categoryId];
    parameters[@"page"] = @(self.page);
    [HttpRequest getWithURLString:Mall_products parameters:parameters success:^(id responseObject) {
        NSArray *data = [ProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.dataSource = [self.tableView pullWithPage:self.page data:data dataSource:self.dataSource];
        if (self.page>=1&&self.dataSource.count<=0) {
            [self.tableView.mj_footer setHidden:YES];
        }else{
            [self.tableView.mj_footer setHidden:NO];
        }
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    }];
}








@end
