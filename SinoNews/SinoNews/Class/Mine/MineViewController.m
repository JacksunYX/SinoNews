//
//  MineViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MineViewController.h"

#import "SettingViewController.h"
#import "BrowsingHistoryVC.h"

@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
//下方广告视图
@property (nonatomic ,strong) UICollectionView *adCollectionView;
@property (nonatomic ,strong) NSMutableArray *adDatasource;
//上方
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *mainDatasource;

@property (nonatomic ,strong) UIImageView *userImg;
@end

@implementation MineViewController

-(NSMutableArray *)adDatasource
{
    if (!_adDatasource) {
        _adDatasource  = [NSMutableArray new];
        for (int i = 0; i < 4; i ++) {
            NSString *imgStr = [NSString stringWithFormat:@"ad_banner%d",i];
            [_adDatasource addObject:imgStr];
        }
    }
    return _adDatasource;
}

-(NSMutableArray *)mainDatasource
{
    if (!_mainDatasource) {
        NSArray *title = @[
                              @"消息",
                              @"收藏",
                              @"历史",
                              @"分享",
                              @"设置",
                              @"积分充值",
                              @"积分游戏",
                              @"积分商城",
                              @"积分管理",
                              ];
        NSArray *img = @[
                         @"mine_message",
                         @"mine_collect",
                         @"mine_history",
                         @"mine_share",
                         @"mine_setting",
                         @"mine_integralRecharge",
                         @"mine_integralGame",
                         @"mine_integralShop",
                         @"mine_integralManager",
                         ];
        
        NSArray *rightTitle = @[
                                @"最新消息标题",
                                @"收藏娱乐城快速进入",
                                @"",
                                @"分享的积分",
                                @"",
                                @"1元=100积分",
                                @"玩游戏赢积分",
                                @"",
                                @"",
                                ];
        NSMutableArray *section0 = [NSMutableArray new];
        NSMutableArray *section1 = [NSMutableArray new];
        for (int i = 0 ; i < title.count; i ++) {
            NSDictionary *dic = @{
                                  @"title"      :   title[i],
                                  @"img"        :   img[i],
                                  @"rightTitle" :   rightTitle[i],
                                  };
            if (i < 5) {
                [section0 addObject:dic];
            }else{
                [section1 addObject:dic];
            }
        }
        _mainDatasource = [NSMutableArray new];
        [_mainDatasource addObjectsFromArray:@[section0,section1]];
        
    }
    return _mainDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self addViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

//添加视图
-(void)addViews
{
    [self addBottomADView];
    [self addTopTableView];
    [self addHeadView];
}

//添加下方广告视图
-(void)addBottomADView
{
    //下方的
    UICollectionViewFlowLayout *adLayout = [UICollectionViewFlowLayout new];
    adLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemW = (ScreenW - 35)/4;
    CGFloat itemH = itemW * 60 / 85;
    adLayout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
    adLayout.itemSize = CGSizeMake(itemW, itemH);
    adLayout.minimumLineSpacing = 5;
    self.adCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:adLayout];
    self.adCollectionView.backgroundColor = WhiteColor;
    [self.view addSubview:self.adCollectionView];
    [self.adCollectionView activateConstraints:^{
        self.adCollectionView.bottom_attr = self.view.bottom_attr_safe;
        self.adCollectionView.left_attr = self.view.left_attr_safe;
        self.adCollectionView.right_attr = self.view.right_attr_safe;
        self.adCollectionView.height_attr.constant = 30 + itemH;
    }];
    
    self.adCollectionView.dataSource = self;
    self.adCollectionView.delegate = self;
    [self.adCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ADCellID"];
}

//添加上方的tableview
-(void)addTopTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.adCollectionView.top_attr;
    }];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
}

-(void)addHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 230)];
    headView.backgroundColor = RGBA(196, 222, 247, 1);
    self.tableView.tableHeaderView = headView;
    
    _userImg = [UIImageView new];
    UILabel *userName = [UILabel new];
    userName.font = Font(17);
    userName.textColor = RGBA(72, 72, 72, 1);
    
    UILabel *integral = [UILabel new];
    integral.font = Font(16);
    integral.textColor = RGBA(119, 119, 119, 1);
    
    UIButton *signIn = [UIButton new];
    
    UILabel *publish = [self getLabel];
    UILabel *attention = [self getLabel];
    UILabel *fans = [self getLabel];
    UILabel *praise = [self getLabel];
    
    [headView sd_addSubviews:@[
                               _userImg,
                               userName,
                               integral,
                               signIn,
                               
                               publish,
                               attention,
                               fans,
                               praise
                               ]];
    
    _userImg.sd_layout
    .topSpaceToView(headView, 54)
    .leftSpaceToView(headView, 10)
    .widthIs(64)
    .heightEqualToWidth()
    ;
    _userImg.image = UIImageNamed(@"userIcon");
    [_userImg setSd_cornerRadius:@32];
    
    userName.sd_layout
    .bottomSpaceToView(_userImg, -27)
    .leftSpaceToView(_userImg, 18 * ScaleW)
    .heightIs(20)
    ;
    [userName setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
    userName.text = @"一辈子一场梦";
    
    integral.sd_layout
    .topSpaceToView(userName, 10)
    .leftEqualToView(userName)
    .heightIs(20)
    ;
    [integral setSingleLineAutoResizeWithMaxWidth:100];
    integral.text = @"11200积分";
    
    signIn.sd_layout
    .rightEqualToView(headView)
    .centerYEqualToView(_userImg)
    .heightIs(26)
    .widthIs(113 * ScaleW)
    ;
    signIn.backgroundColor = RGBA(178, 217, 249, 1);
    [signIn setTitle:@"签到领金币" forState:UIControlStateNormal];
    signIn.titleLabel.font = FontScale(14);
    [signIn setTitleColor:RGBA(119, 119, 119, 1) forState:UIControlStateNormal];
    [signIn setImage:UIImageNamed(@"mine_gold") forState:UIControlStateNormal];
    signIn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5 * ScaleW);
    [self cutCornerradiusWithView:signIn];
    
    publish.sd_layout
    .topSpaceToView(_userImg, 50)
    .leftEqualToView(headView)
    .bottomSpaceToView(headView, 20)
    .widthIs(ScreenW/4)
    ;
    publish.attributedText = [self leadString:@"0" tailString:@"文章" font:Font(14) color:RGBA(119, 119, 119, 1) lineBreak:YES];
    
    attention.sd_layout
    .topEqualToView(publish)
    .leftSpaceToView(publish, 0)
    .bottomSpaceToView(headView, 20)
    .widthIs(ScreenW/4)
    ;
    attention.attributedText = [self leadString:@"0" tailString:@"关注" font:Font(14) color:RGBA(119, 119, 119, 1)  lineBreak:YES];
    
    fans.sd_layout
    .topEqualToView(publish)
    .leftSpaceToView(attention, 0)
    .bottomSpaceToView(headView, 20)
    .widthIs(ScreenW/4)
    ;
    fans.attributedText = [self leadString:@"0" tailString:@"粉丝" font:Font(14) color:RGBA(119, 119, 119, 1)  lineBreak:YES];
    
    praise.sd_layout
    .topEqualToView(publish)
    .leftSpaceToView(fans, 0)
    .bottomSpaceToView(headView, 20)
    .widthIs(ScreenW/4)
    ;
    praise.attributedText = [self leadString:@"0" tailString:@"获赞" font:Font(14) color:RGBA(119, 119, 119, 1)  lineBreak:YES];
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTouch)];
    userTap.numberOfTapsRequired = 1;
    _userImg.userInteractionEnabled = YES;
    [_userImg addGestureRecognizer:userTap];
    
}

-(void)userTouch
{
    WEAK(weakSelf, self)
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        STRONG(strongSelf, weakSelf)
        //先对质量压缩
        NSData *imgData = [(UIImage *)data compressWithMaxLength:100 * 1024];
        UIImage *img = [UIImage imageWithData:imgData];
        strongSelf.userImg.image = img;
        
    }];
}

//获取统一label
-(UILabel *)getLabel
{
    UILabel *label = [UILabel new];
    label.textColor = RGBA(119, 119, 119, 1);
    label.font = Font(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.isAttributedContent = YES;
    return label;
}

//返回定制文字
-(NSMutableAttributedString *)leadString:(NSString *)str1 tailString:(NSString *)str2 font:(UIFont *)font color:(UIColor *)color lineBreak:(BOOL)tab
{
    NSString *totalStr;
    if (tab) {
        totalStr = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    }else{
        totalStr = [str1 stringByAppendingString:str2];
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSDictionary *attDic = @{
                             NSFontAttributeName:font,
                             NSForegroundColorAttributeName:color,
                             };
    [attStr addAttributes:attDic range:NSMakeRange((totalStr.length - str2.length), str2.length)];
    return attStr;
}

//给view添加指定圆角
-(void)cutCornerradiusWithView:(UIView *)view
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(view.bounds.size.height/2, view.bounds.size.height/2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark ----- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.adDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (collectionView == self.adCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADCellID" forIndexPath:indexPath];
        if (cell.contentView.subviews.count) {
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
        }
        UIImageView *adImg = [UIImageView new];
        [cell.contentView addSubview:adImg];
        adImg.sd_layout
        .leftEqualToView(cell.contentView)
        .topEqualToView(cell.contentView)
        .rightEqualToView(cell.contentView)
        .bottomEqualToView(cell.contentView)
        ;
        adImg.image = UIImageNamed(self.adDatasource[indexPath.row]);
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mainDatasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainDatasource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"MineCell"];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        cell.textLabel.textColor = RGBA(50, 50, 50, 1);
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        cell.detailTextLabel.textColor = RGBA(152, 152, 152, 1);
    }
    NSDictionary *model = self.mainDatasource[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.attributedText = [self leadString:GetSaveString(model[@"title"]) tailString:@" ·" font:Font(25) color:RGBA(248, 52, 52, 1)  lineBreak:NO];
    }else{
        cell.textLabel.text = GetSaveString(model[@"title"]);
    }
    
    cell.detailTextLabel.text = GetSaveString(model[@"rightTitle"]);
    
    cell.imageView.image = UIImageNamed(GetSaveString(model[@"img"]));
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSArray *section = self.mainDatasource[indexPath.section];
        NSString *title = GetSaveString(section[indexPath.row][@"title"]);
        if (CompareString(title, @"设置")) {
            SettingViewController *stVC = [SettingViewController new];
            [self.navigationController pushViewController:stVC animated:YES];
        }else if (CompareString(title, @"历史")){
            BrowsingHistoryVC *bhVC = [BrowsingHistoryVC new];
            [self.navigationController pushViewController:bhVC animated:YES];
        }
        
    }
    
}




@end
