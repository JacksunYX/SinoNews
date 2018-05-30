//
//  XLChannelHeaderView.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelHeader.h"

@interface XLChannelHeader ()
{
    UILabel *_titleLabel;
    
    UILabel *_subtitleLabel;
    
    UIButton *editBtn;
    
    UIView *longLine;   //长分割线
    UIView *shortLine;  //下划线
}
@end

@implementation XLChannelHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
//    CGFloat marginX = 15.0f;
    
//    CGFloat labelWidth = (self.bounds.size.width - 2*marginX)/2.0f;
    
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, labelWidth, self.bounds.size.height)];
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:_titleLabel];
    
    longLine = [UIView new];
    longLine.backgroundColor = [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f];
    longLine.frame = CGRectMake(10, self.bounds.size.height - 1, self.bounds.size.width - 20, 1);
    [self addSubview:longLine];
    
    shortLine = [UIView new];
    shortLine.backgroundColor = [UIColor colorWithRed:18/255.0f green:130/255.0f blue:238/255.0f alpha:1.0f];
    [self addSubview:shortLine];
    
//    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + marginX, 0, labelWidth, self.bounds.size.height)];
    _subtitleLabel = [UILabel new];
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    _subtitleLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:_subtitleLabel];
    
    editBtn = [UIButton new];
    [editBtn setTitleColor:[UIColor colorWithRed:18/255.0f green:130/255.0f blue:238/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    editBtn.frame = CGRectMake(self.bounds.size.width - 17 - 38, 10, 38, 20);
    editBtn.layer.cornerRadius = 10;
    editBtn.layer.masksToBounds = YES;
    editBtn.layer.borderColor = [UIColor colorWithRed:18/255.0f green:130/255.0f blue:238/255.0f alpha:1.0f].CGColor;
    editBtn.layer.borderWidth = 1;
    
    [self addSubview:editBtn];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(10, 0, _titleLabel.frame.size.width, self.bounds.size.height);
    shortLine.frame = CGRectMake(10, self.bounds.size.height - 3, _titleLabel.frame.size.width, 3);
}

-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subtitleLabel.text = subTitle;
    [_subtitleLabel sizeToFit];
    _subtitleLabel.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 10, 0, _subtitleLabel.frame.size.width, self.bounds.size.height);
}

//编辑按钮点击事件
-(void)clickEdit:(UIButton *)btn
{
    BOOL isedit = NO;
    if ([editBtn.titleLabel.text isEqualToString:@"编辑"]) {
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
        isedit = YES;
    }else{
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        isedit = NO;
    }
    if (self.isEditBlock) {
        self.isEditBlock(isedit);
    }
}

-(void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    if ([rightTitle isEqualToString:@""]) {
        [editBtn setHidden:YES];
    }else{
        [editBtn setTitle:rightTitle forState:UIControlStateNormal];
        [editBtn setHidden:NO];
    }
    
}

-(void)setShowLine:(BOOL)showLine
{
    _showLine = shortLine;
    longLine.hidden = !showLine;
    shortLine.hidden = !showLine;
}

@end
