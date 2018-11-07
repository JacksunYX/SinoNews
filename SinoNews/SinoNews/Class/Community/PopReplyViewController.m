//
//  PopReplyViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PopReplyViewController.h"

@interface PopReplyViewController ()<TZImagePickerControllerDelegate>
@property (nonatomic,strong) UIView *bottomView;
//上方功能按钮
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sendBtn;
//输入框
@property (nonatomic,strong) JHTextView *textView;
//下方功能按钮
@property (nonatomic,strong) UIButton *emojiKeyboard;
@property (nonatomic,strong) UIButton *addImage;
@property (nonatomic,strong) UIButton *showKeyboard;
//顶部选择的图片
@property (nonatomic,strong) UIView *headImages;
@property (nonatomic,strong) UIImageView *imageArrow;   //白色箭头
@end

@implementation PopReplyViewController
static CGFloat animationTime = 0.25;

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏以及禁止手势返回
    self.navigationController.navigationBar.hidden = YES;
    self.fd_interactivePopDisabled = YES;
    [self setUI];
}

-(void)setSelectImages:(NSMutableArray *)selectImages
{
    _selectImages = selectImages;
}

-(void)setUI
{
    self.view.backgroundColor = ClearColor;
    
    //下方视图
    CGFloat bottomViewHeight = (225 + BOTTOM_MARGIN);
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = WhiteColor;
    
    [self.view addSubview:_bottomView];
    
    _bottomView.sd_layout
    .topSpaceToView(self.view, ScreenH)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(bottomViewHeight)
    ;
    [_bottomView updateLayout];

    //只为上部分添加圆角
    [_bottomView cornerWithRadius:8 direction:CornerDirectionTypeTop];
    
    //添加图片视图
    [self setShowSelectImagesView];
    
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
    
    _cancelBtn = [UIButton new];
    _sendBtn = [UIButton new];
    
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
    
    [_bottomView sd_addSubviews:@[
                                 _cancelBtn,
                                 _sendBtn,
                                 sepLine1,
                                 _textView,
                                 sepLine2,
                                 fuctionView,
                                 ]];
    _cancelBtn.sd_layout
    .leftSpaceToView(_bottomView, 0)
    .topSpaceToView(_bottomView, 0)
    .widthIs(54)
    .heightIs(48)
    ;
    [_cancelBtn setNormalTitle:@"取消"];
    [_cancelBtn setBtnFont:PFFontL(16)];
    [_cancelBtn setNormalTitleColor:HexColor(#989898)];
    [_cancelBtn addBakcgroundColorTheme];
    
    _sendBtn.sd_layout
    .rightSpaceToView(_bottomView, 10)
    .topSpaceToView(_bottomView, 0)
    .widthIs(54)
    .heightIs(48)
    ;
    [_sendBtn setNormalTitle:@"发布"];
    [_sendBtn setBtnFont:PFFontL(16)];
    [_sendBtn setNormalTitleColor:HexColor(#989898)];
    [_sendBtn addBakcgroundColorTheme];
    _sendBtn.enabled = NO;
    
    sepLine1.sd_layout
    .topSpaceToView(_sendBtn, 0)
    .leftEqualToView(_bottomView)
    .rightEqualToView(_bottomView)
    .heightIs(1)
    ;
    
    _textView.sd_layout
    .topSpaceToView(sepLine1, 10)
    .leftSpaceToView(_bottomView, 10)
    .rightSpaceToView(_bottomView, 10)
    .bottomSpaceToView(_bottomView, BOTTOM_MARGIN+53)
    ;
    
    sepLine2.sd_layout
    .topSpaceToView(_textView, 0)
    .leftEqualToView(_bottomView)
    .rightEqualToView(_bottomView)
    .heightIs(1)
    ;
    
    fuctionView.sd_layout
    .topSpaceToView(sepLine2, 0)
    .leftEqualToView(_bottomView)
    .rightEqualToView(_bottomView)
    .bottomSpaceToView(_bottomView, BOTTOM_MARGIN)
    ;
    
    //添加功能按钮
    _emojiKeyboard = [UIButton new];
    _addImage = [UIButton new];
    _showKeyboard = [UIButton new];
    
    [fuctionView sd_addSubviews:@[
                                  _emojiKeyboard,
                                  _addImage,
                                  _showKeyboard,
                                  ]];
    _emojiKeyboard.sd_layout
    .leftSpaceToView(fuctionView, 15)
    .centerYEqualToView(fuctionView)
    .widthIs(23)
    .heightEqualToWidth()
    ;
    [_emojiKeyboard setNormalImage:UIImageNamed(@"emojiKeyBoard_icon")];
    [_emojiKeyboard setSelectedImage:UIImageNamed(@"showKeyboard_icon")];
    
    _addImage.sd_layout
    .leftSpaceToView(_emojiKeyboard, 30)
    .centerYEqualToView(fuctionView)
    .widthIs(23)
    .heightEqualToWidth()
    ;
    [_addImage setNormalImage:UIImageNamed(@"addImage_icon")];
    
    _showKeyboard.sd_layout
    .rightSpaceToView(fuctionView, 15)
    .centerYEqualToView(fuctionView)
    .widthIs(23)
    .heightIs(19)
    ;
    [_showKeyboard setNormalImage:UIImageNamed(@"showKeyboard_icon")];
    [_showKeyboard setSelectedImage:UIImageNamed(@"hiddenKeyboard_icon")];
    
    @weakify(self)
    //监听textfield的输入状态
    _textView.textViewDidChangeBlock = ^(UITextView *textView) {
        @strongify(self);
        self.sendBtn.enabled = NO;
        if (textView.text.length>9) {
            self.sendBtn.enabled = YES;
            [self.sendBtn setNormalTitleColor:HexColor(#1282EE)];
        }else{
            [self.sendBtn setNormalTitleColor:HexColor(#989898)];
        }
    };
    
    _textView.textViewDidBeginEditingBlock = ^(UITextView *textView) {
        @strongify(self);
        self.showKeyboard.selected = YES;
    };
    _textView.textViewDidEndEditingBlock = ^(UITextView *textView) {
        @strongify(self);
        self.showKeyboard.selected = NO;
    };
    
    //取消
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //发布
    [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //下方功能按钮点击事件
    [_emojiKeyboard whenTap:^{
        GGLog(@"点击了表情按钮");
    }];
    [_addImage whenTap:^{
        @strongify(self);
        [self popToSelectImages];
    }];
    [_showKeyboard whenTap:^{
        @strongify(self);
        [self showOrHideKeyboard];
    }];
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.backgroundColor = BlackColor;
        self.bottomView.sd_layout
        .bottomEqualToView(self.view)
        ;
        [self.bottomView updateLayout];
    }];
    
    //监听键盘通知
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowChangeFrameNotification:) name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillHideChangeFrameNotification:) name:UIKeyboardWillHideNotification object:nil];
}

//设置选择的图片视图
-(void)setShowSelectImagesView
{
    self.imageArrow.hidden = NO;
    self.headImages.hidden = NO;
    if (!self.imageArrow) {
        self.imageArrow = [UIImageView new];
        [self.view addSubview:self.imageArrow];
        self.imageArrow.sd_layout
        .leftSpaceToView(self.view, 70)
        .bottomSpaceToView(self.bottomView, 0)
        .widthIs(15)
        .heightIs(7)
        ;
        self.imageArrow.image = UIImageNamed(@"addImages_downArrow");
    }
    if (!self.headImages) {
        self.headImages = [UIView new];
        self.headImages.backgroundColor = WhiteColor;
        
        [self.view addSubview:self.headImages];
        self.headImages.sd_layout
        .leftSpaceToView(self.view, 60)
        .bottomSpaceToView(self.imageArrow, 0)
        .widthIs(0)
        .heightIs(92)
        ;
        self.headImages.sd_cornerRadius = @5;
    }
    if (self.selectImages.count > 0) {
        
        [self.headImages removeAllSubviews];
        
        CGFloat avgSpaceX = 6;
        CGFloat avgW = 73;
        CGFloat avgH = avgW;
        
        UIView *lastView = self.headImages;
        for (int i = 0; i < self.selectImages.count; i ++) {
            
            UIImageView *imageView = [UIImageView new];
            imageView.backgroundColor = Arc4randomColor;
            imageView.tag = 10089 + i;
            [self.headImages addSubview:imageView];
            imageView.sd_layout
            .topSpaceToView(self.headImages, 6)
            .leftSpaceToView(lastView, avgSpaceX)
            .widthIs(avgW)
            .heightIs(avgH)
            ;
            
            lastView = imageView;
        }
        
        [self.headImages setupAutoWidthWithRightView:lastView rightMargin:6];
    }else{
        self.imageArrow.hidden = YES;
        self.headImages.hidden = YES;
    }
}

//弹出选择图片
-(void)popToSelectImages
{
    if (self.selectImages.count>=3) {
        LRToast(@"最多只能选择三张照片");
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(3 - self.selectImages.count) delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingVideo = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void)showOrHideKeyboard
{
    self.showKeyboard.selected = !self.showKeyboard.selected;
    //如果已经弹出了
    if (self.showKeyboard.selected) {
        [self.textView becomeFirstResponder];
    }else{
        [self.textView resignFirstResponder];
    }
}

-(void)cancelAction:(UIButton *)sender
{
    [UIView animateWithDuration:animationTime animations:^{
        self.view.backgroundColor = ClearColor;
        self.bottomView.sd_layout
        .bottomSpaceToView(self.view, -self.bottomView.height)
        ;
        [self.bottomView updateLayout];
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

-(void)sendAction:(UIButton *)sender
{
    if ([NSString isEmpty:self.textView.text]) {
        return ;
    }
    if (self.finishBlock) {
        self.finishBlock(@{});
    }
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.backgroundColor = ClearColor;
        self.bottomView.sd_layout
        .bottomSpaceToView(self.view, -self.bottomView.height)
        ;
        [self.bottomView updateLayout];
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

-(void)keyboardWillShowChangeFrameNotification:(NSNotification *)note{
    
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.size.height;
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        //平移
        self.bottomView.sd_layout
        .bottomSpaceToView(self.view, transformY)
        ;
        [self.bottomView updateLayout];
    }];
}

-(void)keyboardWillHideChangeFrameNotification:(NSNotification *)note{
    
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.sd_layout
        .bottomSpaceToView(self.view, 0)
        ;
        [self.bottomView updateLayout];
        
    }];
}

#pragma mark --- TZImagePickerControllerDelegate ---
//选择图片后会进入该代理方法，
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [self.selectImages addObjectsFromArray:photos];
    [self setShowSelectImagesView];
}

@end
