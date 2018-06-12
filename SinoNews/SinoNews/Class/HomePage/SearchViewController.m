//
//  SearchViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHeadReusableView.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL showNewsList;      //展示相关咨询列表
    BOOL showRecommand;     //展示推荐关键词列表
    BOOL showRelatedSearch; //展示相关搜索关键词列表
}

@property (nonatomic, strong) UISearchBar *searchBar;
//资讯展示tableview
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *newsArr;    //资讯数组
//推荐关键词视图
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *recommandArr;    //推荐关键词数组
//搜索关键词列表
@property (nonatomic,strong) BaseTableView *keyTableView;
@property (nonatomic,strong) NSMutableArray *keyArr;    //关键词数组

//最热和精选
@property (nonatomic,strong) NSMutableArray *hotNews;
@property (nonatomic,strong) NSMutableArray *choicenessNews;


@end

@implementation SearchViewController
#pragma mark --- 懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [self.view addSubview:_collectionView];
        _collectionView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
        
//        [_collectionView activateConstraints:^{
//            self.collectionView.top_attr = self.view.top_attr_safe;
//            self.collectionView.left_attr = self.view.left_attr_safe;
//            self.collectionView.right_attr = self.view.right_attr_safe;
//            self.collectionView.bottom_attr = self.view.bottom_attr_safe;
//        }];
        //注册
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [_collectionView registerClass:[SearchHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
        
        _collectionView.hidden = YES;
    }
    return _collectionView;
}

-(BaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //注册
        [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
        [_tableView registerClass:[HomePageSecondKindCell class] forCellReuseIdentifier:HomePageSecondKindCellID];
        [_tableView registerClass:[HomePageThirdKindCell class] forCellReuseIdentifier:HomePageThirdKindCellID];
        
        _tableView.hidden = YES;

    }
    return _tableView;
}

-(BaseTableView *)keyTableView
{
    if (!_keyTableView) {
        _keyTableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_keyTableView];
        _keyTableView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
        
        _keyTableView.dataSource = self;
        _keyTableView.delegate = self;
        //注册
        [_keyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"KeyCellID"];
        
        _keyTableView.hidden = YES;
        
    }
    return _keyTableView;
}

-(NSMutableArray *)hotNews
{
    if (!_hotNews) {
        _hotNews = [NSMutableArray new];
        [_hotNews addObjectsFromArray:@[
                                        @"蒙冤者申请赔偿",
                                        @"韩国记者赶赴报道",
                                        @"扎克伯格欧洲作证",
                                        @"富士康今日申购",
                                        @"富士康今日申购asdas",
                                        @"扎克伯格欧洲作证aqwdf",
                                        @"测试测试测试测试测试测试测试测试",
                                        @"韩国记者赶赴报道韩国记者赶赴报道",
                                        ]];
    }
    return _hotNews;
}

-(NSMutableArray *)choicenessNews
{
    if (!_choicenessNews) {
        _choicenessNews = [NSMutableArray new];
        [_choicenessNews addObjectsFromArray:@[
                                               @"富士康今日申购asdas",
                                               @"扎克伯格欧洲作证aqwdf",
                                               @"测试测试测试测试测试测试测试测试",
                                               @"韩国记者赶赴报道韩国记者赶赴报道",
                                               ]];
    }
    return _choicenessNews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    
    [self addNavigationView];
    
    self.collectionView.backgroundColor = WhiteColor;
    self.tableView.backgroundColor = WhiteColor;
    self.keyTableView.backgroundColor = WhiteColor;
    
    [self showWithStatus:3];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    tap.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 34)];
    
    self.searchBar.placeholder = @"热门搜索";
    
    for (UIView *view in self.searchBar.subviews.lastObject.subviews) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)view;
            //设置输入框的背景颜色
            textField.clipsToBounds = YES;
            textField.backgroundColor = HexColor(#EEEEEE);
            //设置输入框边框的圆角以及颜色
            textField.layer.cornerRadius = 17.0f;
            textField.layer.borderColor = HexColor(#EEEEEE).CGColor;
            textField.layer.borderWidth = 1;
            //设置输入字体颜色
            textField.textColor = BlueColor;
            //设置默认文字颜色
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 热门搜索" attributes:@{NSForegroundColorAttributeName:HexColor(#AEAEAE)}];
            
        }
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            //            UIButton *cancel = (UIButton *)view;
            //            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            
        }
    }
    
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(popAction:) image:@"saerchClose" hightimage:nil andTitle:@""];
}

-(void)popAction:(UIButton *)rightBtn
{
    [self.navigationController popViewControllerAnimated:NO];
}

//1.只显示资讯列表 2.只显示搜索的相关关键词 3.只显示推荐关键词
-(void)showWithStatus:(NSInteger)status
{
    switch (status) {
        case 1:
        {
            self.tableView.hidden = NO;
            self.collectionView.hidden = YES;
            self.keyTableView.hidden = YES;
        }
            break;
        case 2:
        {
            self.tableView.hidden = YES;
            self.collectionView.hidden = YES;
            self.keyTableView.hidden = NO;
        }
            break;
        case 3:
        {
            self.tableView.hidden = YES;
            self.collectionView.hidden = NO;
            self.keyTableView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---- UICollectionViewDataSource \ UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotNews.count;
    }
    return self.choicenessNews.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell.contentView.subviews.count) {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = Font(15);
    [cell.contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(cell.contentView, 10)
    .centerYEqualToView(cell.contentView)
    .autoHeightRatio(0)
    ;
    [titleLabel setMaxNumberOfLinesToShow:1];
    
    if (indexPath.section == 0) {
        [titleLabel setSingleLineAutoResizeWithMaxWidth:(ScreenW - 20)/2];
        titleLabel.text = self.hotNews[indexPath.row];
        //分割线
        UIView *line = [UIView new];
        line.backgroundColor = RGB(227, 227, 227);
        [cell.contentView addSubview:line];
        line.sd_layout
        .leftEqualToView(titleLabel)
        .rightSpaceToView(cell.contentView, 10)
        .bottomEqualToView(cell.contentView)
        .heightIs(1)
        ;
    }else{
        [titleLabel setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
        titleLabel.text = self.choicenessNews[indexPath.row];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((ScreenW - 10)/2, 34);
    }
    return CGSizeMake(ScreenW, 34);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenW, 54);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SearchHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        
        if (headView.subviews.count) {
            for (UIView *subview in headView.subviews) {
                [subview removeFromSuperview];
            }
        }
        
        UIImageView *img = [UIImageView new];
        UILabel *sectionTitle = [UILabel new];
        sectionTitle.font = Font(16);
        
        [headView sd_addSubviews:@[
                                   img,
                                   sectionTitle,
                                   ]];
        img.sd_layout
        .leftSpaceToView(headView, 10)
        .centerYEqualToView(headView)
        .widthIs(19)
        .heightEqualToWidth()
        ;
        
        sectionTitle.sd_layout
        .leftSpaceToView(img, 5)
        .centerYEqualToView(img)
        .autoHeightRatio(0)
        ;
        [sectionTitle setSingleLineAutoResizeWithMaxWidth:200];
        if (indexPath.section == 0) {
            sectionTitle.text = @"今日热点";
            img.image = UIImageNamed(@"searchHot");
        }else{
            sectionTitle.text = @"精选咨询";
            img.image = UIImageNamed(@"saerchChoiceness");
        }
        
        return headView;
    }
    return nil;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGLog(@"点击了第%ld条",indexPath.row);
    [self.searchBar resignFirstResponder];
    if (indexPath.section == 0) {
        self.searchBar.text = self.hotNews[indexPath.row];
    }else{
        self.searchBar.text = self.choicenessNews[indexPath.row];
    }
    
    [self showWithStatus:1];
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    [self.searchBar resignFirstResponder];
}

#pragma mark ---- UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    GGLog(@"开始获取后台搜索关键词:%@",searchText);
    if ([GetSaveString(searchText) isEqualToString:@""]) {
        [self showWithStatus:3];
    }else{
        //相关关键词
        [self showWithStatus:2];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    //搜索关键词
    [self showWithStatus:1];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self showWithStatus:3];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 5;
    }
    if (tableView == self.keyTableView) {
        return 10;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.tableView) {
        if (indexPath.row == 0) {
            HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
            cell = (UITableViewCell *)cell1;
        }else if (indexPath.row == 1) {
            HomePageSecondKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
            cell = (UITableViewCell *)cell2;
        }else{
            HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
            cell = (UITableViewCell *)cell3;
        }
    }else if (tableView == self.keyTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:@"KeyCellID"];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld条相关关键词",indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.row == 0) {
            return HomePageFirstKindCellH;
        }
        
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
        
    }else if (tableView == self.keyTableView){
        return 34;
    }
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    [self showWithStatus:1];
}

@end
