//
//  AttentionRecommendVC.m
//  SinoNews
//
//  Created by Michael on 2018/6/8.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionRecommendVC.h"
#import "SearchViewController.h"    //搜索页面
#import "UserInfoViewController.h"  //用户信息页面

#import "AttentionRecommendFirstCell.h"
#import "AttentionRecommendSecondCell.h"
#import "AttentionRecommendThirdCell.h"

#import "RecommendChannelModel.h"
#import "RecommendUserModel.h"

@interface AttentionRecommendVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *recommendTopicArr;     //推荐话题
@property (nonatomic,strong) NSMutableArray *recommendChannelArr;   //推荐频道
@property (nonatomic,strong) NSMutableArray *recommendUserArr;      //推荐人
@end

@implementation AttentionRecommendVC

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *title = @[
                           @"军事机密",
                           @"军武次位面",
                           @"测试一下",
                           @"随便啦",
                           @"快科技",
                           ];
        NSArray *img = @[
                         @"user_icon",
                         @"user_icon",
                         @"user_icon",
                         @"user_icon",
                         @"user_icon",
                         ];
        NSArray *fansNum = @[
                             @100,
                             @2421,
                             @454,
                             @22,
                             @9,
                             ];
        NSArray *subTitle = @[
                              @"《军武次位面》是知名的网络军事类视频节目，注重调侃娱乐性，但是其在专业深度上也毫不逊色。当有新节目更新时我们提醒你。",
                              @"没错，上知天文，下知地理...",
                              @"你敢动吗？",
                              @"不敢不敢",
                              @"算你识相",
                              ];
        NSArray *isAttention = @[
                                 @(NO),
                                 @(NO),
                                 @(NO),
                                 @(NO),
                                 @(NO),
                                 ];
        for (int i = 0; i < 3; i ++) {
            NSMutableArray *dataArr = [NSMutableArray new];
            for (int j = 0; j < 15; j ++) {
                AttentionRecommendModel *model = [AttentionRecommendModel new];
                model.title = title[arc4random()%title.count];
                model.img = img[arc4random()%img.count];
                model.fansNum = [fansNum[arc4random()%fansNum.count] integerValue];
                model.subTitle = subTitle[arc4random()%subTitle.count];
                
                model.isAttention = [isAttention[arc4random()%isAttention.count]  boolValue];
                [dataArr addObject:model];
            }
//            [_dataSource addObject:dataArr];
        }
        
    }
    return _dataSource;
}

-(NSMutableArray *)recommendTopicArr
{
    if (!_recommendTopicArr) {
        _recommendTopicArr = [NSMutableArray new];
    }
    return _recommendTopicArr;
}

-(NSMutableArray *)recommendChannelArr
{
    if (!_recommendChannelArr) {
        _recommendChannelArr = [NSMutableArray new];
    }
    return _recommendChannelArr;
}

-(NSMutableArray *)recommendUserArr
{
    if (!_recommendUserArr) {
        _recommendUserArr = [NSMutableArray new];
    }
    return _recommendUserArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐";
    [self addNavigationView];
    
    [self addTableview];
    
    [self requestRecommend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    
    
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        NSString *rightImg = @"attention_search";
        if (UserGetBool(@"NightMode")) {
            rightImg = [rightImg stringByAppendingString:@"_night"];
        }
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(searchAction) image:rightImg hightimage:nil andTitle:@""];

    });
    
}

-(void)searchAction
{
    SearchViewController *sVC = [SearchViewController new];
    [self.navigationController pushViewController:sVC animated:NO];
}

-(void)addTableview
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - NAVI_HEIGHT - BOTTOM_MARGIN) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[AttentionRecommendFirstCell class] forCellReuseIdentifier:AttentionRecommendFirstCellID];
    [self.tableView registerClass:[AttentionRecommendSecondCell class] forCellReuseIdentifier:AttentionRecommendSecondCellID];
    [self.tableView registerClass:[AttentionRecommendThirdCell class] forCellReuseIdentifier:AttentionRecommendThirdCellID];
    [self.view addSubview:self.tableView];
    self.tableView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
}

#pragma mark --- UITableViewDataSource ---

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataSource[section];
    return arr.count>0?1:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    @weakify(self)
    if (indexPath.section == 0) {
        AttentionRecommendFirstCell *cell0 = (AttentionRecommendFirstCell *)[tableView dequeueReusableCellWithIdentifier:AttentionRecommendFirstCellID];
        cell0.dataSource = self.dataSource[indexPath.section];
        //点击了
        cell0.selectedIndex = ^(NSInteger index) {
            @strongify(self)
            [self choseSection:0 row:index];
        };
        //关注
        cell0.attentionIndex = ^(NSInteger row) {
            @strongify(self)
            [self choseAttentionStatusWithSection:indexPath.section line:0 row:row];
        };
        
        cell = (UITableViewCell *)cell0;
    }else if(indexPath.section == 1){
        AttentionRecommendSecondCell *cell1 = (AttentionRecommendSecondCell *)[tableView dequeueReusableCellWithIdentifier:AttentionRecommendSecondCellID];
        cell1.dataSource = self.dataSource[indexPath.section];
        
        //点击了
        cell1.selectedIndex = ^(NSInteger line, NSInteger row) {
            @strongify(self)
            [self choseSection:indexPath.section line:line row:row];
        };
        
        //关注
        cell1.attentionBlock = ^(NSInteger line, NSInteger row) {
            @strongify(self)
            [self choseAttentionStatusWithSection:indexPath.section line:line row:row];
        };
        
        cell = (UITableViewCell *)cell1;
    }else if(indexPath.section == 2){
        AttentionRecommendThirdCell *cell2 = (AttentionRecommendThirdCell *)[tableView dequeueReusableCellWithIdentifier:AttentionRecommendThirdCellID];
        cell2.dataSource = self.dataSource[indexPath.section];
        
        //点击了
        cell2.selectedIndex = ^(NSInteger line, NSInteger row) {
            @strongify(self)
            [self choseSection:indexPath.section line:line row:row];
        };
        //关注
        cell2.attentionBlock = ^(NSInteger line, NSInteger row) {
            @strongify(self)
            [self choseAttentionStatusWithSection:indexPath.section line:line row:row];
        };
        
        cell = (UITableViewCell *)cell2;
    }
//    cell.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }else if (indexPath.section == 1){
        return 204;
    }else if (indexPath.section == 2){
        return 204;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        if (self.recommendUserArr.count&&section == 1) {
            return 43;
        }else if (self.recommendChannelArr.count&&section == 2){
            return 43;
        }else{
            return 0;
        }
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    if (section != 0) {
        headView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");;
        UILabel *title = [UILabel new];
        title.font = PFFontL(15);
        title.lee_theme.LeeConfigTextColor(@"titleColor");
        [headView addSubview:title];
        title.sd_layout
        .leftSpaceToView(headView, 10)
        .bottomSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        [title setMaxNumberOfLinesToShow:1];
        if (self.recommendUserArr.count&&section == 1) {
            title.text = @"大咖入驻";
        }else if (self.recommendChannelArr.count&&section == 2){
            title.text = @"热门频道";
        }
    }
    
    return headView;
}

-(void)choseSection:(NSInteger)section row:(NSInteger)index
{
    GGLog(@"点击了第%ld分区的第个%ldcell",section,index);
}

-(void)choseSection:(NSInteger)section line:(NSInteger)line row:(NSInteger)row
{
    GGLog(@"点击了第%ld分区第%ld列的第个%ldcell",section,line,row);
    switch (section) {
        case 0:
            
            break;
        case 1: //人
        {
            NSUInteger index = line * 3 + row;
            RecommendUserModel *userModel = self.recommendUserArr[index];
            UserInfoViewController *uiVC = [UserInfoViewController new];
            uiVC.userId = userModel.userId;
            [self.navigationController pushViewController:uiVC animated:YES];
        }
            break;
        case 2: //频道
        {
            
        }
            break;
            
        default:
            break;
    }
}

//修改对应分区对应cell的关注状态
-(void)choseAttentionStatusWithSection:(NSInteger)section line:(NSInteger)line row:(NSInteger)row
{
//    if (section == 0) {
//        GGLog(@"改变了分区0的%ld的关注状态",row);
//        NSMutableArray *dataSource = [self.dataSource[section] mutableCopy];
//        AttentionRecommendModel *model = dataSource[row];
//        model.isAttention = !model.isAttention;
//        [self.dataSource replaceObjectAtIndex:section withObject:dataSource];
//        [self.tableView reloadData];
//
//    }else{
//        GGLog(@"改变了分区%ld的%ld列%ld行的关注状态",section,line,row);
//        NSMutableArray *dataSource = [self.dataSource[section] mutableCopy];
//        NSInteger index = line*3 + row;
//        AttentionRecommendModel *model = dataSource[index];
//        model.isAttention = !model.isAttention;
//        [self.dataSource replaceObjectAtIndex:section withObject:dataSource];
//        [self.tableView reloadData];
//    }
    switch (section) {
        case 0:
            
            break;
        case 1: //人
        {
            NSUInteger index = line * 3 + row;
            RecommendUserModel *userModel = self.recommendUserArr[index];
            NSUInteger userId = userModel.userId;
            [self requestIsAttentionWithUserId:userId index:index];
        }
            break;
        case 2: //频道
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark ----- 请求发送
//推荐用户列表
-(void)requestRecommend
{
    [HttpRequest getWithURLString:UserRecommend parameters:nil success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        self.recommendChannelArr = [RecommendChannelModel mj_objectArrayWithKeyValuesArray:data[@"recommendChannel"]];
        self.recommendUserArr = [RecommendUserModel mj_objectArrayWithKeyValuesArray:data[@"recommendUser"]];
        [self.dataSource addObject:self.recommendTopicArr];
        [self.dataSource addObject:self.recommendUserArr];
        [self.dataSource addObject:self.recommendChannelArr];
        [self.tableView reloadData];
    } failure:nil];
}

//关注/取关 某个人
-(void)requestIsAttentionWithUserId:(NSUInteger)userId index:(NSUInteger)index
{
    @weakify(self)
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        @strongify(self)
        RecommendUserModel *userModel = self.recommendUserArr[index];
        userModel.isAttention = !userModel.isAttention;
//        UserModel *user = [UserModel getLocalUserModel];
        if (userModel.isAttention) {
//            user.followCount ++;
            LRToast(@"关注成功");
        }else{
//            user.followCount --;
            LRToast(@"已取消关注");
        }
        //覆盖之前保存的信息
//        [UserModel coverUserData:user];
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//关注/取关 某个频道






@end
