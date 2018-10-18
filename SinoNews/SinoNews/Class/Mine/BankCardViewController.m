//
//  BankCardViewController.m
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BankCardViewController.h"
#import "BandingBankCardViewController.h"

@interface BankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) BaseTableView *tableView;

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (UserGetBool(@"NightMode")) {
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    }
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavigationBar
{
    self.navigationItem.title = @"银行卡";
    self.view.backgroundColor = HexColor(#1c2023);
    self.navigationController.navigationBar.barTintColor = HexColor(#1c2023);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"return_left_night"]];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[NSFontAttributeName] = PFFontL(16);
    dic[NSForegroundColorAttributeName] = HexColor(#FFFFFF);
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
    
    [self setTopLineColor:HexColorAlpha(#CECECE, 0.13)];
}

-(void)setUI
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.separatorColor = CutLineColorNight;
    self.tableView.backgroundColor = HexColor(#1c2023);
    [self.view addSubview:self.tableView];
    
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    ;
    [self.tableView updateLayout];
    
    [self.tableView registerClass:[BankCardTableViewCell class] forCellReuseIdentifier:BankCardTableViewCellID];
}

#pragma mark --- UITableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardTableViewCell *cell = (BankCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BankCardTableViewCellID];
    cell.backgroundColor = HexColor(#1c2023);
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        footView.backgroundColor = HexColor(#1c2023);
        
        UIButton *add = [UIButton new];
        add.backgroundColor = HexColor(#1c2023);
        [add setBtnFont:PFFontL(16)];
        [add setNormalTitleColor:HexColor(#69738D)];
        add.userInteractionEnabled = NO;
        
        UIView *sepLine = [UIView new];
        sepLine.backgroundColor = HexColor(#32394A);
        
        [footView sd_addSubviews:@[
                                   add,
                                   sepLine,
                                   ]];
        add.sd_layout
        .leftSpaceToView(footView, 10)
        .topSpaceToView(footView, 10)
        .bottomSpaceToView(footView, 20)
        .widthIs(120)
        ;
        [add setNormalTitle:@"更换银行卡"];
        [add setNormalImage:UIImageNamed(@"bankCard_addIcon")];
        add.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        add.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        sepLine.sd_layout
        .bottomEqualToView(footView)
        .leftEqualToView(footView)
        .rightEqualToView(footView)
        .heightIs(1)
        ;
        @weakify(self);
        [footView whenTap:^{
            @strongify(self);
            BandingBankCardViewController *bbcVC = [BandingBankCardViewController new];
            bbcVC.refreshCard = ^{
                [self getUserBankCard];
            };
            [self.navigationController pushViewController:bbcVC animated:YES];
        }];
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//获取用户银行卡列表
-(void)getUserBankCard
{
    [HttpRequest postWithURLString:ListMyBankCards parameters:nil isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        self.dataSource = [BankCardModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.tableView reloadData];
    } failure:nil RefreshAction:nil];
}

@end
