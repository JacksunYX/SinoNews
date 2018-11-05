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

@class MyFansModel;
@interface RemindOthersToReadView : UIView

@property (nonatomic ,strong) NSMutableArray <MyFansModel *> *remindArr;
@end

NS_ASSUME_NONNULL_END
