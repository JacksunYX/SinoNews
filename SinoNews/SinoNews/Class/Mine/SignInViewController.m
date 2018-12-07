//
//  SignInViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/28.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SignInViewController.h"
#import "IntegralViewController.h"

#import "StoreChildCell.h"
#import "SignInPopView.h"
#import "SignInRuleWebView.h"
#import "DailyTaskModel.h"

@interface SignInViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) DailyTaskModel *taskModel;     //任务模型
@property (nonatomic,strong) NSMutableArray *taskArr;       //任务
@property (nonatomic,strong) NSMutableArray *integralArr;   //积分兑换

@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIView *topModalView;  //夜间模式的遮罩

@end

@implementation SignInViewController
-(UIView *)topModalView
{
    if (!_topModalView) {
        _topModalView = [UIView new];
        [self.view addSubview:_topModalView];
        [self.view bringSubviewToFront:_topModalView];
        _topModalView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
        _topModalView.userInteractionEnabled = NO;
    }
    return _topModalView;
}

-(NSMutableArray *)taskArr
{
    if (!_taskArr) {
        _taskArr = [NSMutableArray new];
        /*
        NSArray *taskIcon = @[
                              @"signIn_browse",
                              @"signIn_share",
                              @"signIn_ask",
                              @"signIn_comment",
                              ];
        NSArray *taskTitle = @[
                               @"浏览新闻超过3篇",
                               @"成功分享3篇新闻",
                               @"完成一次问答",
                               @"发表3次评论",
                               ];
        NSArray *taskDone = @[
                              @(1),
                              @(0),
                              @(0),
                              @(1),
                              ];
        NSArray *taskAward = @[
                               @"+10积分",
                               @"+5积分",
                               @"+15积分",
                               @"+10积分",
                               ];
        for (int i = 0; i < taskIcon.count; i ++) {
            NSDictionary *dic = @{
                                  @"taskIcon"   :   taskIcon[i],
                                  @"taskTitle"  :   taskTitle[i],
                                  @"taskDone"   :   taskDone[i],
                                  @"taskAward"  :   taskAward[i],
                                  
                                  };
            [_taskArr addObject:dic];
         
        }
         */
    }
    return _taskArr;
}

-(NSMutableArray *)integralArr
{
    if (!_integralArr) {
        _integralArr = [NSMutableArray new];
    }
    return _integralArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"天天签到";
    
    self.view.backgroundColor = WhiteColor;
    
    [self requestSignIn];
    
    [self requestUser_getDailyTask];
    
    if (UserGetBool(@"NightMode")) {
        self.topModalView.backgroundColor = HexColorAlpha(#000000, 0.1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//添加上方的tableview
-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
//    self.tableView.sd_layout
//    .topEqualToView(self.view)
//    .leftEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .bottomEqualToView(self.view)
//    ;
//    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[StoreChildCell class] forCellReuseIdentifier:StoreChildCellID];
    
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
}

-(void)setHeadView
{
    if (!self.headView) {
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 433)];
//        [self.headView addBakcgroundColorTheme];
        self.headView.backgroundColor = WhiteColor;
        //最上面的广告
        UIImageView *topADImg = [UIImageView new];
        topADImg.backgroundColor = WhiteColor;
        //中间的用户信息
        UIView *centerView = [UIView new];
//        [centerView addBakcgroundColorTheme];
        //下面的签到视图
        UIView *bottomView = [UIView new];
//        [bottomView addBakcgroundColorTheme];
        [self.headView sd_addSubviews:@[
                                        topADImg,
                                        centerView,
                                        bottomView,
                                        ]];
        topADImg.sd_layout
        .topEqualToView(self.headView)
        .leftEqualToView(self.headView)
        .rightEqualToView(self.headView)
        .heightIs(60)
        ;
        [topADImg updateLayout];
        topADImg.image = UIImageNamed(@"signIn_topBanner");
        
        centerView.sd_layout
        .topSpaceToView(topADImg, 0)
        .leftEqualToView(self.headView)
        .rightEqualToView(self.headView)
        .heightIs(93)
        ;
        [centerView updateLayout];
        [centerView addBorderTo:BorderTypeBottom borderSize:CGSizeMake(ScreenW - 20, 1) borderColor:CutLineColor];
        
        bottomView.sd_layout
        .topSpaceToView(centerView, 0)
        .leftEqualToView(self.headView)
        .rightEqualToView(self.headView)
        .heightIs(280)
        ;
        [bottomView updateLayout];
        [bottomView addBorderTo:BorderTypeBottom borderSize:CGSizeMake(ScreenW - 20, 1) borderColor:CutLineColor];
        
        //中间的用户信息
        UIImageView *userIcon = [UIImageView new];
        
        UILabel *integral = [UILabel new];
        integral.font = PFFontL(13);
//        integral.textColor = RGBA(50, 50, 50, 1);
//        [integral addTitleColorTheme];
        integral.textColor = HexColor(#323232);
        integral.isAttributedContent = YES;
        
        UILabel *signInDay = [UILabel new];
        signInDay.font = PFFontL(14);
        signInDay.textColor = HexColor(#989898);
        
        UIButton *signInRaw = [UIButton new];
        signInRaw.titleLabel.font = PFFontL(14);
//        [signInRaw addButtonTextColorTheme];
        [signInRaw setNormalTitleColor:HexColor(#323232)];
        
        [[signInRaw rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [SignInRuleWebView showWithWebString:News_signRule];
        }];
        
        [centerView sd_addSubviews:@[
                                     userIcon,
                                     integral,
                                     signInDay,
                                     signInRaw,
                                     ]];
        userIcon.sd_layout
        .leftSpaceToView(centerView, 10)
        .centerYEqualToView(centerView)
        .widthIs(63)
        .heightEqualToWidth()
        ;
        [userIcon setSd_cornerRadius:@(63/2)];
        UserModel *user = [UserModel getLocalUserModel];
        [userIcon sd_setImageWithURL:UrlWithStr(GetSaveString(user.avatar))];
        
        integral.sd_layout
        .leftSpaceToView(userIcon, 10)
        .topSpaceToView(centerView, 25)
        .heightIs(19)
        ;
        [integral setSingleLineAutoResizeWithMaxWidth:150];
        NSString *integralStr1 = @"";
        NSString *integralStr2 = [NSString stringWithFormat:@"%ld",[self.data[@"totalPoints"] integerValue]];
        NSMutableAttributedString *integralAtt1 = [NSString leadString:integralStr1 tailString:integralStr2 font:PFFontR(24) color:HexColor(#ff3722) lineBreak:NO];
        NSString *integralStr3 = @" 积分";
        NSMutableAttributedString *integralAtt2 = [[NSMutableAttributedString alloc]initWithString:integralStr3];
        [integralAtt1 appendAttributedString:integralAtt2];
        integral.attributedText = integralAtt1;
        
        signInDay.sd_layout
        .leftSpaceToView(userIcon, 10)
        .topSpaceToView(integral, 10)
        .heightIs(14)
        ;
        [signInDay setSingleLineAutoResizeWithMaxWidth:150];
        signInDay.text = [NSString stringWithFormat:@"连续签到%ld天",[self.data[@"conSignDays"] integerValue]];
        
        signInRaw.sd_layout
        .centerYEqualToView(centerView)
        .rightSpaceToView(centerView, -12)
        .widthIs(90)
        .heightIs(24)
        ;
        [signInRaw setSd_cornerRadius:@12];
        [signInRaw setTitle:@"签到规则" forState:UIControlStateNormal];
        signInRaw.layer.borderColor = HexColor(#CCDBEA).CGColor;
        signInRaw.layer.borderWidth = 1;
        
        //下面的签到视图
        UILabel *topNotice = [UILabel new];
        topNotice.font = PFFontR(16);
        topNotice.textColor = HexColor(#323232);
//        [topNotice addTitleColorTheme];
        topNotice.isAttributedContent = YES;
        
        UIView *signInView = [UIView new];
//        [signInView addBakcgroundColorTheme];
        
        UIImageView *bottomIcon = [UIImageView new];
        bottomIcon.contentMode = 4;
        
        UILabel *bottomNotice = [UILabel new];
        bottomNotice.font = PFFontL(12);
        bottomNotice.textColor = HexColor(#989898);
        
        [bottomView sd_addSubviews:@[
                                     topNotice,
                                     bottomIcon,
                                     bottomNotice,
                                     signInView,
                                     ]];
        topNotice.sd_layout
        .topSpaceToView(bottomView, 15)
        .leftSpaceToView(bottomView, 10)
        .rightSpaceToView(bottomView, 10)
        .heightIs(17)
        ;
        [topNotice updateLayout];
        NSString *noticeStr1 = @"今日已签到，明天最少可获得";
        NSString *noticeStr2 = [NSString stringWithFormat:@" %@积分",self.data[@"minPoints"]];
        NSMutableAttributedString *noticeAtt1 = [NSString leadString:noticeStr1 tailString:noticeStr2 font:PFFontR(16) color:RGBA(18, 130, 238, 1) lineBreak:NO];
        topNotice.attributedText = noticeAtt1;
        
        bottomIcon.sd_layout
        .leftSpaceToView(bottomView, 10)
        .bottomSpaceToView(bottomView, 9)
        .widthIs(20)
        .heightEqualToWidth()
        ;
//        [bottomIcon setSd_cornerRadius:@10];
//        bottomIcon.layer.borderWidth = 1;
//        bottomIcon.layer.borderColor = RGBA(207, 218, 229, 1).CGColor;
//        bottomIcon.image = UIImageNamed(@"game_rule");
        
        bottomNotice.sd_layout
        .leftSpaceToView(bottomIcon, 5)
        .centerYEqualToView(bottomIcon)
        .heightIs(12)
        ;
        [bottomNotice setSingleLineAutoResizeWithMaxWidth:250];
//        bottomNotice.text = @"连续3天不来我就会溜回圆点哦～";
        
        signInView.sd_layout
        .topSpaceToView(topNotice, 9)
        .leftSpaceToView(bottomView, 10)
        .rightSpaceToView(bottomView, 10)
        .heightIs(209)
        ;
        [signInView updateLayout];
        
        CGFloat avgW = 63;
        CGFloat avgH = 63;
        int numPerRow = 5;
        CGFloat avgMarginX = (signInView.width - numPerRow * avgW)/(numPerRow - 1);
        CGFloat avgMarginY = 10;
        CGFloat x = 0;
        CGFloat y = 0;
        int signInDays = [self.data[@"conSignDays"] intValue]; //测试签到天数
        
        for (int i = 0; i < 14; i ++) {
            //检查换行
            y = (avgMarginY + avgH) * (i/numPerRow);
            x = (avgMarginX + avgW) * (i%numPerRow);
            
            UIView *backView = [UIView new];
            backView.backgroundColor = HexColor(#F2F9FF);
            
            UIImageView *iconView = [UIImageView new];
            //            iconView.backgroundColor = Arc4randomColor;
            iconView.contentMode = 4;
            
            [signInView sd_addSubviews:@[
                                         backView,
                                         iconView,
                                         ]];
            backView.sd_layout
            .leftSpaceToView(signInView, x)
            .topSpaceToView(signInView, y)
            .widthIs(avgW)
            .heightEqualToWidth()
            ;
            [backView setSd_cornerRadius:@(avgW/2)];
            backView.layer.borderColor = HexColor(#CFDAE5).CGColor;
            backView.layer.borderWidth = 1;
            
            iconView.sd_layout
            .centerYEqualToView(backView)
            .centerXEqualToView(backView)
            .widthIs(38)
            .heightEqualToWidth()
            ;
            if (i < signInDays) {
                iconView.image = UIImageNamed(@"signIn_haveSignIn");
            }else{
                iconView.image = UIImageNamed(@"signIn_noSignIn");
            }
        }
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
    if (section == 0) {
        return self.taskModel.subTaskList.count;
    }
    if (section == 1) {
        //        return self.articlesArr.count;
        return 0;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell.contentView.subviews.count) {
            for (UIView *subView in cell.contentView.subviews) {
                [subView removeFromSuperview];
            }
        }
        DailyListModel *taskmodel = self.taskModel.subTaskList[indexPath.row];
        [self setViewWithCell:cell data:taskmodel];
        
    }else if (indexPath.section == 1){
        StoreChildCell *cell1 = (StoreChildCell *)[tableView dequeueReusableCellWithIdentifier:StoreChildCellID];
        cell = (UITableViewCell *)cell1;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 62;
    }
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 55;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 68;
    }
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0&&self.taskModel.subTaskList.count > 0) {
        
        headView = [UIView new];
        headView.backgroundColor = WhiteColor;
        
        UILabel *title = [UILabel new];
        title.font = PFFontR(16);
        
        UILabel *subTitle = [UILabel new];
        subTitle.font = PFFontL(14);
        subTitle.textColor = RGBA(152, 152, 152, 1);
        subTitle.isAttributedContent = YES;
        
        [headView sd_addSubviews:@[
                                   title,
                                   subTitle
                                   ]];
        title.sd_layout
        .topSpaceToView(headView, 15)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 15)
        .heightIs(16)
        ;
        title.text = @"做任务赚积分";
        
        subTitle.sd_layout
        .topSpaceToView(title, 9)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 15)
        .heightIs(15)
        ;
        
        NSString *str1 = @"今日已领";
        NSString *str2 = [NSString stringWithFormat:@" %ld ",self.taskModel.receivedPoints];
        NSMutableAttributedString *att1 = [NSString leadString:str1 tailString:str2 font:PFFontL(14) color:HexColor(#ff3722) lineBreak:NO];
        
        NSString *str3 = @"积分，还有";
        NSString *str4 = [NSString stringWithFormat:@" %ld ",self.taskModel.remainingPoints];;
        NSMutableAttributedString *att2 = [NSString leadString:str3 tailString:str4 font:PFFontL(14) color:HexColor(#ff3722) lineBreak:NO];
        
        NSString *str5 = @"积分可领";
        NSMutableAttributedString *att3 = [[NSMutableAttributedString alloc]initWithString:str5];
        [att1 appendAttributedString:att2];
        [att1 appendAttributedString:att3];
        
        subTitle.attributedText = att1;
    }
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0&& self.taskModel.subTaskList.count > 0) {
        
        footView = [UIView new];
        footView.backgroundColor = WhiteColor;
        
        
        UIButton *footBtn = [UIButton new];
        [footBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
        footBtn.titleLabel.font = PFFontR(14);
        footBtn.backgroundColor = RGBA(239, 247, 254, 1);
        [footView addSubview:footBtn];
        
        footBtn.sd_layout
        .leftSpaceToView(footView, 10)
        .rightSpaceToView(footView, 10)
        .topSpaceToView(footView, 10)
        .bottomSpaceToView(footView, 10)
        ;
        [footBtn setSd_cornerRadius:@5];
        [footBtn setTitle:@"想赚金币？马上开始任务之旅吧" forState:UIControlStateNormal];
        [footBtn setImage:UIImageNamed(@"signIn_taskGold") forState:UIControlStateNormal];
        footBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//分区0的cell
-(void)setViewWithCell:(UITableViewCell *)cell data:(DailyListModel *)taskModel
{
    UIView *fatherView = cell.contentView;
    
    UIImageView *taskIcon = [UIImageView new];
    taskIcon.backgroundColor = RGBA(221, 235, 247, 1);
    taskIcon.contentMode = 4;
    
    UILabel *taskTitle = [UILabel new];
    taskTitle.font = PFFontR(15);
    taskTitle.isAttributedContent = YES;
    
    UILabel *taskDone = [UILabel new];
    taskDone.font = PFFontL(14);
    taskDone.textColor = RGBA(152, 152, 152, 1);
    
    UILabel *taskAward = [UILabel new];
    taskAward.font = PFFontL(14);
    taskAward.textColor = RGBA(152, 152, 152, 1);
    taskAward.textAlignment = NSTextAlignmentCenter;
    
    [fatherView sd_addSubviews:@[
                                 taskIcon,
                                 taskTitle,
                                 taskDone,
                                 taskAward,
                                 ]];
    taskIcon.sd_layout
    .leftSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(37)
    .heightEqualToWidth()
    ;
    [taskIcon setSd_cornerRadius:@(37/2)];
//    taskIcon.image = UIImageNamed(GetSaveString(taskModel.taskIcon));
    if ([taskModel.taskIcon containsString:@"browse"]) {
        taskIcon.image = UIImageNamed(@"signIn_browse");
    }else if ([taskModel.taskIcon containsString:@"share"]){
        taskIcon.image = UIImageNamed(@"signIn_share");
    }else if ([taskModel.taskIcon containsString:@"publish-news"]){
        taskIcon.image = UIImageNamed(@"signIn_article");
    }else if ([taskModel.taskIcon containsString:@"publish-comment"]){
        taskIcon.image = UIImageNamed(@"signIn_comment");
    }else if ([taskModel.taskIcon containsString:@"game"]){
        taskIcon.image = UIImageNamed(@"signIn_game");
    }else if ([taskModel.taskIcon containsString:@"recharge"]){
        taskIcon.image = UIImageNamed(@"signIn_recharge");
    }else if ([taskModel.taskIcon containsString:@"publish-post"]){
        taskIcon.image = UIImageNamed(@"signIn_postDaily");
    }else if ([taskModel.taskIcon containsString:@"post-commented"]){
        taskIcon.image = UIImageNamed(@"signIn_postReply");
    }else if ([taskModel.taskIcon containsString:@"post-praised"]){
        taskIcon.image = UIImageNamed(@"signIn_praisePostOrComment");
    }else if ([taskModel.taskIcon containsString:@"comment-post"]){
        taskIcon.image = UIImageNamed(@"signIn_replyPost");
    }else if ([taskModel.taskIcon containsString:@"praise-post-comment"]){
        taskIcon.image = UIImageNamed(@"signIn_praisePostOrComment");
    }
    
    taskTitle.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(taskIcon, 10)
    .heightIs(15)
//    .autoWidthRatio(0)
    ;
    [taskTitle setSingleLineAutoResizeWithMaxWidth:ScreenW - 140];
    NSString *str1 = GetSaveString(taskModel.taskName);
    NSString *str2 = [NSString stringWithFormat:@"  +%ld积分 ",taskModel.taskPoints];
    NSMutableAttributedString *att = [NSString leadString:str1 tailString:str2 font:PFFontM(15) color:HexColor(#ff3722) lineBreak:NO];
    taskTitle.attributedText = att;
    
    taskDone.sd_layout
    .topSpaceToView(taskTitle, 10)
    .leftSpaceToView(taskIcon, 10)
    .heightIs(14)
    ;
    [taskDone setSingleLineAutoResizeWithMaxWidth:100];
    
    taskAward.sd_layout
    .centerYEqualToView(fatherView)
    .rightSpaceToView(fatherView, 10)
    .widthIs(60)
    .heightIs(30)
    ;
    [taskAward setSd_cornerRadius:@15];
    taskAward.layer.borderWidth = 1;
//    [taskAward setSingleLineAutoResizeWithMaxWidth:100];
    
    taskDone.text = [NSString stringWithFormat:@"完成 %ld / %ld",taskModel.accomplishedNum,taskModel.taskNum];
    
    if (taskModel.hasAccomplished) {
        taskAward.text = @"已完成";
        taskAward.textColor = HexColor(#989898);
        taskAward.layer.borderColor = HexColor(#989898).CGColor;
    }else{
        taskAward.text = @"去完成";
        taskAward.textColor = HexColor(#ff3722);
        taskAward.layer.borderColor = HexColor(#ff3722).CGColor;
        @weakify(self);
        [taskAward whenTap:^{
            @strongify(self);
            MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
            RTRootNavigationController *bvc = keyVC.viewControllers[3];
            IntegralViewController *ivC = (IntegralViewController *)bvc.rt_viewControllers[0];
            if ([taskModel.taskName containsString:@"游戏"]) {
                return ;
                [keyVC setSelectedIndex:3];
                [ivC setSelectIndex:1];
            }else if ([taskModel.taskName containsString:@"充值"]) {
                return ;
                [keyVC setSelectedIndex:3];
                [ivC setSelectIndex:2];
            }else if ([taskModel.taskIcon containsString:@"post"]){
                [keyVC setSelectedIndex:0];
            }else{
                [keyVC setSelectedIndex:0];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
//    taskAward.text = [NSString stringWithFormat:@"+%ld积分",taskModel.taskPoints];
}

#pragma mark ---- 请求发送
//签到
-(void)requestSignIn
{
    @weakify(self)
    [HttpRequest postWithURLString:SignIn parameters:nil isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        @strongify(self)
        self.data = response[@"data"];
        //为1，说明是签到，需要弹窗提示
        if ([self.data[@"statusCode"]integerValue] == 1) {
            [SignInPopView showWithData:self.data];
        }
        UserModel *user = [UserModel getLocalUserModel];
        if (user.integral != [self.data[@"totalPoints"] longValue]) {
            //不相等则需要修改
            user.integral = [self.data[@"totalPoints"] integerValue];
            [UserModel coverUserData:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserIntegralOrAvatarChanged object:nil];
        }
        
        [self addTableView];
        
        [self setHeadView];
        
        [self.view bringSubviewToFront:self.topModalView];
        
    } failure:nil RefreshAction:nil];
}

//获取任务列表
-(void)requestUser_getDailyTask
{
    [HttpRequest getWithURLString:User_getDailyTask parameters:nil success:^(id responseObject) {
        self.taskModel = [DailyTaskModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.tableView reloadData];
    } failure:nil];
}



@end
