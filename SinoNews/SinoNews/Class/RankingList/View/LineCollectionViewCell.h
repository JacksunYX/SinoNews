//
//  LineCollectionViewCell.h
//  CollectionView-LineLayout
//
//  Created by Kobe24 on 2018/1/2.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"

#define LineCollectionViewCellID @"LineCollectionViewCellID"

@interface LineCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) RankingModel *model;

@end
