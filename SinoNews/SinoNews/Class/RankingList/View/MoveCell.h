//
//  MoveCell.h
//  veryGood
//
//  Created by dllo on 16/11/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*最小值的cell大小*/
#define SCellHeight 105 //150
/*最大值的cell大小*/
#define BCellHeight 160 //230

@class RankingModel;

@interface MoveCell : UITableViewCell

- (void)cellGetImage:(NSString *)str tag:(NSInteger)tag;

- (void)cellOffsetOnTabelView:(UITableView *)tabelView;

- (void)cellGetModel:(RankingModel *)model tag:(NSInteger)tag;

@end
