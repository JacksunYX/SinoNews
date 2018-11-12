//
//  EditVideoViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "EditVideoViewController.h"

@interface EditVideoViewController ()
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@end

@implementation EditVideoViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

- (void)viewDidLoad
{
    
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
    self.navigationItem.title = @"编辑视频";
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
    descrip.placeholder = @"给视频配点文字吧";
    descrip.textColor = HexColor(#161A24);
    descrip.font = PFFontR(15);
    descrip.placeholderColor = HexColor(#B9C3C7);
    descrip.text = GetSaveString(self.model.videoDes);
    
    @weakify(self);
    [descrip addTextDidChangeHandler:^(FSTextView *textView) {
        @strongify(self);
        self.model.videoDes = textView.formatText;
    }];
    
    imageView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(descrip, 0)
    ;
    imageView.image = self.model.image;
    imageView.contentMode = 1;
}

//完成事件
-(void)finishAction
{
    if (self.finishBlock) {
        self.finishBlock(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
