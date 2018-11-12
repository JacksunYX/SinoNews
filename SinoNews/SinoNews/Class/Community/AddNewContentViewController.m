//
//  AddNewContentViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "AddNewContentViewController.h"

@interface AddNewContentViewController ()
@property (nonatomic,strong) FSTextView *contentView;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;
@end

@implementation AddNewContentViewController
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
    _contentView = [FSTextView textView];
    _contentView.font = PFFontR(20);
    _contentView.textColor = BlackColor;
    _contentView.inputAccessoryView = self.bottomView;
    
    [self.view addSubview:_contentView];
    _contentView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(200)
    ;
    [_contentView updateLayout];
    [_contentView addBorderTo:BorderTypeBottom borderColor:HexColor(#e3e3e3)];
    _contentView.placeholder = @"来吧，尽情发挥吧！";
    _contentView.placeholderColor = HexColor(#BAC3C7);
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
    if ([NSString isEmpty:_contentView.formatText]) {
        LRToast(@"请输入有效文本");
    }else{
        [self.view endEditing:YES];
        if (self.finishBlock) {
            self.finishBlock(_contentView.text);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)showOrHideKeyboard:(UIButton *)sender
{
    [self.view endEditing:YES];
}


@end
