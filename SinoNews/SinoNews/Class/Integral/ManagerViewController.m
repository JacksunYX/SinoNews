//
//  ManagerViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ManagerViewController.h"

#import "BaseTableView.h"
#import "ManagerRecordCell.h"

@interface ManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *userIcon;  //头像
    UILabel     *userName;  //昵称
    UILabel     *integer;   //积分
}

@property (nonatomic,strong) LXSegmentBtnView *segmentView;
@property (nonatomic,strong) CAGradientLayer *gradient;

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ManagerViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *behavior = @[
                              @"签到",
                              @"猜大小游戏",
                              @"回答被采纳",
                              @"发表评论",
                              @"发表文章",
                              @"分享得积分",
                              @"回答问题",
                              @"兑换iphone8",
                              ];
        NSArray *subBehavior = @[
                                 @"",
                                 @"投注小",
                                 @"",
                                 @"",
                                 @"",
                                 @"",
                                 @"",
                                 @"",
                                 ];
        NSArray *time = @[
                          @"2018-12-23",
                          @"2018-12-23",
                          @"2018-12-23",
                          @"2018-12-23",
                          @"2018-12-23",
                          @"2018-12-23",
                          @"2018-12-23",
                          @"2018-12-23",
                          ];
        
        NSArray *integerChange = @[
                                   @"-35",
                                   @"+1100",
                                   @"-100",
                                   @"+500",
                                   @"+100",
                                   @"+5100",
                                   @"-800",
                                   @"+100",
                                   ];
        
        NSArray *balance = @[
                             @"5500",
                             @"6500",
                             @"12000",
                             @"3500",
                             @"500",
                             @"1500",
                             @"550",
                             @"2300",
                             ];
        for (int i = 0; i < behavior.count; i ++) {
            NSDictionary *dic = @{
                                  @"behavior"       :   behavior[i],
                                  @"subBehavior"    :   subBehavior[i],
                                  @"time"           :   time[i],
                                  @"integerChange"  :   integerChange[i],
                                  @"balance"        :   balance[i],
                                  };
            [_dataSource addObject:dic];
        }
    }
    return _dataSource;
}

- (CAGradientLayer *)gradient
{
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, (ScreenW - 20)/3, 45);
        _gradient.colors = [NSArray arrayWithObjects:
                           (id)RGBA(79, 160, 238, 1).CGColor,
                           (id)RGBA(173, 208, 241, 1).CGColor, nil];
        _gradient.startPoint = CGPointMake(0, 0.5);
        _gradient.endPoint = CGPointMake(1, 0.5);
        _gradient.locations = @[@0.0, @1];
    }
    return _gradient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理";
    self.view.backgroundColor = WhiteColor;
    
    [self setupTopViews];
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//上部分
-(void)setupTopViews
{
    userIcon = [UIImageView new];
    userName = [UILabel new];
    userName.font = FontScale(15);
    integer = [UILabel new];
    integer.font = FontScale(15);
    UIView *line = [UIView new];
    
    [self.view sd_addSubviews:@[
                                      userIcon,
                                      userName,
                                      integer,
                                      line,
                                      ]];
    userIcon.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, 10)
    .widthIs(44)
    .heightEqualToWidth()
    ;
    [userIcon setSd_cornerRadius:@22];
    userIcon.image = UIImageNamed(@"userIcon");
    
    userName.sd_layout
    .leftSpaceToView(userIcon, 7)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(15))
    ;
    [userName setSingleLineAutoResizeWithMaxWidth:150];
    userName.text = @"春风十里不如你";
    
    integer.sd_layout
    .rightSpaceToView(self.view, 10)
    .centerYEqualToView(userIcon)
    .heightIs(kScaelW(14))
    ;
    [integer setSingleLineAutoResizeWithMaxWidth:150];
    integer.text = @"1000000积分";
    
    _segmentView = [LXSegmentBtnView new];
    [self.view addSubview:_segmentView];
    
    _segmentView.sd_layout
    .topSpaceToView(userIcon, 17)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(45)
    ;
    
    [_segmentView updateLayout];
    _segmentView.btnTitleSelectColor = RGBA(18, 130, 238, 1);
    _segmentView.btnTitleNormalColor = RGBA(136, 136, 136, 1);
    WeakSelf
    _segmentView.lxSegmentBtnSelectIndexBlock = ^(NSInteger index, UIButton *btn) {
        [weakSelf setColorWithBtn:btn];
    };
    
    _segmentView.btnTitleArray = @[
                                   @"积分记录",
                                   @"游戏记录",
                                   @"兑换记录",
                                   ];
    
}

-(void)setColorWithBtn:(UIButton *)btn
{
    self.gradient.frame = CGRectMake(0, 0, (ScreenW - 20)/3, 45);
    [btn.layer insertSublayer:self.gradient below:btn.titleLabel.layer];
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        [self.tableView.top_attr equalTo:self.segmentView.bottom_attr constant:10];
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _tableView.backgroundColor = WhiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [_tableView registerClass:[ManagerRecordCell class] forCellReuseIdentifier:ManagerRecordCellID];
    
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
    ManagerRecordCell *cell = (ManagerRecordCell *)[tableView dequeueReusableCellWithIdentifier:ManagerRecordCellID];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenH tableView:tableView];
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (kArrayIsEmpty(self.dataSource)) {
        return 0.01;
    }
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    if (kArrayIsEmpty(self.dataSource)) {
        return nil;
    }
    UIView *topLine = [UIView new];
    topLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = RGBA(227, 227, 227, 1);
    
    [headView sd_addSubviews:@[
                               topLine,
                               leftLine,
                               rightLine,
                               bottomLine,
                               ]];
    topLine.sd_layout
    .topEqualToView(headView)
    .leftSpaceToView(headView, 10)
    .rightSpaceToView(headView, 10)
    .heightIs(1)
    ;
    
    leftLine.sd_layout
    .leftSpaceToView(headView, 10)
    .topEqualToView(headView)
    .bottomEqualToView(headView)
    .widthIs(1)
    ;
    
    rightLine.sd_layout
    .rightSpaceToView(headView, 10)
    .topEqualToView(headView)
    .bottomEqualToView(headView)
    .widthIs(1)
    ;
    
    bottomLine.sd_layout
    .leftSpaceToView(headView, 10)
    .rightSpaceToView(headView, 10)
    .bottomEqualToView(headView)
    .heightIs(1)
    ;

    NSArray *headTitle = @[
                           @"行为",
                           @"时间",
                           @"积分变化",
                           @"余额",
                           ];
    CGFloat lrMargin = 10;
    CGFloat xMargin = 0;
    CGFloat labelWid = (ScreenW - 2 * lrMargin)/headTitle.count;
    CGFloat labelHei = 35;
    CGFloat x = lrMargin;
    
    for (int i = 0; i < headTitle.count; i ++) {
        UILabel *label = [UILabel new];
        label.font = Font(15);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = GetSaveString(headTitle[i]);
        
        [headView addSubview:label];
        label.sd_layout
        .topEqualToView(headView)
        .leftSpaceToView(headView, x)
        .widthIs(labelWid)
        .heightIs(labelHei)
        ;
        
        x += xMargin + labelWid;
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGLog(@"点击了第%ld个",indexPath.row);
}






@end
