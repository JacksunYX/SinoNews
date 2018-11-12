//
//  AddNewTitleViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "AddNewTitleViewController.h"

@interface AddNewTitleViewController ()
@property (nonatomic,strong) FSTextView *titleView;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;
@end

@implementation AddNewTitleViewController

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _bottomView.backgroundColor = WhiteColor;
        
        _showKeyboard = [UIButton new];
        [_bottomView addSubview:_showKeyboard];
        _showKeyboard.sd_layout
        .rightSpaceToView(_bottomView, 15)
        .centerYEqualToView(_bottomView)
        .widthIs(26)
        .heightIs(24)
        ;
        [_showKeyboard setNormalImage:UIImageNamed(@"hiddenKeyboard_icon")];
        [_showKeyboard addTarget:self action:@selector(showOrHideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self setUI];
    
    if (self.lastTitle) {
        _titleView.text = self.lastTitle;
    }
    [_titleView becomeFirstResponder];
}

-(void)setUpNavigation
{
    self.navigationItem.title = @"新增标题";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(finishAction) title:@"完成" font:PFFontR(14) titleColor:ThemeColor highlightedColor:ThemeColor titleEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
}

-(void)setUI
{
    _titleView = [FSTextView textView];
    _titleView.font = PFFontR(20);
    _titleView.textColor = BlackColor;
    _titleView.inputAccessoryView = self.bottomView;
    
    [self.view addSubview:_titleView];
    _titleView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(100)
    ;
    [_titleView updateLayout];
    [_titleView addBorderTo:BorderTypeBottom borderColor:HexColor(#E3E3E3)];
    _titleView.placeholder = @"起个引人关注的标题哦～";
    _titleView.placeholderColor = HexColor(#BAC3C7);
    _titleView.placeholderFont = PFFontR(20);
    // 限制输入最大字符数.
    _titleView.maxLength = 25;
    // 添加输入改变Block回调.
    @weakify(self);
    [_titleView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        
    }];
    // 添加到达最大限制Block回调.
    [_titleView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
        @strongify(self);
        [self.view endEditing:YES];
        LRToast(@"帖子标题最多支持25个字符");
    }];
    
}

-(void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//完成事件
-(void)finishAction
{
    if ([NSString isEmpty:_titleView.formatText]) {
        LRToast(@"请输入有效文本");
    }else{
        [self.view endEditing:YES];
        if (self.finishBlock) {
            self.finishBlock(self.titleView.text);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)showOrHideKeyboard:(UIButton *)sender
{
    [self.view endEditing:YES];
}

@end
