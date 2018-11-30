//
//  AddNewContentViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "AddNewContentViewController.h"

@interface AddNewContentViewController ()<EmotionKeyBoardDelegate,YYTextViewDelegate>
@property (nonatomic,strong) YXTextView *contentView;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;
@property (nonatomic,strong) UIButton *emojiKeyboard;
//emoji键盘
@property (nonatomic,strong) WTEmoticonInputView *emoticonInputView;
@end

@implementation AddNewContentViewController
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _bottomView.backgroundColor = WhiteColor;
        
        _emojiKeyboard = [UIButton new];
        _showKeyboard = [UIButton new];
        [_bottomView sd_addSubviews:@[
                                      _emojiKeyboard,
                                      _showKeyboard,
                                      ]];
        
        _emojiKeyboard.sd_layout
        .leftSpaceToView(_bottomView, 15)
        .topSpaceToView(_bottomView, 14)
        .widthIs(23)
        .heightEqualToWidth()
        ;
        [_emojiKeyboard setNormalImage:UIImageNamed(@"emojiKeyBoard_icon")];
        [_emojiKeyboard setSelectedImage:UIImageNamed(@"systemKeyboard_icon")];
        [_emojiKeyboard addTarget:self action:@selector(changeKeyboardType) forControlEvents:UIControlEventTouchUpInside];
        
        _showKeyboard.sd_layout
        .rightSpaceToView(_bottomView, 15)
        .centerYEqualToView(_bottomView)
        .widthIs(26)
        .heightIs(24)
        ;
        [_showKeyboard setNormalImage:UIImageNamed(@"hiddenKeyboard_icon")];
        [_showKeyboard addTarget:self action:@selector(showOrHideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
#ifndef OpenAddLocalEmoji
        [_emojiKeyboard removeFromSuperview];
#endif
    }
    return _bottomView;
}

-(WTEmoticonInputView *)emoticonInputView
{
    if (!_emoticonInputView) {
        _emoticonInputView = [[WTEmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kKeyBoardH)];
        _emoticonInputView.delegate = self;
    }
    return _emoticonInputView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self setUI];
    
    if (self.lastContent) {
        _contentView.text = self.lastContent;
    }
    [_contentView becomeFirstResponder];
}

-(void)setUpNavigation
{
    self.navigationItem.title = @"新增文本";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(finishAction) title:@"完成" font:PFFontR(14) titleColor:ThemeColor highlightedColor:ThemeColor titleEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
}

-(void)setUI
{
    _contentView = [YXTextView new];
    _contentView.font = PFFontR(20);
    _contentView.textColor = BlackColor;
    _contentView.inputAccessoryView = self.bottomView;
    
    UIView *line = [UIView new];
    line.backgroundColor = HexColor(#e3e3e3);
    
    [self.view sd_addSubviews:@[
                                _contentView,
                                line,
                                ]];
    _contentView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(200)
    ;
    [_contentView updateLayout];
    
    line.sd_layout
    .topSpaceToView(_contentView, 0)
    .leftEqualToView(_contentView)
    .rightEqualToView(_contentView)
    .heightIs(1)
    ;
    
    _contentView.placeholderText = @"来吧，尽情发挥吧！";
    _contentView.placeholderTextColor = HexColor(#BAC3C7);
    _contentView.placeholderFont = PFFontR(20);
}

-(void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//完成事件
-(void)finishAction
{
    NSString *finalStr = [_contentView.text removeSpace];
    if ([NSString isEmpty:finalStr]) {
        LRToast(@"请输入有效文本");
    }else{
        [self.view endEditing:YES];
        if (self.finishBlock) {
            self.finishBlock(finalStr);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)changeKeyboardType
{
    _emojiKeyboard.selected = !_emojiKeyboard.selected;
    if (_emojiKeyboard.selected) {
        self.contentView.inputView = self.emoticonInputView;
    }else{
        self.contentView.inputView = nil;
    }
    [self.contentView reloadInputViews];
}

-(void)showOrHideKeyboard:(UIButton *)sender
{
    [self.view endEditing:YES];
}

#pragma mark --- EmotionKeyBoardDelegate ---
- (void)clickEmotionName:(NSString *)name
{
    NSString *emotionString = [[WTUtils getEmoticonData] allKeysForObject:name][0];
    YXTextView *textView = self.contentView;
    
    [textView replaceRange:textView.selectedTextRange withText:emotionString];
}

- (void)clickDelete
{
    YXTextView *textView = self.contentView;
    [textView deleteBackward];
}

#pragma mark --- YYTextViewDelegate ---
-(BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    return YES;
}

-(void)textViewDidChange:(YYTextView *)textView
{
    NSString *string = [textView.text removeSpace];
    GGLog(@"文本变化:%@",string);
}

-(void)textViewDidBeginEditing:(YYTextView *)textView
{
    GGLog(@"已经开始编辑");
}

-(void)textViewDidEndEditing:(YYTextView *)textView
{
    GGLog(@"已经结束编辑");
    self.emojiKeyboard.selected = NO;
    textView.inputView = nil;
}


@end
