//
//  ForumRightTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/24.
//  Copyright © 2018 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * _Nullable const ForumRightTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface ForumRightTableViewCell : UITableViewCell
@property (nonatomic,assign) BOOL isPost;//是否是发表版块
@property (nonatomic,strong) MainSectionModel *model;
-(void)setData:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
