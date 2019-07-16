//
//  Mine3SecondTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/29.
//  Copyright © 2018 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const Mine3SecondTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface Mine3SecondTableViewCell : UITableViewCell

-(void)setData:(NSDictionary *)data;

-(void)setSubTitleTextColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
