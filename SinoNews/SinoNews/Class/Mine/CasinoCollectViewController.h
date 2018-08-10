//
//  CasinoCollectViewController.h
//  SinoNews
//
//  Created by Michael on 2018/8/8.
//  Copyright © 2018年 Sino. All rights reserved.
//
//收藏的娱乐城

#import "BaseViewController.h"

@interface CasinoCollectViewController : BaseViewController

@property (nonatomic,assign) NSInteger type;    //0收藏的、1搜索的
@property (nonatomic,strong) NSString *keyword;   //搜索关键词
@end
