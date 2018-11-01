//
//  XLChannelControl.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLChannelModel.h"

typedef void(^ClickHandle)(NSString *title);

typedef void(^ChannelBlock)(NSArray *inUseTitles,NSArray *unUseTitles);

@interface XLChannelControl : NSObject

@property (nonatomic,strong) NSString *naviTitle;
//是否不可删除频道，默认为no，也就是可以删除频道
@property (nonatomic,assign) BOOL cannotDelete;

+(XLChannelControl*)shareControl;

-(void)showChannelViewWithInUseTitles:(NSArray*)inUseTitles unUseTitles:(NSArray*)unUseTitles finish:(ChannelBlock)block click:(ClickHandle)clickBlock;

@end
