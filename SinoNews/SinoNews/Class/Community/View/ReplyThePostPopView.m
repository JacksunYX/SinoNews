//
//  ReplyThePostPopView.m
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReplyThePostPopView.h"

@interface ReplyThePostPopView ()<TZImagePickerControllerDelegate>
{
    //功能按钮
    UIButton *emojiKeyboard;
    UIButton *addImage;
    UIButton *showKeyboard;
}
@property (nonatomic,strong) JHTextView *textView;
@end

@implementation ReplyThePostPopView

static CGFloat anumationTime = 0.25;

-(void)showWithData:(NSDictionary *)data finishInputHandle:(void(^)(NSDictionary *inputData))finishBlock cancelHandle:(void(^)(NSDictionary *cancelData))cancelBlock
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    backView.backgroundColor = RGBA(0, 0, 0, 0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //下方视图
    CGFloat bottomViewHeight = 225 + BOTTOM_MARGIN;
    UIView *bottomView = [UIView new];
    [bottomView addBakcgroundColorTheme];
    
    [backView addSubview:bottomView];
    
    bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, bottomViewHeight);
    //只为上部分添加圆角
    [bottomView cornerWithRadius:8 direction:CornerDirectionTypeTop];
    
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
        bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - bottomViewHeight, ScreenW, bottomViewHeight);
    }];
    
    //添加输入框和其他控件
    _textView = [JHTextView new];
    _textView.limitLength = 200;
    _textView.font = PFFontL(16);
    _textView.placeholderLabel.font = PFFontL(16);
    [_textView addBakcgroundColorTheme];
    if (UserGetBool(@"NightMode")) {
        _textView.textColor = HexColor(#cfd3d6);
    }
    _textView.placeholder = @"写点什么吧(最少10个字符)";
    
    UIButton *cancelBtn = [UIButton new];
    UIButton *sendBtn = [UIButton new];
    
    UIView *sepLine1 = [UIView new];
    sepLine1.backgroundColor = CutLineColor;
    if (UserGetBool(@"NightMode")) {
        sepLine1.backgroundColor = CutLineColorNight;
    }
    
    UIView *sepLine2 = [UIView new];
    sepLine2.backgroundColor = CutLineColor;
    if (UserGetBool(@"NightMode")) {
        sepLine2.backgroundColor = CutLineColorNight;
    }
    
    UIView *fuctionView = [UIView new];
    
    [bottomView sd_addSubviews:@[
                                 cancelBtn,
                                 sendBtn,
                                 sepLine1,
                                 _textView,
                                 sepLine2,
                                 fuctionView,
                                 ]];
    cancelBtn.sd_layout
    .leftSpaceToView(bottomView, 0)
    .topSpaceToView(bottomView, 0)
    .widthIs(54)
    .heightIs(48)
    ;
    [cancelBtn setNormalTitle:@"取消"];
    [cancelBtn setBtnFont:PFFontL(16)];
    [cancelBtn setNormalTitleColor:HexColor(#989898)];
    [cancelBtn addBakcgroundColorTheme];
    
    sendBtn.sd_layout
    .rightSpaceToView(bottomView, 10)
    .topSpaceToView(bottomView, 0)
    .widthIs(54)
    .heightIs(48)
    ;
    [sendBtn setNormalTitle:@"发布"];
    [sendBtn setBtnFont:PFFontL(16)];
    [sendBtn setNormalTitleColor:HexColor(#989898)];
    [sendBtn addBakcgroundColorTheme];
    sendBtn.enabled = NO;
    
    sepLine1.sd_layout
    .topSpaceToView(sendBtn, 0)
    .leftEqualToView(bottomView)
    .rightEqualToView(bottomView)
    .heightIs(1)
    ;
    
    _textView.sd_layout
    .topSpaceToView(sepLine1, 10)
    .leftSpaceToView(bottomView, 10)
    .rightSpaceToView(bottomView, 10)
    .bottomSpaceToView(bottomView, BOTTOM_MARGIN+53)
    ;
    
    sepLine2.sd_layout
    .topSpaceToView(_textView, 0)
    .leftEqualToView(bottomView)
    .rightEqualToView(bottomView)
    .heightIs(1)
    ;
    
    fuctionView.sd_layout
    .topSpaceToView(sepLine2, 0)
    .leftEqualToView(bottomView)
    .rightEqualToView(bottomView)
    .bottomSpaceToView(bottomView, BOTTOM_MARGIN)
    ;
    
    //添加功能按钮
    emojiKeyboard = [UIButton new];
    addImage = [UIButton new];
    showKeyboard = [UIButton new];
    
    [fuctionView sd_addSubviews:@[
                                  emojiKeyboard,
                                  addImage,
                                  showKeyboard,
                                  ]];
    emojiKeyboard.sd_layout
    .leftSpaceToView(fuctionView, 15)
    .centerYEqualToView(fuctionView)
    .widthIs(23)
    .heightEqualToWidth()
    ;
    [emojiKeyboard setNormalImage:UIImageNamed(@"emojiKeyBoard_icon")];
    [emojiKeyboard setSelectedImage:UIImageNamed(@"showKeyboard_icon")];
    
    addImage.sd_layout
    .leftSpaceToView(emojiKeyboard, 30)
    .centerYEqualToView(fuctionView)
    .widthIs(23)
    .heightEqualToWidth()
    ;
    [addImage setNormalImage:UIImageNamed(@"addImage_icon")];
    
    showKeyboard.sd_layout
    .rightSpaceToView(fuctionView, 15)
    .centerYEqualToView(fuctionView)
    .widthIs(23)
    .heightIs(19)
    ;
    [showKeyboard setNormalImage:UIImageNamed(@"showKeyboard_icon")];
    [showKeyboard setSelectedImage:UIImageNamed(@"hiddenKeyboard_icon")];

    
    @weakify(backView)
    @weakify(bottomView)
    @weakify(self)
    
    //监听textfield的输入状态
    _textView.textViewDidChangeBlock = ^(UITextView *textView) {
        sendBtn.enabled = NO;
        if (textView.text.length>9) {
            sendBtn.enabled = YES;
            [sendBtn setNormalTitleColor:HexColor(#1282EE)];
        }else{
            [sendBtn setNormalTitleColor:HexColor(#989898)];
        }
    };
    
    //取消
    [cancelBtn whenTap:^{
        @strongify(backView)
        @strongify(bottomView)
        
        if (cancelBlock) {
            cancelBlock(@{});
        }
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, bottomViewHeight);
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    //发布
    [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if ([NSString isEmpty:self.textView.text]) {
            return ;
        }
        if (finishBlock) {
            finishBlock(@{});
        }
        
        @strongify(backView)
        @strongify(bottomView)
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
            bottomView.sd_layout
            .leftEqualToView(backView)
            .rightEqualToView(backView)
            .bottomSpaceToView(backView, -bottomViewHeight)
            .heightIs(bottomViewHeight)
            ;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    //下方功能按钮点击事件
    [emojiKeyboard whenTap:^{
        GGLog(@"点击了表情按钮");
    }];
    [addImage whenTap:^{
        @strongify(self);
        [self popToSelectImages];
    }];
    [showKeyboard whenTap:^{
        @strongify(self);
        [self showOrHideKeyboard];
    }];
    
    //添加监听
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(bottomView)
        NSDictionary *info = x.userInfo;
        CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:anumationTime animations:^{
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - keyboardSize.height - bottomViewHeight , ScreenW, bottomViewHeight);
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        [UIView animateWithDuration:anumationTime animations:^{
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - bottomViewHeight, ScreenW, bottomViewHeight);
        }];
    }];
}

//弹出选择图片
-(void)popToSelectImages
{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingVideo = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
}

-(void)showOrHideKeyboard
{
    GGLog(@"显隐键盘");
    showKeyboard.selected = !showKeyboard.selected;
    //如果已经弹出了
    if (showKeyboard.selected) {
        [self.textView becomeFirstResponder];
    }else{
        [self endEditing:YES];
    }
}

#pragma mark --- TZImagePickerControllerDelegate ---
//选择图片后会进入该代理方法，
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
}

@end
