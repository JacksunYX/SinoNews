//
//  MyAttentionViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "AttentionRecommendVC.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的关注";
    self.view.backgroundColor = WhiteColor;
    [self addViews];
    [self requestAttentionList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BaseNavigationVC *navi = (BaseNavigationVC *)self.navigationController;
    [navi showNavigationDownLine];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BaseNavigationVC *navi = (BaseNavigationVC *)self.navigationController;
    [navi hideNavigationDownLine];
}

-(void)addViews
{

    UIView *topView = [UIView new];
    topView.backgroundColor = WhiteColor;
    [self.view addSubview:topView];
    
    topView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(35)
    ;
    
    UILabel *addAttention = [UILabel new];
    addAttention.font = PFFontL(16);
    [topView addSubview:addAttention];
    addAttention.sd_layout
    .leftSpaceToView(topView, 10)
    .centerYEqualToView(topView)
    .heightIs(35)
    ;
    [addAttention setSingleLineAutoResizeWithMaxWidth:200];
    addAttention.text = @"+ 添加关注";
    [addAttention creatTapWithSelector:@selector(pushToAttentionRecommend)];
    
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = topView.bottom_attr;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorColor = RGBA(237, 237, 237, 1);
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
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        MyAttentionFirstCell *cell0 = (MyAttentionFirstCell *)[tableView dequeueReusableCellWithIdentifier:MyAttentionFirstCellID];
        MyFansModel *model = self.attentionArr[indexPath.row];
        cell0.model = model;
        @weakify(self)
        cell0.attentionIndex = ^(NSInteger row) {
            @strongify(self)
            [self requestIsAttentionWithFansModel:model];
        };
        
        cell = (UITableViewCell *)cell0;
    }else if (indexPath.section == 1) {
        MyAttentionSecondCell *cell1 = (MyAttentionSecondCell *)[tableView dequeueReusableCellWithIdentifier:MyAttentionSecondCellID];
        cell = (UITableViewCell *)cell1;
    }else if (indexPath.section == 2) {
        MyAttentionThirdCell *cell2 = (MyAttentionThirdCell *)[tableView dequeueReusableCellWithIdentifier:MyAttentionThirdCellID];
        cell = (UITableViewCell *)cell2;
    }

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

    return 39;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = WhiteColor;
    
    UIView *line = [UIView new];
    line.backgroundColor = RGBA(237, 237, 237, 1);
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
    
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserInfoViewController *uiVC = [UserInfoViewController new];
        [self.navigationController pushViewController:uiVC animated:YES];
    }
}

-(void)pushToAttentionRecommend
{
    AttentionRecommendVC *arVC = [AttentionRecommendVC new];
    [self.navigationController pushViewController:arVC animated:YES];
}

#pragma mark ---- 请求发送
//我的关注列表
-(void)requestAttentionList
{
    [HttpRequest postWithURLString:Attention_myUser parameters:@{} isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        self.attentionArr = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        
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
        if (model.isFollow) {
            LRToast(@"关注成功～");
        }else{
            LRToast(@"已取消关注");
        }
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self requestAttentionList];
    }];
}





@end
