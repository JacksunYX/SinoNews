//
//  MyAttentionViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "AttentionRecommendVC.h"
#import "SearchViewController.h"

#import "MyAttentionFirstCell.h"
#import "MyAttentionSecondCell.h"
#import "MyAttentionThirdCell.h"

@interface MyAttentionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *attentionArr;
@property (nonatomic,strong) NSMutableArray *topicArr;
@property (nonatomic,strong) NSMutableArray *channelArr;

@end

@implementation MyAttentionViewController
-(NSMutableArray *)attentionArr
{
    if (!_attentionArr) {
        _attentionArr = [NSMutableArray new];
    }
    return _attentionArr;
}

-(NSMutableArray *)topicArr
{
    if (!_topicArr) {
        _topicArr = [NSMutableArray new];
    }
    return _topicArr;
}

-(NSMutableArray *)channelArr
{
    if (!_channelArr) {
        _channelArr = [NSMutableArray new];
    }
    return _channelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isSearch) {
        self.navigationItem.title = @"搜索到的作者";
    }else{
        self.navigationItem.title = @"我的关注";
    }
    
    [self showTopLine];
    
    [self addViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isSearch) {
        [self requestWithKeyword];
    }else{
        [self requestAttentionList];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)addViews
{

    UIView *topView = [UIView new];
    [topView addBakcgroundColorTheme];
    [self.view addSubview:topView];
    
    CGFloat topViewHeight = 35;
    if (self.isSearch) {
        topViewHeight = 0;
    }
    
    topView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(topViewHeight)
    ;
    
    UILabel *addAttention = [UILabel new];
    addAttention.font = PFFontL(16);
    [addAttention addTitleColorTheme];
    [topView addSubview:addAttention];
    addAttention.sd_layout
    .leftSpaceToView(topView, 10)
    .centerYEqualToView(topView)
    .heightIs(35)
    ;
    [addAttention setSingleLineAutoResizeWithMaxWidth:200];
    addAttention.text = @"+ 添加关注";
    
    @weakify(self)
    [addAttention whenTap:^{
        @strongify(self)
        [self pushToAttentionRecommend];
    }];
    
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(topView, 0)
    .bottomSpaceToView(self.view, 0)
    ;
    
//    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    self.tableView.separatorColor = RGBA(237, 237, 237, 1);
    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        BaseTableView *tableView = item;
        tableView.backgroundColor = value;
        if (UserGetBool(@"NightMode")) {
            tableView.separatorColor = CutLineColorNight;
        }else{
            tableView.separatorColor = CutLineColor;
        }
    });
    //注册
    [self.tableView registerClass:[MyAttentionFirstCell class] forCellReuseIdentifier:MyAttentionFirstCellID];
    [self.tableView registerClass:[MyAttentionSecondCell class] forCellReuseIdentifier:MyAttentionSecondCellID];
    [self.tableView registerClass:[MyAttentionThirdCell class] forCellReuseIdentifier:MyAttentionThirdCellID];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.attentionArr.count;
    }
    if (section == 0) {
        return self.topicArr.count;
    }
    if (section == 0) {
        return self.channelArr.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        MyAttentionFirstCell *cell0 = (MyAttentionFirstCell *)[tableView dequeueReusableCellWithIdentifier:MyAttentionFirstCellID];
        MyFansModel *model = self.attentionArr[indexPath.row];
        cell0.model = model;
        //不允许操作
//        @weakify(self)
//        cell0.attentionIndex = ^(NSInteger row) {
//            @strongify(self)
//            [self requestIsAttentionWithFansModel:model];
//        };
        
        cell = (UITableViewCell *)cell0;
    }else if (indexPath.section == 1) {
        MyAttentionSecondCell *cell1 = (MyAttentionSecondCell *)[tableView dequeueReusableCellWithIdentifier:MyAttentionSecondCellID];
        cell = (UITableViewCell *)cell1;
    }else if (indexPath.section == 2) {
        MyAttentionThirdCell *cell2 = (MyAttentionThirdCell *)[tableView dequeueReusableCellWithIdentifier:MyAttentionThirdCellID];
        cell = (UITableViewCell *)cell2;
    }
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 83;
    }else if (indexPath.section == 1){
        return 132;
    }else if (indexPath.section == 2){
        return 61;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0&&self.attentionArr.count) {
        if (self.isSearch) {
            return 0.01;
        }
        return 39;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    [headView addBakcgroundColorTheme];
    if (self.isSearch) {
        return headView;
    }
    if ((section == 0&&self.attentionArr.count>0)||(section == 1&&self.topicArr.count>0)||(section == 2&&self.channelArr.count>0)) {
        UIView *line = [UIView new];
//        line.backgroundColor = RGBA(237, 237, 237, 1);
        [line addCutLineColor];
        [headView addSubview:line];
        
        CGFloat leftX = 0;
        if (section != 0) {
            leftX = 0;
        }
        line.sd_layout
        .topEqualToView(headView)
        .leftSpaceToView(headView, leftX)
        .rightEqualToView(headView)
        .heightIs(3)
        ;
        
        UILabel *title = [UILabel new];
        title.font = PFFontL(16);
        [title addTitleColorTheme];
        
        [headView addSubview:title];
        title.sd_layout
        .topSpaceToView(line, 0)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .bottomEqualToView(headView)
        ;
        
        if (section == 0) {
            title.text = [NSString stringWithFormat:@"关注的人(%ld)",self.attentionArr.count];
        }else if (section == 1){
            title.text = @"关注的话题(0)";
        }else if (section == 2){
            title.text = @"关注的频道(0)";
        }
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    if (indexPath.section == 0) {
        UserInfoViewController *uiVC = [UserInfoViewController new];
        MyFansModel *model = self.attentionArr[indexPath.row];
        uiVC.userId = model.userId;
        
        uiVC.refreshBlock = ^{
            //刷新界面
            @strongify(self);
            [self requestAttentionList];
        };
        [self.navigationController pushViewController:uiVC animated:YES];
    }
}

-(void)pushToAttentionRecommend
{
//    AttentionRecommendVC *arVC = [AttentionRecommendVC new];
//    [self.navigationController pushViewController:arVC animated:YES];
    SearchViewController *sVC = [SearchViewController new];
    sVC.selectIndex = 2;
    [self.navigationController pushViewController:sVC animated:NO];
}

#pragma mark ---- 请求发送
//我的关注列表
-(void)requestAttentionList
{
    [HttpRequest postWithURLString:Attention_myUser parameters:@{} isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        self.attentionArr = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        UserModel *user = [UserModel getLocalUserModel];
        user.followCount = self.attentionArr.count;
        [UserModel coverUserData:user];
        [self.tableView reloadData];
    } failure:nil RefreshAction:nil];
}

//关注/取消关注
-(void)requestIsAttentionWithFansModel:(MyFansModel *)model
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(model.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        model.isFollow = !model.isFollow;
//        UserModel *user = [UserModel getLocalUserModel];
        
        if (model.isFollow) {
            LRToast(@"关注成功");
//            user.followCount ++;
        }else{
            LRToast(@"取消关注");
//            user.followCount --;
        }
//        [UserModel coverUserData:user];
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
//        [self requestAttentionList];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//搜索作者
-(void)requestWithKeyword
{
    [HttpRequest postWithURLString:ListUserForSearch parameters:@{@"keyword":GetSaveString(self.keyword)} isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id response) {
        self.attentionArr = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.tableView reloadData];
    } failure:nil RefreshAction:nil];
    
}


@end
