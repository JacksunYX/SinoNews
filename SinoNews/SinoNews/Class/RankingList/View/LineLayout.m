//
//  LineLayout.m
//  CollectionView-LineLayout
//
//  Created by Kobe24 on 2018/1/2.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "LineLayout.h"


#define ItemSize 250
#define LineSpacing 15
@implementation LineLayout

- (instancetype)init{
    if (self = [super init]) {
        //        self.itemSize = CGSizeMake(80, ItemSize);
//        self.itemSize = CGSizeMake(ScreenW - 80, 50);
//        self.minimumLineSpacing = LineSpacing;
        //速率
//        self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        //水平方向
        //        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    }
    return self;
}

//返回滚动停止的点 自动对齐中心
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGFloat  offSetAdjustment = MAXFLOAT;
    
    CGFloat center = 0;
    CGRect targetRect = CGRectZero;
    
    //预期停止中心点
    //预期滚动停止时的屏幕区域
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        center = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
        targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }else{
        center = proposedContentOffset.y;
        targetRect = CGRectMake(0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    
    //找出最接近中心点的item
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes * attributes in array) {
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            CGFloat currentCenterX = attributes.center.x;
            
            if (ABS(currentCenterX - center) < ABS(offSetAdjustment)) {
                offSetAdjustment = currentCenterX - center;
            }
            
        }else{
            CGFloat currentCenterY = attributes.frame.origin.y;
            
            if (ABS(currentCenterY - center) < ABS(offSetAdjustment)) {
                offSetAdjustment = currentCenterY - center;
            }
        }
        
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return CGPointMake(proposedContentOffset.x + offSetAdjustment, proposedContentOffset.y);
    }
    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offSetAdjustment);
}

//返回布局大小
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes * attributes in array) {
        //判断相交
        if (CGRectIntersectsRect(visibleRect, rect)) {
            //当前视图中心点 距离item中心点距离
            CGFloat  distance = 0;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                distance  =  CGRectGetMidX(self.collectionView.bounds) - attributes.center.x;
                
            }else{
                distance  =  CGRectGetMinY(self.collectionView.bounds) - attributes.frame.origin.y;
                
            }
            CGFloat  normalizedDistance = distance / (WIDTH_SCALE * 120);
            if (ABS(distance) <= WIDTH_SCALE * 120) {
                CGFloat zoom = 1 + 0.5 * (1 - ABS(normalizedDistance));
//                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1);
                attributes.zIndex = 1;
                //改成2d的，只对高度进行缩放
                attributes.transform = CGAffineTransformMakeScale(1, zoom);
            }
            
        }
    }
    
    return array;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
