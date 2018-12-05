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
    UIFont *lastFont = self.font;
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
                          NSFontAttributeName:lastFont,
                          NSParagraphStyleAttributeName:paraStyle,
                          //                          NSKernAttributeName:@1.0f,
                          };
    NSString *processText = [self deleteH5LabelWithH5:self.text];
    //创建富文本并将上面的段落样式加入
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:processText];
    [attrString addAttributes:dic range:NSMakeRange(0, attrString.length)];
    //将处理过h5标签的富文本赋值给当前label
    self.attributedText = [self p_htmlChangeString:GetSaveString(self.text)];
    self.font = lastFont;//不加这句字体会还原
    
    //计算出大小
    CGSize size = [processText boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    //计算的大小可能刚刚够排版的高度，最好取整后加1，宁愿大一点点，不能小了导致无法显示完全
    return ceil(size.height) + 1;
    
}

//移除h5标签
-(NSString *)deleteH5LabelWithH5:(NSString *)h5String
{
    NSString *tagString = GetSaveString(h5String);
    NSScanner *scanner = [NSScanner scannerWithString:tagString];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        tagString = [tagString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return tagString;
}

//解析获取h5内容
-(NSMutableAttributedString *)p_htmlChangeString:(NSString *)aString
{
    NSMutableAttributedString *oneString = [[NSMutableAttributedString alloc]initWithString:aString attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}];
    
    [oneString enumerateAttributesInRange:oneString.rangeOfAll options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSURL *link = [attrs objectForKey:NSLinkAttributeName];
        if (link){
            //链接变颜色
            [oneString setTextHighlightRange:range color:BlueColor backgroundColor:WhiteColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link.absoluteString]];
            }];
        }
        
    }];
    
    return oneString;
}

@end
