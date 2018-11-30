//
//  PopReplyViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PopReplyViewController.h"

@interface PopReplyViewController ()<TZImagePickerControllerDelegate,YYTextViewDelegate,EmotionKeyBoardDelegate>
@property (nonatomic,strong) UIView *bottomView;
//上方功能按钮
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sendBtn;
//输入框
@property (nonatomic,strong) YXTextView *textView;
//下方功能按钮
@property (nonatomic,strong) UIButton *emojiKeyboard;
@property (nonatomic,strong) UIButton *addImage;
@property (nonatomic,strong) UIButton *showKeyboard;
//顶部选择的图片
@property (nonatomic,strong) UIView *headImages;
@property (nonatomic,strong) UIImageView *imageArrow;   //白色箭头

@property (nonatomic,strong) NSMutableArray *selectImages;

//emoji键盘
@property (nonatomic,strong) WTEmoticonInputView *emoticonInputView;
@end

@implementation PopReplyViewController
static CGFloat animationTime = 0.25;
-(NSMutableArray *)selectImages
{
    if (!_selectImages) {
        _selectImages = [NSMutableArray new];
    }
    return _selectImages;
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
    //隐藏导航栏以及禁止手势返回
    self.navigationController.navigationBar.hidden = YES;
    self.fd_interactivePopDisabled = YES;
    [self setUI];
}

-(void)setInputData:(NSMutableDictionary *)inputData
{
    _inputData = inputData;
    if (inputData) {
        [self.selectImages addObjectsFromArray:inputData[@"images"]];
    }
}

-(void)setUI
{
//    self.view.backgroundColor = ClearColor;
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
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
    
    //添加输入框和其他控件
    _textView = [YXTextView new];
    _textView.font = PFFontL(16);
    _textView.delegate = self;
    _textView.placeholderText = @"写点什么吧(最少10个字符)";
    [_textView addBakcgroundColorTheme];
    if (UserGetBool(@"NightMode")) {
        _textView.textColor = HexColor(#cfd3d6);
    }
    
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
    [_emojiKeyboard setSelectedImage:UIImageNamed(@"systemKeyboard_icon")];
    
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
    .widthIs(26)
    .heightIs(24)
    ;
    [_showKeyboard setNormalImage:UIImageNamed(@"showKeyboard_icon")];
    [_showKeyboard setSelectedImage:UIImageNamed(@"hiddenKeyboard_icon")];
    
    //取消
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //发布
    [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self)
    //下方功能按钮点击事件
    [_emojiKeyboard whenTap:^{
        @strongify(self);
        [self changeKeyboardType];
    }];
    [_addImage whenTap:^{
        @strongify(self);
        [self popToSelectImages];
    }];
    [_showKeyboard whenTap:^{
        @strongify(self);
        [self showOrHideKeyboard];
    }];
    
    GCDAfterTime(0.1, ^{
        [UIView animateWithDuration:animationTime animations:^{
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            self.bottomView.sd_layout
            .bottomEqualToView(self.view)
            ;
            [self.bottomView updateLayout];
        }];
    });
    
    //添加图片视图
    [self setShowSelectImagesView];
    
    //监听键盘通知
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillShowChangeFrameNotification:) name:UIKeyboardWillShowNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(keyboardWillHideChangeFrameNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    //暂时隐藏添加图片功能
    _addImage.hidden = YES;
    
#ifndef OpenAddLocalEmoji
    [_emojiKeyboard removeFromSuperview];
#endif
}

//显示方法
-(void)showFromVC:(UIViewController *)vc
{
    //这种弹出方式可以造成视觉差
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //当弹出类型为UIModalPresentationOverCurrentContext时，加上下面这句会让上个界面的导航栏不被遮住
//    vc.definesPresentationContext = YES;
    [vc presentViewController:self animated:NO completion:nil];
}

//显示方法2
-(void)showFromVC2:(UIViewController *)vc
{
    RTRootNavigationController *rnVC = [[RTRootNavigationController alloc]initWithRootViewController:self];
    rnVC.view.backgroundColor = ClearColor;
    rnVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [vc presentViewController:rnVC animated:NO completion:nil];
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
//            imageView.backgroundColor = Arc4randomColor;
//            imageView.tag = 10089 + i;
            UIButton *deleteBtn = [UIButton new];
            deleteBtn.tag = 10089 + i;
            
            [self.headImages sd_addSubviews:@[
                                              imageView,
                                              deleteBtn,
                                              ]];
            imageView.sd_layout
            .topSpaceToView(self.headImages, 6)
            .leftSpaceToView(lastView, avgSpaceX)
            .widthIs(avgW)
            .heightIs(avgH)
            ;
            imageView.image = self.selectImages[i];
            
            deleteBtn.sd_layout
            .rightEqualToView(imageView)
            .topEqualToView(imageView)
            .widthIs(16)
            .heightEqualToWidth()
            ;
            [deleteBtn setNormalImage:UIImageNamed(@"deleteImage_icon")];
            [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            
            lastView = imageView;
        }
        
        [self.headImages setupAutoWidthWithRightView:lastView rightMargin:6];
    }else{
        self.imageArrow.hidden = YES;
        self.headImages.hidden = YES;
    }
}

//删除图片
-(void)deleteAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 10089;
    //移除指定下标的图片，并重新生成界面
    [self.selectImages removeObjectAtIndex:index];
    [self setShowSelectImagesView];
}

//弹出选择图片
-(void)popToSelectImages
{
    if (self.selectImages.count>=3) {
        LRToast(@"最多只能选择三张照片");
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:0 delegate:self];
    imagePicker.maxImagesCount = 3 - self.selectImages.count;
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingVideo = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
    
}

//显隐键盘
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

//切换emoji键盘或系统键盘
-(void)changeKeyboardType
{
    self.emojiKeyboard.selected = !self.emojiKeyboard.selected;
    if (self.emojiKeyboard.selected) {
        //替换emoji键盘
        self.textView.inputView = self.emoticonInputView;
    }else{
        //换回系统键盘
        self.textView.inputView = nil;
    }
    [self.textView reloadInputViews];
    
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
}

//发布点击
-(void)sendAction:(UIButton *)sender
{
    if ([NSString isEmpty:self.textView.text]) {
        return ;
    }
    if (self.finishBlock) {
        NSMutableDictionary *data = [NSMutableDictionary new];
        data[@"images"] = self.selectImages;
        data[@"text"] = self.textView.text;
        self.finishBlock(data);
    }
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.backgroundColor = ClearColor;
        self.bottomView.sd_layout
        .bottomSpaceToView(self.view, -self.bottomView.height)
        ;
        [self.bottomView updateLayout];
    } completion:^(BOOL finished) {
//        [self.navigationController popViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

//取消点击
-(void)cancelAction:(UIButton *)sender
{
    if (self.cancelBlock) {
        NSMutableDictionary *data = [NSMutableDictionary new];
        data[@"images"] = self.selectImages;
        data[@"text"] = self.textView.text;
        self.cancelBlock(data);
    }
    [UIView animateWithDuration:animationTime animations:^{
        self.view.backgroundColor = ClearColor;
        self.bottomView.sd_layout
        .bottomSpaceToView(self.view, -self.bottomView.height)
        ;
        [self.bottomView updateLayout];
    } completion:^(BOOL finished) {
//        [self.navigationController popViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

//键盘监听
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

#pragma mark --- EmotionKeyBoardDelegate ---
- (void)clickEmotionName:(NSString *)name
{
    NSString *emotionString = [[WTUtils getEmoticonData] allKeysForObject:name][0];
    [_textView replaceRange:_textView.selectedTextRange withText:emotionString];
}

- (void)clickDelete
{
    [self.textView deleteBackward];
}

#pragma mark --- YYTextViewDelegate ---
- (void)textViewDidBeginEditing:(YYTextView *)textView
{
    self.showKeyboard.selected = YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView
{
    self.showKeyboard.selected = NO;
}

- (void)textViewDidChange:(YYTextView *)textView
{
    self.sendBtn.enabled = NO;
    if (textView.text.length>9) {
        self.sendBtn.enabled = YES;
        [self.sendBtn setNormalTitleColor:HexColor(#1282EE)];
    }else{
        [self.sendBtn setNormalTitleColor:HexColor(#989898)];
    }
}

@end
