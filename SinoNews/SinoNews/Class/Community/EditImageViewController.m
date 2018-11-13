//
//  EditImageViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "EditImageViewController.h"

@interface EditImageViewController ()
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;
@end

@implementation EditImageViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

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
    
    //键盘监听
    @weakify(self);
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.view, nil];
    }];
}

-(void)setUpNavigation
{
    self.navigationItem.title = @"编辑图片";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(finishAction) title:@"完成" font:PFFontR(14) titleColor:ThemeColor highlightedColor:ThemeColor titleEdgeInsets:UIEdgeInsetsZero];
}

-(void)setUI
{
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = BlackColor;
    FSTextView *descrip = [FSTextView textView];
    [self.view sd_addSubviews:@[
                                descrip,
                                imageView,
                                ]];
    descrip.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(100)
    ;
    descrip.inputAccessoryView = self.bottomView;
    descrip.placeholder = @"给图片配点文字吧";
    descrip.textColor = HexColor(#161A24);
    descrip.font = PFFontR(15);
    descrip.placeholderColor = HexColor(#B9C3C7);
    descrip.text = GetSaveString(self.model.imageDes);
    
    @weakify(self);
    [descrip addTextDidChangeHandler:^(FSTextView *textView) {
        @strongify(self);
        self.model.imageDes = textView.formatText;
    }];
    
    imageView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(descrip, 0)
    ;
    imageView.image = self.model.image;
    imageView.contentMode = 1;
    
    GCDAfterTime(0.5, ^{
        [descrip becomeFirstResponder];
    });
}

//完成事件
-(void)finishAction
{
    [self.view endEditing:YES];
    if (self.finishBlock) {
        self.finishBlock(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏键盘
-(void)showOrHideKeyboard:(UIButton *)sender
{
    [self.view endEditing:YES];
}

@end
