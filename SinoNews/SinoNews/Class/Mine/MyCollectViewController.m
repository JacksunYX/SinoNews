//
//  MyCollectViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectArticleCell.h"
#import "MyCollectCasinoCell.h"
#import "RankDetailViewController.h"
#import "HomePageFirstKindCell.h"
#import "NewsDetailViewController.h"
#import "CatechismViewController.h"


@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate,MLMSegmentHeadDelegate>
{
    NSInteger selectedIndex;    //选择的下标
}
@property (nonatomic, strong) MLMSegmentHead *segHead;

@property (nonatomic,strong) BaseTableView *tableView;

@property (nonatomic,assign) NSInteger currPage;    //页码

//文章数据源数组
@property (nonatomic,strong) NSMutableArray *articleArray;
//娱乐城数据源数组
@property (nonatomic,strong) NSMutableArray *casinoArray;
//存储选择要删除数据数组
@property (nonatomic,strong) NSMutableArray *deleteArray;

//全选按钮
@property (nonatomic,strong) UIButton *selectAllBtn;
//选择按钮
@property (nonatomic,strong) UIButton *selectedBtn;
//删除按钮
@property (nonatomic,strong) UIButton *deleteBtn;
//下方视图
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation MyCollectViewController

- (NSMutableArray *)articleArray
{
    if (!_articleArray) {
        _articleArray = [NSMutableArray array];
        //        for (int i = 0; i< 4; i++) {
        //            NSString *string = [NSString stringWithFormat:@"stringstringstringstringstringstringstring%d",arc4random()%100];
        //            [_articleArray addObject:string];
        //        }
    }
    return _articleArray;
}

- (NSMutableArray *)casinoArray
{
    if (!_casinoArray) {
        _casinoArray = [NSMutableArray array];
        //        for (int i = 0; i< 5; i++) {
        //            NSString *string = [NSString stringWithFormat:@"测试测试测试测试测试测试测试测试%d",arc4random()%100];
        //            [_casinoArray addObject:string];
        //        }
    }
    return _casinoArray;
}

- (NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"内容";
    [self showTopLine];
    [self getButtonAndView];
    selectedIndex = 1;
//    [self setTitleView];
    [self addTableViews];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noCollect" title:@"暂无任何收藏"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitleView
{
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, 200, 44) titles:@[@"娱乐城",@"文章"] headStyle:0 layoutStyle:0];
    //    _segHead.fontScale = .85;
    //    _segHead.lineScale = 0.6;
    _segHead.fontSize = 16;
    //    _segHead.lineHeight = 3;
    //    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = RGBA(50, 50, 50, 1);
    _segHead.deSelectColor = RGBA(152, 152, 152, 1);
    _segHead.maxTitles = 2;
    _segHead.bottomLineHeight = 0;
    _segHead.bottomLineColor = RGBA(227, 227, 227, 1);
    _segHead.delegate = self;
    @weakify(self)
    [MLMSegmentManager associateHead:_segHead withScroll:nil completion:^{
        @strongify(self)
        self.navigationItem.titleView = self.segHead;
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    self.selectedBtn.hidden = !selectedIndex;
    
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setSelectColor:value];
        //来回滑动一次，解决显示问题
        [(MLMSegmentHead *)item changeIndex:1 completion:YES];
        [(MLMSegmentHead *)item changeIndex:0 completion:YES];
    });
    
    [_segHead changeIndex:1 completion:YES];
    _segHead.hidden = YES;
    _segHead.userInteractionEnabled = NO;
    
}

-(void)addTableViews
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.bottomView, 0)
    ;
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    //允许支持同时多选多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    self.tableView.separatorColor = RGBA(227, 227, 227, 1);
    //注册
    [self.tableView registerClass:[MyCollectArticleCell class] forCellReuseIdentifier:MyCollectArticleCellID];
    [self.tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [self.tableView registerClass:[MyCollectCasinoCell class] forCellReuseIdentifier:MyCollectCasinoCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing||self.tableView.editing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        self.currPage = 1;
        if (self->selectedIndex==0) {
            [self requestCompanyList];
        }else{
            [self requestNewsList];
        }
        
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing||self->selectedIndex==0||self.tableView.editing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (!self.articleArray.count) {
            self.currPage = 1;
        }else{
            self.currPage++;
        }
        if (self->selectedIndex==0) {
            [self requestCompanyList];
        }else{
            [self requestNewsList];
        }
    }];
    
    [self.tableView.mj_footer setHidden:YES];
}

//创建选择、删除按钮
- (void)getButtonAndView
{
#pragma mark 选择按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.frame = CGRectMake(0, 0, 40, 30);
    selectedBtn.titleLabel.font = PFFontL(15);
    selectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [selectedBtn addButtonTextColorTheme];
    [selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [selectedBtn setTitle:@"取消" forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBtn = selectedBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:selectedBtn];
    
    //下方视图
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = RGBA(18, 130, 238, 1);
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(0)
    ;
    self.bottomView.hidden = YES;
    
#pragma mark 删除按钮
    self.deleteBtn = [UIButton new];
    self.deleteBtn.backgroundColor = RGBA(18, 130, 238, 1);
    self.deleteBtn.titleLabel.font = PFFontL(14);
    self.deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
//    self.deleteBtn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
//    self.deleteBtn.layer.borderWidth = 1;
    [self.bottomView addSubview:self.deleteBtn];
    self.deleteBtn.sd_layout
//    .leftEqualToView(self.view)
    .topEqualToView(self.bottomView)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.bottomView)
    .widthIs(100)
//    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
//    .heightIs(0)
    ;
    [self.deleteBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [self.deleteBtn setImage:UIImageNamed(@"collect_trash") forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.hidden = YES;
    
    //全选/反选按钮
    self.selectAllBtn = [UIButton new];
    self.selectAllBtn.backgroundColor = RGBA(18, 130, 238, 1);
    self.selectAllBtn.titleLabel.font = PFFontL(14);
//    self.selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [self.bottomView addSubview:self.selectAllBtn];
    self.selectAllBtn.sd_layout
    .topEqualToView(self.bottomView)
    .leftEqualToView(self.bottomView)
    .bottomEqualToView(self.bottomView)
    .widthIs(50)
    ;
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitle:@"反选" forState:UIControlStateSelected];
    [self.selectAllBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [self.selectAllBtn addTarget:self action:@selector(selecteAllAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectAllBtn.hidden = YES;
}

//显示或隐藏下方删除控件
-(void)showOrHiddenTheSelections:(BOOL)show
{
    self.tableView.editing = show;
    self.selectedBtn.selected = show;
    self.selectAllBtn.selected = NO;
    self.bottomView.hidden = !show;
    self.selectAllBtn.hidden = !show;
    self.deleteBtn.hidden = !show;
    [self.tableView reloadData];
    CGFloat hei = 0;
    if (show) {
        hei = 44;
    }else{
        [self.deleteArray removeAllObjects];
//        [self.deleteBtn setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    }
    self.bottomView.sd_resetLayout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(hei)
    ;
}

#pragma mark 按钮方法
//选择按钮方法
- (void)selectedAction:(UIButton *)btn
{
    NSMutableArray *arr;
    if (selectedIndex == 0) {
        arr = self.casinoArray;
    }else if (selectedIndex == 1){
        arr = self.articleArray;
    }
    if (arr.count) {
        btn.selected = !btn.selected;
        [self showOrHiddenTheSelections:btn.selected];
    }else{
        LRToast(@"先去收藏点东西吧");
    }
    
}

//删除按钮方法
- (void)deleteAction:(UIButton *)btn
{
    if (!self.deleteArray.count) {
        LRToast(@"还没有选择要删掉的东西哟～");
        return;
    }
    
    //批量删除
    if (selectedIndex == 0) {
        [self requestCancelCompanysCollects];
    }else if (selectedIndex == 1) {
        [self requestCancelNewsCollects];
    }
    
}

//全选/反选操作
- (void)selecteAllAction:(UIButton *)btn
{
    btn.selected = ! btn.selected;
    //无论全选还是反选都是先清除数组
    if (self.deleteArray.count) {
        [self.deleteArray removeAllObjects];
    }
    //先判断是全选还是反选
    if (btn.selected) { //全选
        //文章
        if (selectedIndex == 1) {
            [self.deleteArray addObjectsFromArray:self.articleArray];
            for (int i = 0; i< self.articleArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
        }
        
    }else{
        [self.tableView reloadData];
    }
    //修改右下角显示状态
    [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.deleteArray.count] forState:UIControlStateNormal];
}

//重置当前显示状态
-(void)resetStatus
{
    NSMutableArray *arr;
    if (self->selectedIndex == 0) {
        arr = self.casinoArray;
    }else if (self->selectedIndex == 1){
        arr = self.articleArray;
    }
    //将数据源数组中包含有删除数组中的数据删除掉
    [arr removeObjectsInArray:self.deleteArray];
    //清空删除数组
    [self.deleteArray removeAllObjects];
    
    //重置按钮状态
    self.selectAllBtn.selected = NO;
    
    [self.tableView reloadData];
    //恢复初始状态
    [self showOrHiddenTheSelections:NO];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedIndex == 1) {
        return self.articleArray.count;
    }else if (selectedIndex == 0){
        return self.casinoArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (selectedIndex == 0){
        MyCollectCasinoCell *cell1 = (MyCollectCasinoCell *)[tableView dequeueReusableCellWithIdentifier:MyCollectCasinoCellID];
        cell1.model = self.casinoArray[indexPath.row];
        cell = (MyCollectCasinoCell *)cell1;
    }else if (selectedIndex == 1) {
        HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
        
        cell1.model = self.articleArray[indexPath.row];
        cell = (UITableViewCell *)cell1;
        
    }
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 1) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }else if (selectedIndex == 0){
//        return 128;
        return 70;
    }
    return 0;
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
    if (self.tableView.editing) {
        NSArray *arr;
        if (selectedIndex == 1) {
            arr = self.articleArray;
        }else if (selectedIndex == 0){
            arr = self.casinoArray;
        }
        [self.deleteArray addObject:[arr objectAtIndex:indexPath.row]];
        if (self.deleteArray.count<arr.count) {
            self.selectAllBtn.selected = NO;
        }else{
            self.selectAllBtn.selected = YES;
        }
    }else{
        if (selectedIndex == 1) {
            HomePageModel *model = self.articleArray[indexPath.row];
            if ([model.newsType intValue]==0) { //新闻
                NewsDetailViewController *ndVC = [NewsDetailViewController new];
                ndVC.newsId = [(HomePageModel *)model itemId];
                [self.navigationController pushViewController:ndVC animated:YES];
            }else if ([model.newsType intValue]==2){    //问答
                CatechismViewController *cVC = [CatechismViewController new];
                cVC.news_id = model.itemId;
                [self.navigationController pushViewController:cVC animated:YES];
            }
        }else if (selectedIndex == 0){
            //跳转到公司详情
            RankDetailViewController *rdVC = [RankDetailViewController new];
            CompanyDetailModel *model = self.casinoArray[indexPath.row];
            rdVC.companyId = model.companyId;
            [self.navigationController pushViewController:rdVC animated:YES];
        }
    }
    [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.deleteArray.count] forState:UIControlStateNormal];
    
//    [self.deleteBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        
        NSArray *arr;
        if (selectedIndex == 1) {
            arr = self.articleArray;
        }else if (selectedIndex == 0){
            arr = self.casinoArray;
        }
        [self.deleteArray removeObject:[arr objectAtIndex:indexPath.row]];
        if (self.deleteArray.count<arr.count) {
            self.selectAllBtn.selected = NO;
        }else{
            self.selectAllBtn.selected = YES;
        }
    }
    if (!self.deleteArray.count) {
//        [self.deleteBtn setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    }
    [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",self.deleteArray.count] forState:UIControlStateNormal];
}

//侧滑删除
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
////    if (selectedIndex == 0) {
////        return YES;
////    }
////    return NO;
//}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;

}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (selectedIndex == 0) {
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        }
//    }
//}

// 修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"取消收藏";
//}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 0) {
        //添加取消收藏按钮
        UITableViewRowAction *cancelCollectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSArray *arr;
            if (self->selectedIndex == 0) {
                arr = self.casinoArray;
            }else if (self->selectedIndex == 1){
                arr = self.articleArray;
            }
            [self.deleteArray addObject:[arr objectAtIndex:indexPath.row]];
            [self requestCancelCompanysCollects];
        }];
        cancelCollectAction.backgroundColor = HexColor(#51AAFF);
        
        return @[cancelCollectAction];
    }
    return nil;
}

#pragma mark ---- MLMSegmentHeadDelegate
- (void)didSelectedIndex:(NSInteger)index
{
    selectedIndex = index;
    self.selectedBtn.hidden = !index;
    [self showOrHiddenTheSelections:NO];
    [self.tableView.mj_footer setHidden:!index];
    
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark ---- 请求发送
//收藏的游戏公司列表
-(void)requestCompanyList
{
    [self.tableView ly_startLoading];
    @weakify(self)
    [HttpRequest getWithURLString:ListConcernedCompanyForUser parameters:nil success:^(id responseObject) {
        @strongify(self)
        self.casinoArray = [CompanyDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:nil];
}

//收藏的文章列表
-(void)requestNewsList
{
    [self.tableView ly_startLoading];
    [HttpRequest postWithURLString:MyFavor parameters:@{@"currPage":@(self.currPage)} isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        NSMutableArray *dataArr = [HomePageModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        
        self.articleArray = [self.tableView pullWithPage:self.currPage data:dataArr dataSource:self.articleArray];
//        if (self.currPage == 1) {
//            self.articleArray = [dataArr mutableCopy];
//            [self.tableView.mj_header endRefreshing];
//        }else{
//            [self.articleArray addObjectsFromArray:dataArr];
//        }
//
//        if (dataArr.count) {
//            [self.tableView.mj_footer endRefreshing];
//        }else{
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    } RefreshAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//批量取消关注游戏公司
-(void)requestCancelCompanysCollects
{
    NSMutableArray *array = [NSMutableArray new];
    for (CompanyDetailModel *model in self.deleteArray) {
        [array addObject:model.companyId];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    @weakify(self)
    [HttpRequest postWithURLString:CancelCompanysCollects parameters:@{@"companyIds":jsonString} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        @strongify(self)
        [self resetStatus];
    } failure:nil RefreshAction:^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

//批量取消关注文章
-(void)requestCancelNewsCollects
{
    NSMutableString *str = [@"" mutableCopy];
    for (HomePageModel *model in self.deleteArray) {
        [str appendString:[NSString stringWithFormat:@"%ld,",model.itemId]];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    @weakify(self)
    [HttpRequest postWithURLString:Unfavors parameters:@{@"newsIds":str} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        @strongify(self)
        [self resetStatus];
    } failure:nil RefreshAction:^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}






@end
