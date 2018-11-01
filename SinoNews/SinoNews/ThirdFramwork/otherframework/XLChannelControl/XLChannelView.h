//
//  XLChannelView.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
//单个cell的点击回调
typedef void(^handleBlock)(NSString *clickTitle);

@interface XLChannelView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;

@property (nonatomic,strong) NSMutableArray *unUseTitles;

@property (nonatomic,copy) handleBlock clickBlock;

//是否不可删除频道，默认为no，也就是可以删除频道
@property (nonatomic,assign) BOOL cannotDelete;

-(void)reloadData;

@end
