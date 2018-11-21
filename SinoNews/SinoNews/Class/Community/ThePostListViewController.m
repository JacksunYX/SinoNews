//
//  ThePostListViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/30.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostListViewController.h"

#import "ThePostListTableViewCell.h"

#import "PostListSearchModel.h"

@interface ThePostListViewController ()<UITableViewDelegate,UITableViewDataSource,TFDropDownMenuViewDelegate>
@property (nonatomic,strong) TFDropDownMenuView *menu;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
//相关版块数组
@property (nonatomic,strong) NSArray *sectionsArr;

@property (nonatomic,assign) NSInteger page;//当前页码
@property (nonatomic,assign) NSInteger sortOrder;//排序方式
//@property (nonatomic,assign) NSInteger sectionId;//所选版块
@end

@implementation ThePostListViewController
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
    if (self.sectionId) {
        SearchSectionsModel *sectionModel = [SearchSectionsModel new];
        sectionModel.sectionId = self.sectionId;
        sectionModel.sectionName = @"当前版块";
        self.sectionsArr = @[sectionModel];
        [self setUpMenu];
        [self setUI];
        return;
    }
    [self requestListBySectionForSearch];
}

-(void)setUI
{
    [self setUpMenu];
    [self setUpTableView];
}

-(void)setUpTableView
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.menu, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    ;
    [_tableView updateLayout];
    [_tableView registerClass:[ThePostListTableViewCell class] forCellReuseIdentifier:ThePostListTableViewCellID];
    self.page = 1;
    @weakify(self);
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestListPostForSearch];
    }];
    [self requestListPostForSearch];
}

//设置下拉菜单
-(void)setUpMenu
{
    NSMutableArray *array1 = [NSMutableArray new];
    NSMutableArray *detail1 = [NSMutableArray new];
    for (int i = 0; i < self.sectionsArr.count; i ++) {
        SearchSectionsModel *sectionModel = self.sectionsArr[i];
        [array1 addObject:sectionModel.sectionName];
        [detail1 addObject:@(sectionModel.count)];
    }
    NSMutableArray *array2 = @[
                               @"最新发帖",
                               @"回帖最多",
                               @"收藏最多",
                               ].mutableCopy;
    NSMutableArray *data1 = @[array1, array2].mutableCopy;
    //哪怕没有二级菜单也要这么写，不然就没有默认选项
    NSMutableArray *data2 = @[@[], @[]].mutableCopy;
    self.menu = [[TFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 34) firstArray:data1 secondArray:data2];
    self.menu.delegate = self;
    self.menu.cellSelectBackgroundColor = WhiteColor;
    self.menu.separatorColor = WhiteColor;
    self.menu.itemTextSelectColor = HexColor(#1282ee);
    self.menu.cellTextSelectColor = HexColor(#1282ee);
    self.menu.tableViewHeight = 150;
    self.menu.cellHeight = 40;
    self.menu.itemFontSize = 15;
    self.menu.cellTitleFontSize = 15;
    [self.view addSubview:self.menu];
    //副标题
    NSMutableArray *detail2 = @[].mutableCopy;
    self.menu.firstRightArray = @[detail1, detail2].mutableCopy;
    self.menu.menuStyleArray = @[
                                 [NSNumber numberWithInteger:TFDropDownMenuStyleCollectionView],
                                 [NSNumber numberWithInteger:TFDropDownMenuStyleTableView]
                                 ].mutableCopy;
}

-(void)hiddenMenu
{
    [self.menu hiddenMenu];
}

#pragma mark --- TFDropDownMenuViewDelegate ---
//点击了第几个item
- (void)menuView:(TFDropDownMenuView *)menu tfColumn:(NSInteger)column {
    GGLog(@"column: %ld", column);
}
//点击了第几行cell
- (void)menuView:(TFDropDownMenuView *)menu selectIndex:(TFIndexPatch *)index {
    GGLog(@"点击了第%ld个的第%ld个cell",index.column,index.section);
    //记得重置页数
    self.page = 1;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    if (index.column==0) {
        SearchSectionsModel *searchModel = self.sectionsArr[index.section];
        self.sectionId = searchModel.sectionId;
    }else{
        self.sortOrder = index.section;
    }
    [self requestListPostForSearch];
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThePostListTableViewCell *cell = (ThePostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostListTableViewCellID];
    SeniorPostDataModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark --- 请求
//关键字搜索版块帖子数量(版块名 ，数量)
-(void)requestListBySectionForSearch
{
    [HttpRequest getWithURLString:ListBySectionForSearch parameters:@{@"keyword":GetSaveString(_keyword)} success:^(id responseObject) {
        GGLog(@"版块及相关帖子数量请求完毕");
        self.sectionsArr = [SearchSectionsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self setUpMenu];
        [self setUI];
    } failure:nil];
}

//搜索帖子列表(版块id、排序方式)
-(void)requestListPostForSearch
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"page"] = @(_page);
    if (_sectionId!=0) {
        parameters[@"sectionId"] = @(_sectionId);
    }
    parameters[@"sortOrder"] = @(_sortOrder);
    parameters[@"keyword"] = GetSaveString(_keyword);
    if (_page==1) {
        ShowHudOnly;
    }
    
    [HttpRequest getWithURLString:ListPostForSearch parameters:parameters success:^(id responseObject) {
        HiddenHudOnly;
        NSArray *data = [SeniorPostDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (data.count>0) {
            self.page ++;
            [self.dataSource addObjectsFromArray:data];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.tableView.mj_footer endRefreshing];
    }];
}



@end
