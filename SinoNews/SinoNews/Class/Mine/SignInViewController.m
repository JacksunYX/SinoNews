//
//  SignInViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/28.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SignInViewController.h"
#import "StoreChildCell.h"
#import "SignInPopView.h"

@interface SignInViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *taskArr;       //任务
@property (nonatomic,strong) NSMutableArray *integralArr;   //积分兑换

@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) UIView *headView;
@end

@implementation SignInViewController

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
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"天天签到";
    
    [self requestSignIn];
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
    self.tableView.backgroundColor = BACKGROUND_COLOR;
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
        self.headView.backgroundColor = WhiteColor;
        //最上面的广告
        UIImageView *topADImg = [UIImageView new];
        topADImg.backgroundColor = WhiteColor;
        //中间的用户信息
        UIView *centerView = [UIView new];
        centerView.backgroundColor = WhiteColor;
        //下面的签到视图
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = WhiteColor;
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
        [centerView addBorderTo:BorderTypeBottom borderSize:CGSizeMake(ScreenW - 20, 1) borderColor:RGBA(227, 227, 227, 1)];
        
        bottomView.sd_layout
        .topSpaceToView(centerView, 0)
        .leftEqualToView(self.headView)
        .rightEqualToView(self.headView)
        .heightIs(280)
        ;
        [bottomView updateLayout];
        [bottomView addBorderTo:BorderTypeBottom borderSize:CGSizeMake(ScreenW - 20, 1) borderColor:RGBA(227, 227, 227, 1)];
        
        //中间的用户信息
        UIImageView *userIcon = [UIImageView new];
        
        UILabel *integral = [UILabel new];
        integral.font = PFFontL(13);
        integral.textColor = RGBA(50, 50, 50, 1);
        integral.isAttributedContent = YES;
        
        UILabel *signInDay = [UILabel new];
        signInDay.font = PFFontL(14);
        signInDay.textColor = RGBA(152, 152, 152, 1);
        
        UIButton *signInRaw = [UIButton new];
        signInRaw.titleLabel.font = PFFontL(14);
        [signInRaw setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
        
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
        NSMutableAttributedString *integralAtt1 = [NSString leadString:integralStr1 tailString:integralStr2 font:PFFontR(17) color:RGBA(242, 87, 71, 1) lineBreak:NO];
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
        signInRaw.layer.borderColor = RGBA(204, 219, 234, 1).CGColor;
        signInRaw.layer.borderWidth = 1;
        
        //下面的签到视图
        UILabel *topNotice = [UILabel new];
        topNotice.font = PFFontR(16);
        topNotice.textColor = RGBA(50, 50, 50, 1);
        topNotice.isAttributedContent = YES;
        
        UIView *signInView = [UIView new];
        signInView.backgroundColor = WhiteColor;
        
        UIImageView *bottomIcon = [UIImageView new];
        bottomIcon.contentMode = 4;
        
        UILabel *bottomNotice = [UILabel new];
        bottomNotice.font = PFFontL(12);
        bottomNotice.textColor = RGBA(152, 152, 152, 1);
        
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
        NSString *noticeStr1 = @"今日已签到";
        NSString *noticeStr2 = @"";
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
            backView.backgroundColor = RGBA(242, 249, 255, 1);
            
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
            backView.layer.borderColor = RGBA(207, 218, 229, 1).CGColor;
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
        return self.taskArr.count;
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
        NSDictionary *dic = self.taskArr[indexPath.row];
        [self setViewWithCell:cell data:dic];
        
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
    if (section == 0&&self.taskArr.count > 0) {
        
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
        NSString *str2 = @" 0 ";
        NSMutableAttributedString *att1 = [NSString leadString:str1 tailString:str2 font:PFFontL(14) color:RGBA(242, 87, 71, 1) lineBreak:NO];
        
        NSString *str3 = @"积分，还有";
        NSString *str4 = @" 35 ";
        NSMutableAttributedString *att2 = [NSString leadString:str3 tailString:str4 font:PFFontL(14) color:RGBA(242, 87, 71, 1) lineBreak:NO];
        
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
    if (section == 0&& self.taskArr.count > 0) {
        
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
-(void)setViewWithCell:(UITableViewCell *)cell data:(NSDictionary *)data
{
    UIView *fatherView = cell.contentView;
    
    UIImageView *taskIcon = [UIImageView new];
    taskIcon.backgroundColor = RGBA(221, 235, 247, 1);
    taskIcon.contentMode = 4;
    
    UILabel *taskTitle = [UILabel new];
    taskTitle.font = PFFontR(15);
    
    UILabel *taskDone = [UILabel new];
    taskDone.font = PFFontL(14);
    taskDone.textColor = RGBA(152, 152, 152, 1);
    
    UILabel *taskAward = [UILabel new];
    taskAward.font = PFFontL(14);
    taskAward.textColor = RGBA(152, 152, 152, 1);
    
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
    taskIcon.image = UIImageNamed(GetSaveString(data[@"taskIcon"]));
    
    taskTitle.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(taskIcon, 10)
    .heightIs(15)
    ;
    [taskTitle setSingleLineAutoResizeWithMaxWidth:150];
    taskTitle.text = GetSaveString(data[@"taskTitle"]);
    
    taskDone.sd_layout
    .topSpaceToView(taskTitle, 10)
    .leftSpaceToView(taskIcon, 10)
    .heightIs(14)
    ;
    [taskDone setSingleLineAutoResizeWithMaxWidth:100];
    if (data[@"taskDone"]) {
        taskDone.text = @"已完成";
    }else{
        taskDone.text = @"未完成";
    }
    
    taskAward.sd_layout
    .centerYEqualToView(fatherView)
    .rightSpaceToView(fatherView, 10)
    .heightIs(14)
    ;
    [taskAward setSingleLineAutoResizeWithMaxWidth:100];
    taskAward.text = GetSaveString(data[@"taskAward"]);
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
        [self addTableView];
        
        [self setHeadView];
        
    } failure:nil RefreshAction:nil];
}





@end
