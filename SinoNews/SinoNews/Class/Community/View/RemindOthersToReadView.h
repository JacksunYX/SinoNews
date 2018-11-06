//
//  RemindOthersToReadView.h
//  SinoNews
//
//  Created by Michael on 2018/11/5.
//  Copyright © 2018 Sino. All rights reserved.
//
//@其他人视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RemindPeople;
@interface RemindOthersToReadView : UIView

@property (nonatomic ,strong) NSMutableArray <RemindPeople *> *remindArr;
@end

NS_ASSUME_NONNULL_END
