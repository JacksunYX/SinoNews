//
//  PGCustomBannerView.m
//  NewPagedFlowViewDemo
//
//  Created by Guo on 2017/8/24.
//  Copyright © 2017年 robertcell.net. All rights reserved.
//

#import "PGCustomBannerView.h"

@interface PGCustomBannerView ()
@property (nonatomic, strong) UILabel *topicLabel;
@end

@implementation PGCustomBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.topicLabel];
        [self addSubview:self.indexLabel];
    }
    
    return self;
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {

    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
    self.indexLabel.frame = CGRectMake(10, superViewBounds.size.height - 60, superViewBounds.size.width - 15, 50);
    self.topicLabel.frame = CGRectMake(10, CGRectGetMinY(self.indexLabel.frame) - 5 - 20, 35, 20);
    self.topicLabel.text = @"专题";
    [self.topicLabel cornerWithRadius:3];
}

- (UILabel *)indexLabel {
    if (_indexLabel == nil) {
        _indexLabel = [[UILabel alloc] init];
//        _indexLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _indexLabel.backgroundColor = ClearColor;
        _indexLabel.font = PFFontM(16);
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.numberOfLines = 2;
    }
    return _indexLabel;
}

-(UILabel *)topicLabel
{
    if (!_topicLabel) {
        _topicLabel = [[UILabel alloc] init];
        _topicLabel.backgroundColor = HexColor(#1282EE);
        _topicLabel.font = PFFontM(14);
        _topicLabel.textColor = [UIColor whiteColor];
        _topicLabel.textAlignment = NSTextAlignmentCenter;
        _topicLabel.hidden = YES;
    }
    return _topicLabel;
}

-(void)setIsTopic:(BOOL)isTopic
{
    _isTopic = isTopic;
    self.topicLabel.hidden = !isTopic;
}

@end
