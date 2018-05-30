//
//  XLChannelHeaderView.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editBlock)(BOOL isedit);

@interface XLChannelHeader : UICollectionReusableView

@property (copy,nonatomic) NSString *title;

@property (copy,nonatomic) NSString *subTitle;

@property (nonatomic,copy) editBlock isEditBlock;

@property (copy,nonatomic) NSString *rightTitle;

@property (nonatomic,assign) BOOL showLine;

@end
