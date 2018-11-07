//
//  Mine2FirstTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/26.
//  Copyright © 2018 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const Mine2FirstTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface Mine2FirstTableViewCell : UITableViewCell
//点击回调
@property (nonatomic,copy) void(^clickBlock)(NSInteger index);

-(void)setData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END