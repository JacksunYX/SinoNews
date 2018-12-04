//
//  YXLabel.m
//  SinoNews
//
//  Created by Michael on 2018/11/16.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "YXLabel.h"

@implementation YXLabel

-(instancetype)init
{
    if (self == [super init]) {
        self.displaysAsynchronously = YES;
        self.numberOfLines = 0;
        //设置本地表情识别
        self.textParser = BrowsNewsSingleton.singleton.parser;
        [self pressAction];
        /*
        @weakify(self);
        self.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            if ( [UIMenuController sharedMenuController].menuVisible ) {
                [UIMenuController sharedMenuController].menuVisible = NO;
            }else{
                UIMenuController *menu = [UIMenuController sharedMenuController];
                UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
                UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(selectAll:)];
                
                [menu setMenuItems:@[
                                     item0,
                                     item1,
                                     ]];
                //出现方式
                menu.arrowDirection = UIMenuControllerArrowDefault;
                //显示
                [menu setTargetRect:self.frame inView:self.superview];
                [menu setMenuVisible:YES animated: YES];
            }
            
        };
         */
    }
    return self;
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

//计算label高度
- (CGFloat)getLabelWithLineSpace:(CGFloat)lineSpace width:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = self.textAlignment;
    //    paraStyle.lineSpacing = lineSpace;
    //    paraStyle.hyphenationFactor = 1.0;
    //首行缩进
    //    paraStyle.firstLineHeadIndent = 0.0;
    //    paraStyle.paragraphSpacingBefore = 0.0;
    //头尾缩进
    //    paraStyle.headIndent = 0;
    //    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{
                          NSFontAttributeName:self.font,
                          NSParagraphStyleAttributeName:paraStyle,
                          //                          NSKernAttributeName:@1.0f,
                          };
    
    //创建富文本并将上面的段落样式加入
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attrString addAttributes:dic range:NSMakeRange(0, attrString.length)];
    self.attributedText = attrString;
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    //计算的大小可能刚刚够排版的高度，最好取整后加1，宁愿大一点点，不能小了导致无法显示完全
    return ceil(size.height) + 1;
    
}

@end
