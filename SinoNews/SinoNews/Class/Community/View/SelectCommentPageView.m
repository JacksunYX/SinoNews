//
//  SelectCommentPageView.m
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SelectCommentPageView.h"

@interface SelectCommentPageView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic ,assign) NSInteger totalNum;
@property (nonatomic ,assign) NSInteger selectedIndex;
@property (nonatomic ,strong) UICollectionView *collectionView;
@end

@implementation SelectCommentPageView
static CGFloat anumationTime = 0.3;
-(instancetype)init
{
    if (self == [super init]) {
        _totalNum = 0;
        _selectedIndex = 0;
    }
    return self;
}

-(void)showAllNum:(NSInteger)total defaultSelect:(NSInteger)selectedIndex
{
    _totalNum = total;
    _selectedIndex = selectedIndex;
    
    [self setUI];
    
}

-(void)setUI
{
    self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    self.backgroundColor = kWhite(0.0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = kWhite(0.0);
    [self addSubview:topView];
    topView.sd_layout
    .topEqualToView(self)
    .bottomSpaceToView(self, 0)
    .leftEqualToView(self)
    .rightEqualToView(self)
    ;
    [topView updateLayout];
    
    UIView *mainView = [UIView new];
    mainView.backgroundColor = kWhite(0.0);
    [self addSubview:mainView];
    mainView.sd_layout
    .bottomSpaceToView(self, -200)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(200)
    ;
    [mainView updateLayout];
    
    @weakify(self);
    [topView whenTap:^{
        @strongify(self);
        [UIView animateWithDuration:anumationTime animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        topView.backgroundColor = kWhite(0.82);
        mainView.sd_layout
        .bottomSpaceToView(self, 0)
        ;
        [mainView updateLayout];
    }];
    
    UILabel *topLabel = [UILabel new];
    topLabel.backgroundColor = HexColor(#D6E6F1);
    topLabel.font = PFFontL(15);
    topLabel.textAlignment = NSTextAlignmentCenter;
     
    [mainView addSubview:topLabel];
    topLabel.sd_layout
    .topEqualToView(mainView)
    .leftEqualToView(mainView)
    .rightEqualToView(mainView)
    .heightIs(40)
    ;
    [topLabel updateLayout];
    topLabel.text = @"选择分页";
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    NSInteger numPerRow = 6;
    CGFloat itemW = (ScreenW - (numPerRow+1)*10.0)/numPerRow;
    CGFloat itemH = itemW;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 8, 10, 8);
    self.collectionView.backgroundColor = WhiteColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [mainView addSubview:self.collectionView];
    self.collectionView.sd_layout
    .topSpaceToView(topLabel, 0)
    .leftEqualToView(mainView)
    .rightEqualToView(mainView)
    .bottomEqualToView(mainView)
    ;
    [self.collectionView updateLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
}

#pragma mark --- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalNum;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    UILabel *title = [UILabel new];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = PFFontR(18);
    [cell.contentView addSubview:title];
    title.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0))
    ;
    NSInteger numPerRow = 6;
    CGFloat itemW = (ScreenW - (numPerRow+1)*10.0)/numPerRow;
    title.sd_cornerRadius = @(itemW/2);
    title.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    if (indexPath.row == _selectedIndex) {
        title.backgroundColor = ThemeColor;
        title.textColor = WhiteColor;
    }else{
        title.backgroundColor = WhiteColor;
        title.textColor = BlackColor;
    }
    cell.backgroundColor = WhiteColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [collectionView reloadData];
    if (self.clickBlock) {
        self.clickBlock(indexPath.row);
    }
    [UIView animateWithDuration:anumationTime animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
