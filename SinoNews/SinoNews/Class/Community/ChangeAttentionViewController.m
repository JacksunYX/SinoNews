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
//保存选中版块的数组
@property (nonatomic,strong) NSMutableArray *selectSection;
@property (nonatomic,strong) NSArray *localSections;

@end

@implementation ChangeAttentionViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        /*
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
         sectionDic[@"haveUnFold"] = @(0);
         
         NSMutableArray *dataArr = [NSMutableArray new];
         sectionDic[@"data"] = dataArr;
         for (int j = 0; j < arc4random()%10+8; j++) {
         NSMutableDictionary *model = [NSMutableDictionary new];
         model[@"name"] = name[arc4random()%name.count];
         model[@"logo"] = logo[arc4random()%logo.count];
         model[@"attention"] = @(arc4random()%2);
         [dataArr addObject:model];
         }
         
         [_dataSource addObject:sectionDic];
         }
         */
    }
    return _dataSource;
}

-(NSMutableArray *)selectSection
{
    if (!_selectSection) {
        _selectSection = [NSMutableArray new];
    }
    return _selectSection;
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
    self.navigationItem.title = @"全部版块";
    [self addNavigationView];
    
    [self requestListAllSection];
}

//修改导航栏显示
-(void)addNavigationView
{
    
    //设置导航栏标题颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexColor(#FFFFFF), NSFontAttributeName:PFFontR(16)}];
    //设置导航栏背景色
    self.navigationController.navigationBar.barTintColor = HexColor(#1282EE);
    //设置导航栏按钮的字体颜色
    self.navigationController.navigationBar.tintColor = HexColor(#FFFFFF);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(finishSelect) title:@"完成" font:PFFontR(14) titleColor:HexColor(#FFFFFF) highlightedColor:HexColor(#FFFFFF) titleEdgeInsets:UIEdgeInsetsZero];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:UIImageNamed(@"section_close") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

-(void)setUI
{
    self.collectionView.backgroundColor = WhiteColor;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//比对本地保存的关注版块与服务器返回的
-(void)compareLocalSectionsWithServer
{
    _localSections = [MainSectionModel getLocalAttentionSections];
    if (!kArrayIsEmpty(_localSections)) {
        //数组不为空时比对
        for (int i = 0; i < self.dataSource.count; i ++) {
            MainSectionModel *model1 = self.dataSource[i];
            for (int j = 0; j < model1.subSections.count; j ++) {
                MainSectionModel *model2 = model1.subSections[j];
                //在本地数组中找出相同id和名称的
                for (MainSectionModel *model3 in _localSections) {
                    if ([model3.name isEqualToString:model2.name]) {
                        model2.isAttentioned = YES;
                        [self.selectSection addObject:model2];
                        break;
                    }
                }
            }
        }
    }
}

//完成选择
-(void)finishSelect
{
    //再添加(这里相当于直接覆盖了，所以不需要清除)
    if (self.selectSection.count>0) {
        [MainSectionModel addMutilNews:self.selectSection];
    }else{
        [MainSectionModel removeAllSections];
    }
    
    if (self.changeFinishBlock) {
        self.changeFinishBlock(self.selectSection);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma makr --- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MainSectionModel *model = self.dataSource[section];
    
    if (model.subSections.count>8) {
        if (model.haveUnFold == NO) {
            return 8;
        }
    }
    return model.subSections.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChangeAttentionCellID forIndexPath:indexPath];
    MainSectionModel *model = self.dataSource[indexPath.section];
    MainSectionModel *model2 = model.subSections[indexPath.row];
    cell.model = model2;
    return cell;
}

//header/footer
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    MainSectionModel *model = self.dataSource[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader){
        ChangeAttentionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChangeAttentionReusableViewID forIndexPath:indexPath];
        NSDictionary *data = @{
                               @"name":model.name,
                           @"num":@(model.subSections.count),
                               };
        [headerView setData:data];
        reusableview = headerView;
    }else{
        ChangeAttentionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChangeAttentionReusableViewID forIndexPath:indexPath];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        if (model.subSections.count>8) {
            dic[@"unFold"] = @(model.haveUnFold);
        }
        
        [footerView setData:dic];
        @weakify(self);
        footerView.checkMoreBlock = ^{
            @strongify(self);
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
            model.haveUnFold = YES;
            [self.collectionView reloadSections:set];
        };
        footerView.backgroundColor = BACKGROUND_COLOR;
        reusableview = footerView;
    }
    
    return reusableview;
}

//头高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenW, 53);
}

//尾高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    MainSectionModel *model = self.dataSource[section];
    
    if (model.subSections.count>8) {
        if (model.haveUnFold == NO) {
            return CGSizeMake(ScreenW, 44);
        }
    }
    return CGSizeMake(ScreenW, 10);
}

//点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GGLog(@"点击了%ld区第%ld个item",indexPath.section,indexPath.row);
    MainSectionModel *model = self.dataSource[indexPath.section];
    MainSectionModel *model2 = model.subSections[indexPath.row];
    
    model2.isAttentioned = !model2.isAttentioned;
    if (model2.isAttentioned) {
        [self.selectSection addObject:model2];
    }else{
        for (MainSectionModel *model3 in self.selectSection) {
            if ([model3.name isEqualToString:model2.name]) {
                //移除
                [self.selectSection removeObject:model3];
                break;
            }
        }
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

#pragma mark --请求
//请求全部版块数据
-(void)requestListAllSection
{
    [HttpRequest getWithURLString:ListAllSections parameters:nil success:^(id responseObject) {
        
        NSArray *listArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (listArr.count > 0) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:listArr];
            [self compareLocalSectionsWithServer];
            [self setUI];
        }
        
    } failure:nil];
}


@end
