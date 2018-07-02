//
//  SearchViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHeadReusableView.h"

#import "NewsDetailViewController.h"
#import "TopicViewController.h"
#import "PayNewsViewController.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"
#import "HomePageFourthCell.h"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL showNewsList;      //展示相关咨询列表
    BOOL showRecommand;     //展示推荐关键词列表
    BOOL showRelatedSearch; //展示相关搜索关键词列表
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextField *searchField;
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
        [_tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
        
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
//        [_hotNews addObjectsFromArray:@[
//                                        @"蒙冤者申请赔偿",
//                                        @"韩国记者赶赴报道",
//                                        @"扎克伯格欧洲作证",
//                                        @"富士康今日申购",
//                                        @"富士康今日申购asdas",
//                                        @"扎克伯格欧洲作证aqwdf",
//                                        @"测试测试测试测试测试测试测试测试",
//                                        @"韩国记者赶赴报道韩国记者赶赴报道",
//                                        ]];
    }
    return _hotNews;
}

-(NSMutableArray *)choicenessNews
{
    if (!_choicenessNews) {
        _choicenessNews = [NSMutableArray new];
//        [_choicenessNews addObjectsFromArray:@[
//                                               @"富士康今日申购asdas",
//                                               @"扎克伯格欧洲作证aqwdf",
//                                               @"测试测试测试测试测试测试测试测试",
//                                               @"韩国记者赶赴报道韩国记者赶赴报道",
//                                               ]];
    }
    return _choicenessNews;
}

-(NSMutableArray *)keyArr
{
    if (!_keyArr) {
        _keyArr = [NSMutableArray new];
    }
    return _keyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    
    [self addNavigationView];
    
    self.collectionView.backgroundColor = WhiteColor;
    self.tableView.backgroundColor = WhiteColor;
    self.keyTableView.backgroundColor = WhiteColor;
    
    [self requsetNewsKeys];
    
    [self showWithStatus:3];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    tap.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:tap];
    
    [self getSearchField];
}

//获取搜索框里的输入框
-(void)getSearchField
{
    for (UIView *view in self.searchBar.subviews.lastObject.subviews) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)view;
            //设置输入框的背景颜色
            textField.clipsToBounds = YES;
            textField.backgroundColor = HexColor(#EEEEEE);
            //设置输入框边框的圆角以及颜色
            textField.layer.cornerRadius = 17.0f;
//            textField.layer.borderColor = HexColor(#EEEEEE).CGColor;
//            textField.layer.borderWidth = 1;
            //设置输入字体颜色
//            textField.textColor = BlueColor;
            //设置默认文字颜色
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 热门搜索" attributes:@{
                                                                                                                    NSForegroundColorAttributeName:HexColor(#AEAEAE),
                                                                                                                    NSFontAttributeName:Font(13),
                                                                                                                    }];
            self.searchField = textField;
        }
    }
    //加入输入监听(注意，如果信号没有被订阅，则会提示警告⚠️)
    //先判断是否全是空格
    //上次的值与本次的值不能相同
    //节流1秒
    //发送请求
    //切入主线程
    //更新UI
    @weakify(self)
    [[[[[[self.searchField.rac_textSignal filter:^BOOL(NSString *text) {
        return ![NSString isEmpty:text];
    }] distinctUntilChanged] throttle:1.0] flattenMap:^__kindof RACSignal * _Nullable(NSString *text) {
        @strongify(self)
        return [self signalForSearchWithText:text];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.keyArr = x[@"data"];
        [self reloadViews];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300 * ScaleW, 34)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
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

//刷新界面
-(void)reloadViews
{
    if (!self.keyTableView.hidden) {
        [self.keyTableView reloadData];
    }
    if (!self.tableView.hidden) {
        [self.tableView reloadData];
    }
    if (!self.collectionView.hidden) {
        [self.collectionView reloadData];
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
    .rightSpaceToView(cell.contentView, 10)
    .centerYEqualToView(cell.contentView)
    .heightIs(34)
    ;
    
    if (indexPath.section == 0) {
//        [titleLabel setSingleLineAutoResizeWithMaxWidth:(ScreenW - 20)/2];
        titleLabel.text = self.hotNews[indexPath.row];
        //分割线
        UIView *line = [UIView new];
        line.backgroundColor = RGB(227, 227, 227);
        [cell.contentView addSubview:line];
        line.sd_layout
        .leftSpaceToView(cell.contentView, 10)
        .rightSpaceToView(cell.contentView, 10)
        .bottomEqualToView(cell.contentView)
        .heightIs(1)
        ;
    }else{
//        [titleLabel setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
        titleLabel.text = self.choicenessNews[indexPath.row];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((ScreenW - 1)/2, 34);
    }
    return CGSizeMake(ScreenW, 34);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ((section ==0 && self.hotNews.count)||(section ==1 && self.choicenessNews.count)) {
        return CGSizeMake(ScreenW, 54);
    }
    
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
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
    [self showWithStatus:1];
    if (indexPath.section == 0) {
        self.searchBar.text = self.hotNews[indexPath.row];
    }else{
        self.searchBar.text = self.choicenessNews[indexPath.row];
    }
    //发送请求
    [self requestSearchNewsListWithText:self.searchBar.text];
    
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    [self.searchBar resignFirstResponder];
}

#pragma mark ---- UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    GGLog(@"开始获取后台搜索关键词:%@",searchText);
    if ([GetSaveString(searchText) isEqualToString:@""]||[NSString isEmpty:GetSaveString(searchText)]) {
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
        return self.newsArr.count;
    }
    if (tableView == self.keyTableView) {
        return self.keyArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.tableView) {
        id model = self.newsArr[indexPath.row];
        if ([model isKindOfClass:[HomePageModel class]]) {
            HomePageModel *model1 = (HomePageModel *)model;
            switch (model1.itemType) {
                case 100:   //无图
                {
                    HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                case 101:   //1图
                {
                    HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                case 103:   //3图
                {
                    HomePageSecondKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                    
                default:
                    break;
            }
            
        }else if ([model isKindOfClass:[TopicModel class]]){
            HomePageFirstKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
            cell2.model = model;
            cell = (UITableViewCell *)cell2;
        }else if ([model isKindOfClass:[ADModel class]]){
            HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
            cell3.model = model;
            cell = (UITableViewCell *)cell3;
        }
    }else if (tableView == self.keyTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:@"KeyCellID"];
        cell.textLabel.text = self.keyArr[indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
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
    if (tableView == self.keyTableView) {
        self.searchBar.text = self.keyArr[indexPath.row];
        //发送请求
        [self requestSearchNewsListWithText:self.searchBar.text];
    }else if (tableView == self.tableView){
        id model = self.newsArr[indexPath.row];
        if ([model isKindOfClass:[HomePageModel class]]) {
            //        NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ////        ndVC.newsId = [(HomePageModel *)model news_id];
            //        ndVC.newsId = 118;
            //        [self.navigationController pushViewController:ndVC animated:YES];
            
            PayNewsViewController *pnVC = [PayNewsViewController new];
            [self.navigationController pushViewController:pnVC animated:YES];
            
        }else if ([model isKindOfClass:[TopicModel class]]){
            TopicViewController *tVC = [TopicViewController new];
            tVC.model = model;
            [self.navigationController pushViewController:tVC animated:YES];
        }else if ([model isKindOfClass:[ADModel class]]){
            
        }
    }
}


#pragma mark ----- 请求发送
//热搜关键字
-(void)requsetNewsKeys
{
    [HttpRequest postWithURLString:News_getNewsKeys parameters:nil isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        
        NSArray *arr = response[@"data"];
        [self.hotNews removeAllObjects];
        for (NSDictionary *dic in arr) {
            NSString *value = dic[@"hotName"];
            [self.hotNews addObject:GetSaveString(value)];
        }
        [self reloadViews];
    } failure:nil RefreshAction:nil];
}

//搜索文章列表
-(void)requestSearchNewsListWithText:(NSString *)text
{
    [HttpRequest getWithURLString:News_listForSearching parameters:@{@"keyword":text} success:^(id responseObject) {
        NSMutableArray *dataArr = [NSMutableArray new];
        for (NSDictionary *dic in responseObject[@"data"]) {
            NSInteger itemType = [dic[@"itemType"] integerValue];
            if (itemType>=100&&itemType<200) {  //新闻
                HomePageModel *model = [HomePageModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }else if (itemType>=200&&itemType<300) {    //专题
                TopicModel *model = [TopicModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }else if (itemType>=300&&itemType<400){     //广告
                ADModel *model = [ADModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }
        }
        self.newsArr = [dataArr mutableCopy];
        [self reloadViews];
    } failure:nil];
}

//搜索补全信号
-(RACSignal *)signalForSearchWithText:(NSString *)text
{
    //创建信号
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HttpRequest getWithURLString:News_autoComplete parameters:@{@"keyword":text} success:^(id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:nil];
        return nil;
    }];
}







@end
