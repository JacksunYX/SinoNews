//
//  ForumRightTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/24.
//  Copyright © 2018 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ForumRightTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface ForumRightTableViewCell : UITableViewCell

-(void)setData:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END