//
//  SelectPublishChannelViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SelectPublishChannelViewController.h"

#import "ForumLeftTableViewCell.h"
#import "SelectPublishChannelCell.h"

@interface SelectPublishChannelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BaseTableView *leftTable;
@property (nonatomic,strong) BaseTableView *centerTable;
@property (nonatomic,strong) BaseTableView *rightTable;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger leftSelectedIndex;
@property (nonatomic,assign) NSInteger centerSelectedIndex;

@property (nonatomic,strong) UIButton *publishBtn;

@end

@implementation SelectPublishChannelViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *leftArr = @[
                             @"我的关注",
                             @"酒店常客",
                             @"航空常客",
                             @"信用卡",
                             @"飞科生活",
                             ];
        NSArray *centerArr = @[
                               @"酒店Report",
                               @"IHG优悦会",
                               @"万豪礼赏",
                               @"spg俱乐部",
                               @"希尔顿荣誉客会",
                               ];
        NSArray *rightArr = @[
                              @"洲际",
                              @"喜达屋",
                              @"雅高",
                              @"万豪",
                              @"凯悦",
                              ];
        
        [_dataSource addObject:leftArr];
        [_dataSource addObject:centerArr];
        [_dataSource addObject:rightArr];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    
    @weakify(self);
    self.view.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noNet" title:@"" refreshBlock:^{
        @strongify(self);
        ShowHudOnly;
        [self requestSectionTree];
    }];
    [self requestSectionTree];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_leftTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [_centerTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [_rightTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"选择发表到的版块";
    [self setTopLineColor:HexColor(#E3E3E3)];
    
    _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_publishBtn setNormalTitle:@"发表"];
    [_publishBtn setNormalTitleColor:HexColor(#161A24)];
    
    [_publishBtn setBtnFont:PFFontR(16)];
    [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_publishBtn];
}

-(void)publishAction:(UIButton *)sender
{
    if (self.postModel.sectionId == 0) {
        LRToast(@"没有选择版块哟");
        return;
    }
    [self requestPublishPost];
}

-(void)setUI
{
    if (_leftTable) {
        return;
    }
    CGFloat avgW = ScreenW *(1.0/3);
    _leftTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _leftTable.backgroundColor = HexColor(#EEEEEE);
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.showsVerticalScrollIndicator = NO;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _leftTable.separatorColor = CutLineColor;
    [self.view addSubview:_leftTable];
    _leftTable.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_leftTable updateLayout];
    [_leftTable registerClass:[ForumLeftTableViewCell class] forCellReuseIdentifier:ForumLeftTableViewCellID];
    
    _centerTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _centerTable.backgroundColor = WhiteColor;
    _centerTable.delegate = self;
    _centerTable.dataSource = self;
    _centerTable.showsVerticalScrollIndicator = NO;
    _centerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_centerTable];
    _centerTable.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(_leftTable, 0)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_centerTable updateLayout];
    [_centerTable registerClass:[SelectPublishChannelCell class] forCellReuseIdentifier:SelectPublishChannelCellID];
    
    _rightTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _rightTable.backgroundColor = WhiteColor;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.showsVerticalScrollIndicator = NO;
    _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightTable];
    _rightTable.sd_layout
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_rightTable updateLayout];
    [_rightTable registerClass:[SelectPublishChannelCell class] forCellReuseIdentifier:SelectPublishChannelCellID];
    
    [self selectFirstView:0];
}

#pragma mark --- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTable) {
        return self.dataSource.count;
    }
    if (tableView == _centerTable) {
        if (self.dataSource.count>0) {
            MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
            return model.subSections.count;
        }
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        return model.subSections.count;
    }
    if (tableView == _rightTable) {
        if (self.dataSource.count>0) {
            MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
            if (model.subSections.count>0) {
                MainSectionModel *model2 = model.subSections[self.centerSelectedIndex];
                return model2.subSections.count;
            }
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == _leftTable) {
        ForumLeftTableViewCell *cell0 = (ForumLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumLeftTableViewCellID];
        MainSectionModel *model = self.dataSource[indexPath.row];
        [cell0 setTitle:model.name];
        cell = cell0;
    }else if (tableView == _centerTable) {
        SelectPublishChannelCell *cell1 = (SelectPublishChannelCell *)[tableView dequeueReusableCellWithIdentifier:SelectPublishChannelCellID];
        cell1.type = 1;
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[indexPath.row];
        [cell1 setTitle:model2.name];
        cell = cell1;
    }else if (tableView == _rightTable) {
        SelectPublishChannelCell *cell2 = (SelectPublishChannelCell *)[tableView dequeueReusableCellWithIdentifier:SelectPublishChannelCellID];
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[indexPath.row];
        MainSectionModel *model3 = model2.subSections[indexPath.row];
        [cell2 setTitle:model3.name];
        cell = cell2;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:_leftTable.frame.size.width tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _leftTable) {

        [self selectFirstView:indexPath.row];
        
    }else if (tableView == _centerTable){

        self.centerSelectedIndex = indexPath.row;
        //先判断是否有三级数组
        MainSectionModel *model = self.dataSource[_leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[indexPath.row];
        if (model2.subSections.count>0) {
            [self selectThirdView:0];
        }else{
            [self.rightTable reloadData];
            self.postModel.sectionId = model2.sectionId;
        }
    }else if (tableView == _rightTable){
        MainSectionModel *model = self.dataSource[_leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[_centerSelectedIndex];
        MainSectionModel *model3 = model2.subSections[indexPath.row];
        self.postModel.sectionId = model3.sectionId;
    }
}

//选中一级的某个cell
-(void)selectFirstView:(NSInteger)index
{
    [_leftTable reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_leftTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.leftSelectedIndex = indexPath.row;
    
    [self selectSecondView:0];
}

//选中二级的某个cell
-(void)selectSecondView:(NSInteger)index
{
    MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
    if (model.subSections.count<=0) {
        [self requestListSubSection:model];
    }else{
        [_centerTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_centerTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        self.centerSelectedIndex = indexPath.row;
        MainSectionModel *model2 = model.subSections[index];
        if (model2.subSections.count>0) {
            [self selectThirdView:0];
        }else{
            [self.rightTable reloadData];
            self.postModel.sectionId = model2.sectionId;
        }
    }
}

//选中三级的某个cell
-(void)selectThirdView:(NSInteger)index
{
    [_rightTable reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_rightTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    MainSectionModel *model = self.dataSource[_leftSelectedIndex];
    MainSectionModel *model2 = model.subSections[_centerSelectedIndex];
    MainSectionModel *model3 = model2.subSections[index];
    self.postModel.sectionId = model3.sectionId;
}

#pragma mark --请求
//请求主版块数据
-(void)requestListMainSection
{
    [self.view ly_startLoading];
    [HttpRequest getWithURLString:ListMainSection parameters:nil success:^(id responseObject) {
        HiddenHudOnly;
        [self.view ly_endLoading];
        self.dataSource = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self setUI];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.view ly_endLoading];
    }];
}

//请求二级版块数据
-(void)requestListSubSection:(MainSectionModel *)model
{
    [HttpRequest getWithURLString:ListSubSection parameters:@{@"sectionId":@(model.sectionId)} success:^(id responseObject) {
        NSArray *subListArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        model.subSections = subListArr.mutableCopy;
        
        [self selectSecondView:0];
    } failure:^(NSError *error) {
        [self.centerTable reloadData];
    }];
}

//请求版块树
-(void)requestSectionTree
{
    [self.view ly_startLoading];
    [HttpRequest getWithURLString:SectionTree parameters:nil success:^(id responseObject) {
        HiddenHudOnly;
        [self.view ly_endLoading];
        self.dataSource = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self setUI];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.view ly_endLoading];
    }];
}

//发表帖子
-(void)requestPublishPost
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSMutableDictionary *dic = [self.postModel mj_JSONObject];
    NSMutableArray *dataSource = dic[@"dataSource"];
    for (int i = 0; i < dataSource.count; i ++) {
        NSMutableDictionary *item = dataSource[i];
        if (item[@"imageData"]) {
            [item removeObjectForKey:@"imageData"];
        }
        if (item[@"videoData"]){
            [item removeObjectForKey:@"videoData"];
        }
    }
    parameters[@"postModel"] = [dic mj_JSONString];
    
    [HttpRequest postWithURLString:PublishPost parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"发帖成功");
        //记得要从本地草稿箱移除
        [SeniorPostDataModel remove:self.postModel];
        if (self.refreshCallBack) {
            self.refreshCallBack();
        }
        GCDAfterTime(1, ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
    } failure:nil RefreshAction:nil];
}

@end
