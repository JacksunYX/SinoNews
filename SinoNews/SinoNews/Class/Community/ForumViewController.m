//
//  ForumViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumViewController.h"
#import "ChangeAttentionViewController.h"
#import "CommunitySearchVC.h"

#import "ForumLeftTableViewCell.h"
#import "ForumRightTableViewCell.h"

@interface ForumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BaseTableView *leftTable;
@property (nonatomic,strong) BaseTableView *rightTable;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger leftSelectedIndex;
@end

@implementation ForumViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        //虚拟数据
        NSMutableArray *arr1 = @[
                                 @"我的关注",
                                 @"酒店常驻",
                                 @"航空常客",
                                 @"信用卡",
                                 @"飞客生活",
                                 @"网站服务",
                                 ].mutableCopy;
        [_dataSource addObject:arr1];
        
        NSMutableArray *arr2 = [NSMutableArray new];
        
        NSMutableArray *logo = @[
                                 @"share_qq",
                                 @"share_qqZone",
                                 @"share_sina",
                                 @"share_wechat",
                                 @"share_wechatFriend",
                                 ].mutableCopy;
        NSMutableArray *communityName = @[
                                          @"飞行Report",
                                          @"东方航空",
                                          @"中国国航",
                                          @"南方航空",
                                          @"海南航空",
                                          @"吉祥航空",
                                          @"亚洲万里通",
                                          @"星空联盟",
                                          @"寰宇一家",
                                          ].mutableCopy;
        for (int i = 0; i < arr1.count; i ++) {
            NSMutableArray *arr3 = [NSMutableArray new];
            NSInteger arr2Count = arc4random()%10 + 10;
            for (int j = 0; j < arr2Count; j++) {
                NSMutableDictionary *model = [NSMutableDictionary new];
                model[@"logo"] = logo[arc4random()%(logo.count)];
                model[@"communityName"] = communityName[arc4random()%(communityName.count)];
                //                if (i == 0) {
                //                    break;
                //                }
                [arr3 addObject:model];
            }
            [arr2 addObject:arr3];
        }
        
        [_dataSource addObject:arr2];
    }
    return _dataSource;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        [self.view addSubview:_bottomView];
        _bottomView.sd_layout
        .rightEqualToView(self.view)
        .heightIs(0)
        .bottomEqualToView(self.view)
        .widthIs(ScreenW*0.7)
        ;
        
        //添加控价
        UILabel *attentionMore = [UILabel new];
        attentionMore.textAlignment = NSTextAlignmentCenter;
        attentionMore.font = PFFontL(14);
        attentionMore.textColor = HexColor(#1282EE);
        [_bottomView addSubview:attentionMore];
        attentionMore.sd_layout
        .heightIs(14)
        .leftEqualToView(_bottomView)
        .rightEqualToView(_bottomView)
        .centerYEqualToView(_bottomView)
        ;
        attentionMore.text = @"关注更多 >";
        
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"版块";
    
    [self addNavigationView];
    
    [self setUI];
    
    [self setBottomView];
}

//修改导航栏显示
-(void)addNavigationView
{
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        NSString *leftImg = @"return_left";
        NSString *rightImg = @"attention_search";
        if (UserGetBool(@"NightMode")) {
            leftImg = [leftImg stringByAppendingString:@"_night"];
            rightImg = [rightImg stringByAppendingString:@"_night"];
        }
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:leftImg]];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(rightImg)];
    });
    
}

-(void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)searchAction
{
    PYSearchViewController *sVC = [PYSearchViewController searchViewControllerWithHotSearches:@[@"12312",@"adasldjl",@"sld;."] searchBarPlaceholder:@"启世录快速通道" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
        searchViewController.searchResultController = [CommunitySearchVC new];
    }];
    sVC.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    sVC.hotSearchStyle = PYHotSearchStyleRankTag;
    sVC.searchHistoryTitle = @"历史搜索";
    sVC.searchBarBackgroundColor = HexColor(#F3F5F4);
    sVC.searchBarCornerRadius = 4;
    [sVC.cancelButton setBtnFont:PFFontL(14)];
    [sVC.cancelButton setNormalTitleColor:HexColor(#161A24)];
    
    //修改搜索框
    //取出输入框
    UIView *searchTextField = nil;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        searchTextField = [sVC.searchBar valueForKey:@"_searchField"];
    }else{
        for (UIView *subView in sVC.searchBar.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchTextField = subView;
                break;
            }
        }
    }
    if (searchTextField) {
//        searchTextField.backgroundColor = [UIColor colorFromHexString:@"#27dcfb"];
//        searchTextField.layer.masksToBounds = YES;
//        searchTextField.layer.cornerRadius = 3.0f;
//        searchTextField.layer.borderColor = [UIColor whiteColor].CGColor;
//        searchTextField.layer.borderWidth = 0.5;
//        ((UITextField *)searchTextField).textColor = [UIColor whiteColor];
        //备注文字颜色
        [((UITextField *)searchTextField) setValue:HexColor(#939393) forKeyPath:@"_placeholderLabel.textColor"];
    }
    //修改输入框左边的搜索图标
    [sVC.searchBar setImage:UIImageNamed(@"attention_search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //修改输入框右边的清除图标
//    [sVC.searchBar setImage:UIImageNamed(@"") forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    // 3. present the searchViewController
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:sVC];
    [self presentViewController:nav animated:NO completion:nil];
}

-(void)setUI
{
    _leftTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _leftTable.backgroundColor = HexColor(#EEEEEE);
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.showsVerticalScrollIndicator = NO;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _leftTable.separatorColor = CutLineColor;
    [self.view addSubview:_leftTable];
    _leftTable.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .widthIs(ScreenW *0.3)
    ;
    [_leftTable updateLayout];
    [_leftTable registerClass:[ForumLeftTableViewCell class] forCellReuseIdentifier:ForumLeftTableViewCellID];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.bottomView.backgroundColor = WhiteColor;
    @weakify(self);
    [self.bottomView whenTap:^{
        @strongify(self);
        ChangeAttentionViewController *vc = [ChangeAttentionViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    _rightTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _rightTable.backgroundColor = WhiteColor;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.showsVerticalScrollIndicator = NO;
    _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightTable];
    _rightTable.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(_leftTable, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.bottomView, 0)
    ;
    [_rightTable updateLayout];
    [_rightTable registerClass:[ForumRightTableViewCell class] forCellReuseIdentifier:ForumRightTableViewCellID];
    
}

//设置关注更多视图
-(void)setBottomView
{
    if (self.leftSelectedIndex == 0) {
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[0];
        CGFloat height = 40;
        if (arr3.count<=0) {
            height = 0;
            self.bottomView.hidden = YES;
        }else{
            self.bottomView.hidden = NO;
        }
        self.bottomView.sd_layout
        .heightIs(height)
        ;
    }else{
        self.bottomView.hidden = YES;
        self.bottomView.sd_layout
        .heightIs(0)
        ;
    }
}

#pragma mark --- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTable) {
        NSMutableArray *arr1 = self.dataSource[0];
        return arr1.count;
    }
    if (tableView == _rightTable) {
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[self.leftSelectedIndex];
        return arr3.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == _leftTable) {
        ForumLeftTableViewCell *cell1 = (ForumLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumLeftTableViewCellID];
        NSMutableArray *arr1 = self.dataSource[0];
        NSString *title = arr1[indexPath.row];
        [cell1 setTitle:title];
        cell = cell1;
    }else if (tableView == _rightTable) {
        ForumRightTableViewCell *cell2 = (ForumRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumRightTableViewCellID];
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[self.leftSelectedIndex];
        NSDictionary *model = arr3[indexPath.row];
        [cell2 setData:model];
        
        cell = cell2;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:_leftTable.frame.size.width tableView:tableView];
    }
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:_rightTable.frame.size.width tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTable) {
        if (arc4random()%2) {
            return 135;
        }
        return 0.01;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _rightTable&&self.leftSelectedIndex == 0) {
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[0];
        if (arr3.count<=0) {
            return 213;
        }
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head;
    if (tableView == _rightTable) {
        head = [[UIView alloc]initWithFrame: CGRectMake(0, 0, _rightTable.frame.size.width, 135)];
        UIImageView *ADImage = [UIImageView new];
        [head addSubview:ADImage];
        ADImage.sd_layout
        .topSpaceToView(head, 10)
        .leftSpaceToView(head, 10)
        .rightSpaceToView(head, 10)
        .bottomSpaceToView(head, 10)
        ;
        NSString *imageStr = [NSString stringWithFormat:@"gameAd_%d",arc4random()%3];
        ADImage.image = UIImageNamed(imageStr);
        [ADImage whenTap:^{
            GGLog(@"点击了%ld区的广告",(long)self.leftSelectedIndex);
        }];
    }
    
    return head;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (tableView == _rightTable&&self.leftSelectedIndex == 0){
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[0];
        if (arr3.count<=0) {
            footView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, _rightTable.frame.size.width, 213)];
            UIImageView *addImg = [UIImageView new];
            UILabel *noticeLabel = [UILabel new];
            noticeLabel.font = PFFontL(14);
            noticeLabel.textColor = HexColor(#A8A8A8);
            [footView sd_addSubviews:@[
                                       addImg,
                                       noticeLabel,
                                       ]];
            addImg.sd_layout
            .topSpaceToView(footView, 74)
            .centerXEqualToView(footView)
            .widthIs(81)
            .heightEqualToWidth()
            ;
            addImg.image = UIImageNamed(@"section_add");
            @weakify(self);
            [addImg whenTap:^{
                @strongify(self);
                ChangeAttentionViewController *vc = [ChangeAttentionViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            noticeLabel.sd_layout
            .topSpaceToView(addImg, 34)
            .centerXEqualToView(footView)
            .heightIs(16)
            ;
            [noticeLabel setSingleLineAutoResizeWithMaxWidth:_rightTable.frame.size.width - 20];
            noticeLabel.text = @"添加感兴趣的版块";
        }
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        if (self.leftSelectedIndex == indexPath.row) {
            return;
        }
        self.leftSelectedIndex = indexPath.row;
        [_rightTable reloadData];
        [self setBottomView];
    }else if (tableView == _rightTable) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[self.leftSelectedIndex];
        NSDictionary *model = arr3[indexPath.row];
    }
}

@end
