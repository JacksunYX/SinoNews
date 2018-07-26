//
//  XLChannelItem.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelItem.h"

@interface XLChannelItem ()
{
    UILabel *_textLabel;
    
    CAShapeLayer *_borderLayer;
    
    UIImageView *deleteImg;
    
    UILabel *newLabel;
}
@end

@implementation XLChannelItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = true;
    self.layer.cornerRadius = (([UIScreen mainScreen].bounds.size.width - 50)/4)*  30 / 85 /2;
    self.backgroundColor = [self backgroundColor];
    
    _textLabel = [UILabel new];
    _textLabel.frame = self.bounds;
    _textLabel.textAlignment = NSTextAlignmentCenter;
//    _textLabel.textColor = [self textColor];
    [_textLabel addContentColorTheme];
    _textLabel.adjustsFontSizeToFitWidth = true;
    _textLabel.font = PFFontL(15);
//    _textLabel.userInteractionEnabled = true;
    [self addSubview:_textLabel];
    
    [self addBorderLayer];
    
    deleteImg = [UIImageView new];
    deleteImg.userInteractionEnabled = YES;
    deleteImg.frame = CGRectMake(3, -3, 12, 12);
//    deleteImg.backgroundColor = [UIColor redColor];
    deleteImg.hidden = YES;
//    [deleteImg setImage:[UIImage imageNamed:@"delete.png"]];
    deleteImg.lee_theme.LeeConfigImage(@"channelManager_delete");
    [self addSubview:deleteImg];
    
    newLabel = [UILabel new];
    newLabel.textColor = OrangeColor;
    newLabel.font = Font(12);
    newLabel.text = @"new";
    [newLabel sizeToFit];
    newLabel.hidden = YES;
    newLabel.frame = CGRectMake(_textLabel.frame.size.width - CGRectGetWidth(newLabel.frame)/2, -3, CGRectGetWidth(newLabel.frame), CGRectGetHeight(newLabel.frame));
    [self addSubview:newLabel];
}

-(void)addBorderLayer{
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1;
    _borderLayer.lineDashPattern = @[@5, @3];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [self backgroundColor].CGColor;
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = true;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

#pragma mark -
#pragma mark 配置方法

-(UIColor*)backgroundColor{
    return HexColor(#f6f7fb);
}

-(UIColor*)textColor{
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

-(UIColor*)lightTextColor{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
}

#pragma mark -
#pragma mark Setter

-(void)setTitle:(NSString *)title
{
    _title = title;
    _textLabel.text = title;
}

-(void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
        _borderLayer.hidden = false;
    }else{
        self.backgroundColor = [self backgroundColor];
        _borderLayer.hidden = true;
    }
}

-(void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
    if (isFixed) {
//        _textLabel.textColor = [self lightTextColor];
//        _textLabel.textColor = [UIColor colorWithRed:18/255.0f green:130/255.0f blue:238/255.0f alpha:1.0f];
        _textLabel.textColor = HexColor(#1282EE);
        if (UserGetBool(@"NightMode")) {
            self.backgroundColor = HexColor(#1c2023);
        }else{
            self.backgroundColor = [UIColor whiteColor];
        }
        _textLabel.layer.borderWidth = 1;
        _textLabel.layer.borderColor = HexColor(#cfd3d6).CGColor;
        
    }else{
        
        
        if (UserGetBool(@"NightMode")) {
            self.backgroundColor = HexColor(#292D30);
            _textLabel.textColor = HexColor(#CFD3D6);
        }else{
            self.backgroundColor = [self backgroundColor];
            _textLabel.textColor = [self textColor];
        }
        _textLabel.layer.borderWidth = 0;
        _textLabel.layer.borderColor = [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f].CGColor;
        
    }
    _textLabel.layer.cornerRadius = self.layer.cornerRadius;
}

-(void)setCanDelete:(BOOL)canDelete
{
    _canDelete = canDelete;
    deleteImg.hidden = !canDelete;
}

-(void)setIsNew:(BOOL)isNew
{
    _isNew = isNew;
    newLabel.hidden = !isNew;
}

@end
