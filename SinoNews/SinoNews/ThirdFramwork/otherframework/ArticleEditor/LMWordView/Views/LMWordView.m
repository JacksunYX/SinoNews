//
//  LMWordView.m
//  SimpleWord
//
//  Created by Chenly on 16/5/12.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMWordView.h"
#import <objc/runtime.h>

@implementation LMWordView {
    UIView *_titleView;
    UIView *_separatorLine;
    
    CGRect _frameCache;
}

static CGFloat const kLMWMargin = 20.f;
static CGFloat const kLMWTitleHeight = 44.f;
static CGFloat const kLMWCommonSpacing = 16.f;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _titleTextField = [[UITextField alloc] init];
    _titleTextField.font = [UIFont boldSystemFontOfSize:16.f];
    _titleTextField.placeholder = @"标题";
    
    _separatorLine = [[UIView alloc] init];
//    _separatorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = [UIColor whiteColor];
    
    [_titleView addSubview:_titleTextField];
    [_titleView addSubview:_separatorLine];
    [self addSubview:_titleView];
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;    
    self.alwaysBounceVertical = YES;
    
    if (self.showTitle) {
        
        self.textContainerInset = UIEdgeInsetsMake(kLMWMargin + kLMWTitleHeight + kLMWCommonSpacing,
                                                   kLMWCommonSpacing,
                                                   kLMWCommonSpacing,
                                                   kLMWCommonSpacing);
    }else{
        self.textContainerInset = UIEdgeInsetsMake(kLMWCommonSpacing,
                                                   kLMWCommonSpacing,
                                                   0,
                                                   kLMWCommonSpacing);
    }
}

-(void)setShowTitle:(BOOL)showTitle
{
    _showTitle = showTitle;
    _titleView.hidden = !self.showTitle;
    if (self.showTitle) {
        
        self.textContainerInset = UIEdgeInsetsMake(kLMWMargin + kLMWTitleHeight + kLMWCommonSpacing,
                                                   kLMWCommonSpacing,
                                                   kLMWCommonSpacing,
                                                   kLMWCommonSpacing);
    }else{
        self.textContainerInset = UIEdgeInsetsMake(kLMWCommonSpacing,
                                                   kLMWCommonSpacing,
                                                   0,
                                                   kLMWCommonSpacing);
    }
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_frameCache, self.frame)) {
        CGRect rect = CGRectInset(self.bounds, kLMWMargin, kLMWMargin);
        rect.origin.y = kLMWMargin;
        rect.size.height = kLMWTitleHeight;
        _titleView.frame = rect;
        
        rect.origin = CGPointZero;
        rect.size.height = 30.f;
        _titleTextField.frame = rect;
        
        rect.origin.y = CGRectGetHeight(_titleView.bounds) - 1;
        rect.size.height = 1.f;
        _separatorLine.frame = rect;
        [UIView drawDashLine:_separatorLine lineLength:5 lineSpacing:2 lineColor:RGBA(227, 227, 227, 1)];
        _frameCache = self.frame;
    }
}

@end
