//
//  ForumDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumDetailViewController.h"

#import "ForumDetailTableViewCell.h"
#import "ReadPostListTableViewCell.h"

@interface ForumDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MLMSegmentHeadDelegate>
@property (nonatomic,strong) UIButton *attentionBtn;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) BOOL haveUnFold;   //是否已展开
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) MLMSegmentHead *segHead;
@property (nonatomic,strong) NSDictionary *lastReplyDic;
@end

@implementation ForumDetailViewController
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _headView.backgroundColor = WhiteColor;
    }
    return _headView;
}

-(UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        _footView.backgroundColor = HexColor(#F3F5F4);
        
        UIButton *topBtn = [UIButton new];
        topBtn.backgroundColor = WhiteColor;
        [_footView addSubview:topBtn];
        topBtn.sd_layout
        .topEqualToView(_footView)
        .leftEqualToView(_footView)
        .rightEqualToView(_footView)
        .bottomSpaceToView(_footView, 10)
        ;
        [topBtn setBtnFont:PFFontL(12)];
        [topBtn setNormalTitle:@"展开查看更多"];
        [topBtn setSelectedTitle:@"收起"];
        [topBtn setNormalTitleColor:HexColor(#ABB2C3)];
        [topBtn setSelectedTitleColor:HexColor(#ABB2C3)];
        [topBtn setNormalImage:UIImageNamed(@"forum_downArrow")];
        [topBtn setSelectedImage:UIImageNamed(@"forum_upArrow")];
        topBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        topBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -170);
        [topBtn addTarget:self action:@selector(checkMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationView];
    
    [self setUI];
}

//修改导航栏显示
-(void)addNavigationView
{
    UIBarButtonItem *searchBtn = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(@"forum_search")];
    
    _attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_attentionBtn setNormalImage:UIImageNamed(@"forum_notAttention")];
    [_attentionBtn setSelectedImage:UIImageNamed(@"forum_attention")];
    _attentionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc]initWithCustomView:_attentionBtn];
    
    self.navigationItem.rightBarButtonItems = @[searchBtn,rightBtn2];
}

-(void)setUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0))
    ;
//    [self.tableView activateConstraints:^{
//        self.tableView.top_attr = self.view.top_attr_safe;
//        self.tableView.left_attr = self.view.left_attr_safe;
//        self.tableView.right_attr = self.view.right_attr_safe;
//        self.tableView.bottom_attr = self.view.bottom_attr_safe;
//    }];
    [_tableView registerClass:[ForumDetailTableViewCell class] forCellReuseIdentifier:ForumDetailTableViewCellID];
    [_tableView registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
}

-(void)addSegment
{
    if (_segHead) {
        return;
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 80, 44) titles:@[@"全部",@"热门",@"好文",@"南方航空",@"求助问答",@"心得攻略",@"活动优惠",] headStyle:1 layoutStyle:2];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.2;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 2;
    _segHead.maxTitles = 5;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    //    _segHead.deSelectColor = HexColor(#323232);
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setDeSelectColor:value];
    });
    _segHead.bottomLineHeight = 0;
    _segHead.singleW_Add = 40;
    _segHead.delegate = self;
    
    @weakify(self);
    [MLMSegmentManager associateHead:_segHead withScroll:nil completion:^{
        @strongify(self);
        [self.headView addSubview:self.segHead];
    }];
    
    UIView *sepLine = [UIView new];
    //    sepLine.backgroundColor = kWhite(0.1);
    [self.headView addSubview:sepLine];
    sepLine.sd_layout
    .rightSpaceToView(self.headView, 80)
    .centerYEqualToView(self.headView)
    .widthIs(1)
    .heightIs(20)
    ;
    //添加阴影
    
    sepLine.layer.shadowColor = GrayColor.CGColor;
    sepLine.layer.shadowOffset = CGSizeMake(-1, 0);
    sepLine.layer.shadowOpacity = 1;
    sepLine.layer.shouldRasterize = NO;
    sepLine.layer.shadowPath = [UIBezierPath bezierPathWithRect:sepLine.bounds].CGPath;
    
    UIButton *sortBtn = [UIButton new];
    [self.headView addSubview:sortBtn];
    sortBtn.sd_layout
    .rightSpaceToView(self.headView, 10)
    .leftSpaceToView(sepLine, 10)
    .heightIs(20)
    .centerYEqualToView(self.headView)
    ;
    [sortBtn setNormalTitle:@"按回复"];
    [sortBtn setSelectedTitle:@"按发帖"];
    [sortBtn setNormalTitleColor:HexColor(#626262)];
    [sortBtn setSelectedTitleColor:HexColor(#626262)];
    [sortBtn setBtnFont:PFFontL(14)];
    [sortBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
}

//搜索点击
-(void)searchAction
{
    PopReplyViewController *prVC = [PopReplyViewController new];
    prVC.inputData = self.lastReplyDic.mutableCopy;
    @weakify(self);
    prVC.finishBlock = ^(NSDictionary * _Nonnull inputData) {
        GGLog(@"发布回调:%@",inputData);
        @strongify(self);
        self.lastReplyDic = inputData;
        //这里发布后把该数据清空就行了
    };
    prVC.cancelBlock = ^(NSDictionary * _Nonnull cancelData) {
        GGLog(@"取消回调:%@",cancelData);
        @strongify(self);
        self.lastReplyDic = cancelData;
    };
    [self.navigationController pushViewController:prVC animated:NO];
}

//关注点击
-(void)attentionAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

//查看更多、收起点击事件
-(void)checkMoreAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.haveUnFold = sender.selected;
    if (sender.selected) {
        sender.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -70);
    }else{
        sender.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -170);
    }
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

//排序点击
-(void)sortClick:(UIButton *)sender
{

    UIAlertController *popVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sortByReplyTime = [UIAlertAction actionWithTitle:@"按回复时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sender.selected = NO;
    }];
    UIAlertAction *sortByPostTime = [UIAlertAction actionWithTitle:@"按发帖时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sender.selected = YES;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [popVC addAction:sortByReplyTime];
    [popVC addAction:sortByPostTime];
    [popVC addAction:cancel];
    [self presentViewController:popVC animated:YES completion:nil];
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    if (_haveUnFold) {
        return 10;
    }
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        ForumDetailTableViewCell *cell0 = (ForumDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumDetailTableViewCellID];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"type"] = @(indexPath.row);
        dic[@"label"] = @"置顶";
        if (indexPath.row == 0) {
            dic[@"label"] = @"公告";
        }
        [cell0 setData:dic];
        cell = cell0;
    }else if (indexPath.section == 1) {
        ReadPostListTableViewCell *cell1 = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"imgs"] = @"0";
        if (indexPath.row == 0) {
            dic[@"ShowChildComment"] = @(1);
        }else if (indexPath.row == 1) {
            dic[@"imgs"] = @"1";
            dic[@"ShowChildComment"] = @(1);
        }else if(indexPath.row == 2){
            dic[@"imgs"] = @"3";
            dic[@"ShowChildComment"] = @(1);
        }
        
        [cell1 setData:dic];
        cell = cell1;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = self.footView;
        
        return view;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = self.headView;
        [self addSegment];
        return view;
    }
    return nil;
}

#pragma mark --- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    GGLog(@"下标:%ld",index);
}

@end
