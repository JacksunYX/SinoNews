//
//  PGCustomBannerView.h
//  NewPagedFlowViewDemo
//
//  Created by Guo on 2017/8/24.
//  Copyright © 2017年 robertcell.net. All rights reserved.
//

#import "PGIndexBannerSubiew.h"

@interface PGCustomBannerView : PGIndexBannerSubiew

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *indexLabelBackView;
@property (nonatomic, assign) BOOL isTopic; //是否是专题

@end
