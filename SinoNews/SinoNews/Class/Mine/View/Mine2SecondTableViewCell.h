//
//  Mine2SecondTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/26.
//  Copyright © 2018 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const Mine2SecondTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface Mine2SecondTableViewCell : UITableViewCell
//点击回调
@property (nonatomic,copy) void(^clickBlock)(NSInteger index);

-(void)setData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
