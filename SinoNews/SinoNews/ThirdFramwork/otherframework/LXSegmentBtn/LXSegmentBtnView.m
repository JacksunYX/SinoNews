//
//  LXSegmentBtnView.m
//  LXSegmentBtnDemo
//
//  Created by liuxin on 2017/12/1.
//  Copyright © 2017年 liuxin. All rights reserved.
//

#import "LXSegmentBtnView.h"

@interface LXSegmentBtnView()
@property (nonatomic , strong) NSMutableArray *btnArray;

@end

@implementation LXSegmentBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 3.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        [self initDefaults];
        
    }
    return self;
}

- (void)initDefaults{
    self.btnArray = [NSMutableArray new];
    self.btnTitleNormalColor = [UIColor blackColor];
    self.btnTitleSelectColor = [UIColor blackColor];
    self.btnBackgroundNormalColor = [UIColor whiteColor];
    self.btnBackgroundSelectColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.titleFont = [UIFont systemFontOfSize:14];
}


//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self initView];
//    
//}

-(void)initView{
    CGFloat btnW = self.bounds.size.width/_btnTitleArray.count;
    for (int idx = 0; idx < _btnTitleArray.count; idx ++) {
        UIButton *btn = [self getBtn];
        btn.tag = idx;
        [btn setTitle:_btnTitleArray[idx] forState:UIControlStateNormal];
        btn.frame = CGRectMake(btnW*idx + 0.5, 0, btnW, self.bounds.size.height);
//        if (idx == 0) {
//            btn.selected = YES;
//        }
        [self.btnArray addObject:btn];
        
        if (idx<_btnTitleArray.count - 1) {
            UIView *line = [self getLineView];
            line.frame = CGRectMake(btnW*(idx + 1), 0, 0.5, self.bounds.size.height);
            [self bringSubviewToFront:line];
        }
    }
    
}

-(void)setBtnTitleArray:(NSArray *)btnTitleArray{
    _btnTitleArray = btnTitleArray;
    [self initView];
    UIButton *btn = (UIButton *)self.btnArray[0];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)self.btnArray[selectedIndex];
    [self btnClick:btn];
}

-(void)btnClick:(UIButton *)btn{

    if (btn.selected) {
        return;
    }
    
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *otherBtn = (UIButton *)obj;
        if (otherBtn.selected) {
            otherBtn.selected = !otherBtn.selected;
        }
    }];
    
    btn.selected = YES;
    _selectedIndex = btn.tag;
    if (self.lxSegmentBtnSelectIndexBlock) {
        self.lxSegmentBtnSelectIndexBlock(btn.tag,btn);
    }
    
    if ([self.delegate respondsToSelector:@selector(lxSegmentView:selectIndex:)]) {
        [self.delegate lxSegmentView:self selectIndex:btn.tag];
    }
    
}

-(void)setBtnTitleNormalColor:(UIColor *)btnTitleNormalColor
{
    _btnTitleNormalColor = btnTitleNormalColor;
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:btnTitleNormalColor forState:UIControlStateNormal];
    }
}

-(void)setBtnTitleSelectColor:(UIColor *)btnTitleSelectColor
{
    _btnTitleSelectColor = btnTitleSelectColor;
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:btnTitleSelectColor forState:UIControlStateSelected];
    }
}

-(void)setBordColor:(UIColor *)bordColor
{
    _bordColor = bordColor;
    self.layer.borderColor = bordColor.CGColor;
    self.layer.borderWidth = 1.0;
}

-(void)setBtnBackgroundNormalColor:(UIColor *)btnBackgroundNormalColor
{
    _btnBackgroundNormalColor = btnBackgroundNormalColor;
    for (UIButton *btn in self.btnArray) {
        [btn setBackgroundImage:[self lx_imageWithColor:btnBackgroundNormalColor] forState:UIControlStateNormal];
    }
}

-(void)setBtnBackgroundSelectColor:(UIColor *)btnBackgroundSelectColor
{
    _btnBackgroundSelectColor = btnBackgroundSelectColor;
    for (UIButton *btn in self.btnArray) {
        [btn setBackgroundImage:[self lx_imageWithColor:btnBackgroundSelectColor] forState:UIControlStateSelected];
    }
}

#pragma mark ---init---
-(UIButton *)getBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:self.btnTitleNormalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.btnTitleSelectColor forState:UIControlStateSelected];
    [btn setBackgroundImage:[self lx_imageWithColor:self.btnBackgroundNormalColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self lx_imageWithColor:self.btnBackgroundSelectColor] forState:UIControlStateSelected];
    btn.titleLabel.font = self.titleFont;
    [self addSubview:btn];
    return btn;
}

-(UIView *)getLineView{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    return line;
}


- (UIImage *)lx_imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
