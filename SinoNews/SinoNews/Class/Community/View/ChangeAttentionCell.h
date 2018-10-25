//
//  ChangeAttentionCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//
//切换关注版块的自定义cell

#import <UIKit/UIKit.h>

extern NSString *const ChangeAttentionCellID;

NS_ASSUME_NONNULL_BEGIN

@interface ChangeAttentionCell : UICollectionViewCell

-(void)setData:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
