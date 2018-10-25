//
//  ChangeAttentionViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//


#import "ChangeAttentionViewController.h"
#import "ChangeAttentionCell.h"
#import "ChangeAttentionReusableView.h"

@interface ChangeAttentionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ChangeAttentionViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *sectionTitle = @[
                                  @"酒店常客",
                                  @"航空常客",
                                  @"信用卡",
                                  @"飞客生活",
                                  @"网站服务",
                                  ];
        NSArray *logo = @[
                          @"share_qq",
                          @"share_qqZone",
                          @"share_sina",
                          @"share_wechat",
                          @"share_wechatFriend",
                          ];
        NSArray *name = @[
                          @"飞行Report",
                          @"东方航空",
                          @"中国国航",
                          @"南方航空",
                          @"海南航空",
                          @"吉祥航空",
                          @"亚洲万里通",
                          @"星空联盟",
                          @"寰宇一家",
                          ];
        
        for (int i = 0; i < arc4random()%4+1; i ++) {
            NSMutableDictionary *sectionDic = [NSMutableDictionary new];
            sectionDic[@"sectionName"] = sectionTitle[arc4random()%sectionTitle.count];
            sectionDic[@"sectionNum"] = @(arc4random()/30+5);
            
            NSMutableArray *dataArr = [NSMutableArray new];
            sectionDic[@"data"] = dataArr;
            for (int j = 0; j < arc4random()%10+3; j++) {
                NSMutableDictionary *model = [NSMutableDictionary new];
                model[@"name"] = name[arc4random()%name.count];
                model[@"logo"] = logo[arc4random()%logo.count];
                model[@"attention"] = @(arc4random()%2);
                [dataArr addObject:model];
            }
            
            [_dataSource addObject:sectionDic];
        }
    }
    return _dataSource;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        NSInteger numPerRow = 4;
        CGFloat itemW = (ScreenW - (numPerRow - 1)*10)/numPerRow;
        CGFloat itemH = 80;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.sd_layout
        .leftEqualToView(self.view)
        .topEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        ;
        [_collectionView updateLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        //注册
        [_collectionView registerClass:[ChangeAttentionCell class] forCellWithReuseIdentifier:ChangeAttentionCellID];
        
        [_collectionView registerClass:[ChangeAttentionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChangeAttentionReusableViewID];
        [_collectionView registerClass:[ChangeAttentionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChangeAttentionReusableViewID];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"版块推荐";
    [self addNavigationView];
    [self setUI];
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(finishSelect) title:@"完成"];
}

-(void)setUI
{
    self.collectionView.backgroundColor = WhiteColor;
}

//完成选择
-(void)finishSelect
{
    LRToast(@"完成选择");
}

#pragma makr --- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *sectionDic = self.dataSource[section];
    NSArray *dataArr = sectionDic[@"data"];
    return dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChangeAttentionCellID forIndexPath:indexPath];
    NSDictionary *sectionDic = self.dataSource[indexPath.section];
    NSArray *dataArr = sectionDic[@"data"];
    NSDictionary *model = dataArr[indexPath.row];
    [cell setData:model];
    return cell;
}

//header/footer
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    NSDictionary *sectionDic = self.dataSource[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader){
        ChangeAttentionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChangeAttentionReusableViewID forIndexPath:indexPath];
        NSDictionary *data = @{
                               @"name"  :sectionDic[@"sectionName"],
                               @"num"   :@([sectionDic[@"sectionNum"] integerValue]),
                               };
        [headerView setData:data];
        reusableview = headerView;
    }else{
        ChangeAttentionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChangeAttentionReusableViewID forIndexPath:indexPath];
        [footerView setData:@{}];
        footerView.backgroundColor = BACKGROUND_COLOR;
        reusableview = footerView;
    }
    
    return reusableview;
}

//头高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenW, 40);
}

//尾高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(ScreenW, 15);
}

//点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGLog(@"点击了%ld区第%ld个item",indexPath.section,indexPath.row);
    NSDictionary *sectionDic = self.dataSource[indexPath.section];
    NSArray *dataArr = sectionDic[@"data"];
    NSMutableDictionary *model = dataArr[indexPath.row];
    model[@"attention"] = @(![model[@"attention"] intValue]);
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

@end
