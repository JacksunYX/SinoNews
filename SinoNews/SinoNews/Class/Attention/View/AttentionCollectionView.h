//
//  AttentionViewController.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//自定义关注自界面的横向滚动界面


#import <UIKit/UIKit.h>

@protocol AttentionDelegate <NSObject>
@required

/**
 返回分区里item个数

 @return 个数
 */
-(NSInteger)numberOfItemsInSection;


/**
 返回对应indexpath的cell

 @param indexpath 坐标
 @param collectionView 表格视图
 @return 返回的重用cell
 */
-(UICollectionViewCell *)returnCollectionCellForIndexPath:(NSIndexPath *)indexpath collectionView:(UICollectionView *)collectionView;


/**
 点击的下标

 @param index 下标
 */
-(void)didSelected:(NSIndexPath *)indexPath;

@end

@interface AttentionCollectionView : UIView

@property (nonatomic,weak) id<AttentionDelegate> delegate;

-(void)registerViewClass:(id)view ID:(NSString *)identifier;

@end
