//
//  RankDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/1.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BaseTableView.h"

#import "RankDetailViewController.h"

@interface RankDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation RankDetailViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        
        [_dataSource addObject:[self addSection0Data]];
        
        [_dataSource addObject:[self addSection1Data]];
    }
    return _dataSource;
}

-(NSArray *)addSection0Data
{
    NSDictionary *dic0_0 = @{
                             @"title"         :   @"猜大小娱乐场",
                             @"icon"          :   @"user_icon",
                             @"webserveUrl"   :   @"www.baidu.com",
                             @"collectType"   :   @"1",
                             };
    NSDictionary *dic0_1 = @{
                             @"icon"          :   @"game_discount",
                             @"title"         :   @"优惠：首冲100送50",
                             };
    NSDictionary *dic0_2 = @{
                             @"icon"          :   @"game_setup",
                             @"title"         :   @"成立：2018年",
                             };
    NSArray *section0 = @[dic0_0,dic0_1,dic0_2];
    return section0;
}

-(NSArray *)addSection1Data
{
    NSDictionary *dic1_0 = @{
                             @"icon"          :   @"game_type",
                             @"title"         :   @"游戏：体育/真人/老虎机/捕鱼/电竞/金融",
                             };
    NSDictionary *dic1_1 = @{
                             @"icon"          :   @"game_operation",
                             @"title"         :   @"運营：中国/泰国/美国",
                             };
    NSDictionary *dic1_2 = @{
                             @"icon"          :   @"game_reserve",
                             @"title"         :   @"备用：网址1  网址2",
                             };
    NSDictionary *dic1_3 = @{
                             @"icon"          :   @"game_introduce",
                             @"title"         :   @"简介：猜大小娱乐场是当今比较流行的游戏，方 便人们的操作，娱乐与赚钱于一体.",
                             };
    
    NSArray *section1 = @[dic1_0,dic1_1,dic1_2,dic1_3];
    return section1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"启示录";
    self.view.backgroundColor = WhiteColor;
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册

}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 4;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0 || indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UIView *fatherView = cell.contentView;
        if (fatherView.subviews.count) {
            for (UIView *subview in fatherView.subviews) {
                [subview removeFromSuperview];
            }
        }
        
        NSArray *data = self.dataSource[indexPath.section];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self setSection0Row0WithData:data[indexPath.row] onView:cell];
            }else{
                [self setSection0OtherRowWithData:data[indexPath.row] onView:cell];
            }
        }else if (indexPath.section == 1){
            [self setSection0OtherRowWithData:data[indexPath.row] onView:cell];
        }
        
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }else{
            return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
        }
    }
    if (indexPath.section == 1) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

//设置0区0行内容
-(void)setSection0Row0WithData:(NSDictionary *)model onView:(UITableViewCell *)cell
{
    UIView *fatherView = cell.contentView;
    UIImageView *star = [UIImageView new];
    UIImageView *icon = [UIImageView new];
    
    UILabel *title = [UILabel new];
    title.font = FontScale(16);
    
    UIButton *collectBtn = [UIButton new];
    collectBtn.titleLabel.font = FontScale(15);
    [collectBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    UIButton *websiteBtn = [UIButton new];
    websiteBtn.titleLabel.font = FontScale(15);
    [websiteBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    [fatherView sd_addSubviews:@[
                                 star,
                                 icon,
                                 title,
                                 websiteBtn,
                                 collectBtn,
                                 ]];
    //布局
    star.sd_layout
    .leftSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(54)
    .heightIs(61)
    ;
    star.image = UIImageNamed(@"game_sixStar");
    
    icon.sd_layout
    .centerYEqualToView(star)
    .centerXEqualToView(star)
    .widthIs(50)
    .heightEqualToWidth()
    ;
    icon.image = UIImageNamed(GetSaveString(model[@"icon"]));
    
    title.sd_layout
    .centerYEqualToView(fatherView)
    .leftSpaceToView(star, 7)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:1];
    [title setSingleLineAutoResizeWithMaxWidth:100];
    title.text = GetSaveString(model[@"title"]);
    
    collectBtn.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(50 * ScaleW)
    .heightIs(23)
    ;
    [collectBtn setTitle:@"官网" forState:UIControlStateNormal];
    [collectBtn setSd_cornerRadius:@5];
    collectBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    collectBtn.layer.borderWidth = 1;
    
    websiteBtn.sd_layout
    .rightSpaceToView(collectBtn, 10)
    .centerYEqualToView(fatherView)
    .widthIs(32 * ScaleW)
    .heightIs(23)
    ;
    UIImage *img;
    if ([model[@"collectType"] integerValue]) {
        img = UIImageNamed(@"game_collected");
    }else{
        img = UIImageNamed(@"game_unCollect");
    }
    [websiteBtn setImage:img forState:UIControlStateNormal];
    [websiteBtn setSd_cornerRadius:@5];
    websiteBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    websiteBtn.layer.borderWidth = 1;
}

//0区其他行
-(void)setSection0OtherRowWithData:(NSDictionary *)model onView:(UITableViewCell *)cell
{
    UIView *fatherView = cell.contentView;
    
    UIImageView *leftIcon = [UIImageView new];
    UILabel *descrip = [UILabel new];
    descrip.font = FontScale(15);
    
    [fatherView sd_addSubviews:@[
                                 leftIcon,
                                 descrip,
                                 
                                 ]];
    leftIcon.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 10)
    .widthIs(20)
    .heightEqualToWidth()
    ;
    leftIcon.image = UIImageNamed(GetSaveString(model[@"icon"]));
    
    descrip.sd_layout
    .leftSpaceToView(leftIcon, 10)
    .rightSpaceToView(fatherView, 10)
    .topEqualToView(leftIcon)
    .autoHeightRatio(0)
    ;
    descrip.text = GetSaveString(model[@"title"]);
    [cell setupAutoHeightWithBottomView:descrip bottomMargin:10];
}

//跳转到网页
-(void)openUrlWithString:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}




@end
