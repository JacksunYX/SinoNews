//
//  SearchViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHeadReusableView.h"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic,strong) UICollectionView *collectionView;
//最热和精选
@property (nonatomic,strong) NSMutableArray *hotNews;
@property (nonatomic,strong) NSMutableArray *choicenessNews;
@end

@implementation SearchViewController

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
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
    
    [self addCollectionView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
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
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:UIImageNamed(@"saerchClose") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)popAction:(UIButton *)rightBtn
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)addCollectionView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView activateConstraints:^{
        self.collectionView.top_attr = self.view.top_attr_safe;
        self.collectionView.left_attr = self.view.left_attr_safe;
        self.collectionView.right_attr = self.view.right_attr_safe;
        self.collectionView.bottom_attr = self.view.bottom_attr_safe;
    }];
    //注册
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[SearchHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    
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
    NSLog(@"点击了第%ld条",indexPath.row);
    [self.searchBar resignFirstResponder];
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    [self.searchBar resignFirstResponder];
}

#pragma mark ---- UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"开始获取后台搜索关键词");
}


@end
