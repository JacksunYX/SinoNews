//
//  AttentionViewController.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#define KCellSpace 5

#import "AttentionCollectionView.h"

@interface AttentionCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _offer;
    CGFloat KCellWidth;
    CGFloat KCellHeight;
    
}

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation AttentionCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    KCellWidth = frame.size.width - 20;
    KCellHeight = frame.size.height;
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(KCellWidth, KCellHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = BACKGROUND_COLOR;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self addSubview:_collectionView];
    }
    return self;
}

//注册
-(void)registerViewClass:(id)view ID:(NSString *)identifier
{
    [self.collectionView registerClass:[view class] forCellWithReuseIdentifier:identifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(numberOfItemsInSection)]) {
        return [self.delegate numberOfItemsInSection];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if ([self.delegate respondsToSelector:@selector(returnCollectionCellForIndexPath:collectionView:)]) {
        cell = [self.delegate returnCollectionCellForIndexPath:indexPath collectionView:collectionView];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelected:)]) {
        [self.delegate didSelected:indexPath];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    NSLog(@"结束滚动动画");
    _offer = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //    NSLog(@"开始减速");
    
    if (scrollView.contentOffset.x == _offer) {
        return;
    }else if (scrollView.contentOffset.x > _offer) {
        
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - KCellSpace/2)+1;
        
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }else{
        
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - KCellSpace/2)+1;
        
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i-1 inSection:0];
        
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"结束拖拽");
    
    if (scrollView.contentOffset.x == _offer) {
        return;
    }else if (scrollView.contentOffset.x > _offer) {
        
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - KCellSpace/2)+1;
        
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }else{
        
        int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - KCellSpace/2)+1;
        i = (i - 1)<0?0:(i - 1);
        NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
        
        [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
    
}





@end
