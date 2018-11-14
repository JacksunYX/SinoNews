//
//  UICopyLabel.m
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "UICopyLabel.h"

@implementation UICopyLabel
//绑定事件
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self pressAction];
    }
    return self;
}

//同上
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self pressAction];
}

//绑定长按手势
-(void)pressAction
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

-(void)longPressAction:(UILongPressGestureRecognizer *) recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        //创建菜单按钮
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(customCopy:)];
        //创建菜单
        UIMenuController *menu = [UIMenuController sharedMenuController];
        //设置菜单按钮
        menu.menuItems = @[copyLink];
        //出现方式
        menu.arrowDirection = UIMenuControllerArrowDefault;
        //显示
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated: YES];
    }
}

//可以成为响应者
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(customCopy:));
}

//针对于响应方法的实现（自定义方法）
- (void)customCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
}

@end
