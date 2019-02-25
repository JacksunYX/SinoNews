//
//  MessageSystemNoticeTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2019/2/25.
//  Copyright © 2019 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MessageSystemNoticeTableViewCellID;

@interface MessageSystemNoticeTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@end

NS_ASSUME_NONNULL_END
