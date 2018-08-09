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
//UICollectionView最后去哪里
//参数1:UICollectionView停止滚动那一刻的位置
//参数2:滚动速率
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
//
//    CGFloat offSetAdjustment = MAXFLOAT;
//
//    CGFloat center = 0;
//    CGRect targetRect = CGRectZero;
//
//    //预期停止中心点
//    //预期滚动停止时的屏幕区域
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        center = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
//        targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    }else{
//        center = proposedContentOffset.y;
//        targetRect = CGRectMake(0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    }
//
//    //找出最接近中心点的item
//    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
//    for (UICollectionViewLayoutAttributes * attributes in array) {
//
//        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//            CGFloat currentCenterX = attributes.center.x;
//
//            if (ABS(currentCenterX - center) < ABS(offSetAdjustment)) {
//                offSetAdjustment = currentCenterX - center;
//            }
//
//        }else{
//            CGFloat currentCenterY = attributes.frame.origin.y;
//            CGFloat attrsH = CGRectGetHeight(attributes.frame) ;
//
////            if (ABS(currentCenterY - center) < ABS(offSetAdjustment)) {
////                offSetAdjustment = currentCenterY - center;
////            }
//            if (proposedContentOffset.y - currentCenterY  < attrsH/2) {
//                offSetAdjustment = -(proposedContentOffset.y - currentCenterY);
//            }else{
//                offSetAdjustment = attrsH - (proposedContentOffset.y - currentCenterY);
//            }
//
//            break ;//只循环数组中第一个元素即可，所以直接break了
//        }
//
//    }
//
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        return CGPointMake(proposedContentOffset.x + offSetAdjustment, proposedContentOffset.y);
//    }
//
//    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offSetAdjustment);
//}

//返回布局大小
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];

    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;

    for (UICollectionViewLayoutAttributes * attributes in array) {
        //判断相交,处理当前界面中显示的cell
        if (CGRectIntersectsRect(visibleRect, rect)) {
            //当前视图中心点 距离item中心点距离
            CGFloat  distance = 0;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                distance  =  CGRectGetMidX(self.collectionView.bounds) - attributes.center.x;

            }else{
                distance  =  self.collectionView.contentOffset.y - attributes.frame.origin.y;
                
            }

            //移动的偏移量与cell高度的比例
            CGFloat  normalizedDistance = distance / (WIDTH_SCALE * 120);
            if (ABS(distance) <= WIDTH_SCALE * 120) {
                CGFloat zoom = 1 + 0.5 * (1 - ABS(normalizedDistance));
//                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1);
                attributes.zIndex = 1;
                //改成2d的，只对高度进行缩放
                attributes.transform = CGAffineTransformMakeScale(1, zoom);
//                attributes.frame = CGRectMake(attributes.frame.origin.x, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.height*zoom);
//                lastY = attributes.frame.origin.y;
            }

        }
    }

    return array;
}

////返回布局大小
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//
//    NSArray * array = [super layoutAttributesForElementsInRect:rect];
//    //计算CollectionView最中心的x值
//    CGFloat contentY = self.collectionView.contentOffset.y;
//    for (UICollectionViewLayoutAttributes * attrs in array) {
//        //CGFloat scale = arc4random_uniform(100)/100.0;
//        //attrs.indexPath.item 表示 这个attrs对应的cell的位置
//
//        CGFloat arrrsY = attrs.frame.origin.y;
//
//        //cell的中心点x 和CollectionView最中心点的x值
//        CGFloat delta = ABS(arrrsY - contentY);
//        //根据间距值  计算cell的缩放的比例
//        //这里scale 必须要 小于1
//        CGFloat scale = 1 + (1 - delta/(ScreenW/4));
//        //设置缩放比例
//        if (delta<120*WIDTH_SCALE) {
//            GGLog(@" 第%zdcell--距离：%.1f",attrs.indexPath.item ,arrrsY - contentY);
////            CGFloat originY = attrs.frame.origin.y;
//            //当不是第一个时
////            if (attrs.indexPath.item>2) {
////                originY = attrs.frame.origin.y + (ScreenW/4)*(scale-1);
////            }
////            attrs.zIndex = 1;
//            attrs.frame = CGRectMake(attrs.frame.origin.x, attrs.frame.origin.y, attrs.size.width, attrs.size.height*scale);
//        }
////        attrs.transform = CGAffineTransformMakeScale(scale, scale);
//
//    }
//    return array;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
