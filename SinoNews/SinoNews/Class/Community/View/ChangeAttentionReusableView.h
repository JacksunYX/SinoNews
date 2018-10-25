//
//  ChangeAttentionReusableView.h
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ChangeAttentionReusableViewID;

NS_ASSUME_NONNULL_BEGIN

@interface ChangeAttentionReusableView : UICollectionReusableView

-(void)setData:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
