//
//  FastPostingViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "FastPostingViewController.h"
#import "RemindOthersToReadViewController.h"
#import "SelectPublishChannelViewController.h"

#import "SelectImagesView.h"
#import "RemindOthersToReadView.h"

@interface FastPostingViewController ()<EmotionKeyBoardDelegate,YYTextViewDelegate>
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) YXTextView *titleView;
@property (nonatomic,strong) YXTextView *contentView;
@property (nonatomic,strong) SelectImagesView *addImageView;
@property (nonatomic,strong) RemindOthersToReadView *remindView;
@property (nonatomic,strong) UIButton *addTitle;    //添加标题按钮
@property (nonatomic,strong) UIView *bottomView;    //下方视图
@property (nonatomic,strong) UIButton *showKeyboard;
@property (nonatomic,strong) UIButton *emojiKeyboard;
@property (nonatomic,strong) UIButton *publishBtn;

//emoji键盘
@property (nonatomic,strong) WTEmoticonInputView *emoticonInputView;

@property (nonatomic,strong) SeniorPostDataModel *postModel;
@end

@implementation FastPostingViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(SeniorPostDataModel *)postModel
{
    if (!_postModel) {
        _postModel = [SeniorPostDataModel new];
    }
    return _postModel;
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
    
    [self addNavigationView];
    
    [self setUI];
    [self setUpBottomView];
    
    _contentView.text = @"";
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowChangeFrameNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideChangeFrameNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"快速发帖";
    [self setTopLineColor:HexColor(#E3E3E3)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:UIImageNamed(@"return_left")];
    
    _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_publishBtn setNormalTitle:@"发表"];
    [_publishBtn setNormalTitleColor:HexColor(#1282EE)];
    
    [_publishBtn setBtnFont:PFFontL(14)];
    [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_publishBtn];
}

-(void)publishAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([NSString isEmpty:self.postModel.postContent]) {
        LRToast(@"您还没有填写任何内容哦");
        return;
    }
    NSMutableArray *elementArr = [NSMutableArray new];
    //因为模型不同，需要转换一下
    if (self.addImageView.imagesArr) {
        for (SelectImageModel *model in self.addImageView.imagesArr) {
            SeniorPostingAddElementModel *newModel = [SeniorPostingAddElementModel new];
            //视频
            if (model.videoData||model.videoUrl) {
                newModel.videoData = model.videoData;
                newModel.videoUrl = model.videoUrl;
                
            }else{//图片
                newModel.imageUrl = model.imageUrl;
                
                if (model.status==Uploading) {
                    newModel.imageStatus = ImageUploading;
                }else if (model.status==UploadSuccess){
                    newModel.imageStatus = ImageUploadSuccess;
                }else if (model.status==UploadFailure){
                    newModel.imageStatus = ImageUploadFailure;
                }else{
                    newModel.imageStatus = ImageUploadNone;
                }
            }
            newModel.image = model.image;
            newModel.imageW = model.imageW;
            newModel.imageH = model.imageH;
            [elementArr addObject:newModel];
        }
    }
    self.postModel.dataSource = elementArr;
    GGLog(@"快速发帖内容展示：%@",self.postModel);
    SelectPublishChannelViewController *spcVC = [SelectPublishChannelViewController new];
    [self.navigationController pushViewController:spcVC animated:YES];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUI
{
    self.view.backgroundColor = HexColor(#F3F5F4);
    
    _mainScrollView = [UIScrollView new];
//    _mainScrollView.backgroundColor = RedColor;
    
    _titleView = [YXTextView new];
    _titleView.font = PFFontR(20);
    _titleView.textColor = BlackColor;
    _titleView.delegate = self;
    _titleView.backgroundColor = WhiteColor;
    
    _contentView = [YXTextView new];
    _contentView.font = PFFontL(15);
    _contentView.textColor = BlackColor;
    _contentView.delegate = self;
    _contentView.backgroundColor = WhiteColor;
    
    _addImageView = [SelectImagesView new];
//    _addImageView.backgroundColor = GreenColor;
    
    _remindView = [RemindOthersToReadView new];
    _remindView.backgroundColor = WhiteColor;
    
    [self.view sd_addSubviews:@[
                                _mainScrollView,
                                ]];
    _mainScrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 50+BOTTOM_MARGIN, 0))
    ;
    [_mainScrollView updateLayout];
    
    [_mainScrollView sd_addSubviews:@[
                                      _titleView,
                                      _contentView,
                                      _addImageView,
                                      _remindView,
                                      ]];
    _titleView.sd_layout
    .leftEqualToView(_mainScrollView)
    .topEqualToView(_mainScrollView)
    .rightEqualToView(_mainScrollView)
    .heightIs(0)
    ;
    [_titleView updateLayout];
    _titleView.placeholderText = @"快来起个厉害的标题吧！";
    _titleView.placeholderTextColor = HexColor(#BAC3C7);
    _titleView.placeholderFont = PFFontR(20);
    
    _contentView.sd_layout
    .topSpaceToView(_titleView, 1)
    .leftEqualToView(_mainScrollView)
    .rightEqualToView(_mainScrollView)
    .heightIs(200)
    ;
    [_contentView updateLayout];
    _contentView.placeholderText = @"分享观点，谈谈自己的看法，这就是一个任你发挥的平台...";
    _contentView.placeholderTextColor = HexColor(#B9C3C7);
    _contentView.placeholderFont = PFFontL(15);
    _contentView.layer.borderColor = HexColor(#E3E3E3).CGColor;
    _contentView.layer.borderWidth = 1;
    
    _addImageView.sd_layout
    .topSpaceToView(_contentView, 10)
    .leftSpaceToView(_mainScrollView, 10)
    .rightSpaceToView(_mainScrollView, 10)
    .heightIs(0)
    ;
    [_addImageView updateLayout];
    _addImageView.numPerRow = 4;
    _addImageView.imagesArr = [NSMutableArray new];
    
    _remindView.sd_layout
    .topSpaceToView(_addImageView, 0)
    .leftEqualToView(_mainScrollView)
    .rightEqualToView(_mainScrollView)
    .heightIs(74)
    ;
    _remindView.remindArr = [NSMutableArray new];
    
    @weakify(self);
    [_remindView whenTap:^{
        @strongify(self);
        [self setRemindPeoples];
    }];
    
    [_mainScrollView setupAutoContentSizeWithBottomView:_remindView bottomMargin:10];
    
    //键盘监听
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        @strongify(self);
        [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.view, nil];
    }];
    
    _addTitle = [UIButton new];
    _addTitle.backgroundColor = HexColor(#ECECEC);
    [_addTitle setBtnFont:PFFontL(15)];
    [_addTitle setNormalTitleColor:HexColor(#959595)];
    [self.view addSubview:_addTitle];
    _addTitle.sd_layout
    .leftSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 62 + BOTTOM_MARGIN)
    .widthIs(86)
    .heightIs(30)
    ;
    _addTitle.sd_cornerRadius = @15;
    [_addTitle setNormalTitle:@"添加标题"];
    [_addTitle addTarget:self action:@selector(addTitleAction:) forControlEvents:UIControlEventTouchUpInside];
}

//跳转设置需要@的人
-(void)setRemindPeoples
{
    RemindOthersToReadViewController *rotrVC = [RemindOthersToReadViewController new];
    
    rotrVC.selectedArr = self.remindView.remindArr.mutableCopy;
    
    @weakify(self);
    rotrVC.selectBlock = ^(NSMutableArray * _Nonnull selectArr) {
        GGLog(@"1级页面回调");
        @strongify(self);
        self.remindView.remindArr = selectArr.mutableCopy;
        
    };
    
    [self.navigationController pushViewController:rotrVC animated:YES];
}

//添加下方视图
-(void)setUpBottomView
{
    _bottomView = [UIView new];
    _bottomView.backgroundColor = WhiteColor;
    [self.view addSubview:_bottomView];
    _bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    .heightIs(50 + BOTTOM_MARGIN)
    ;
    
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
    .topSpaceToView(_bottomView, 13)
    .widthIs(26)
    .heightIs(24)
    ;
    [_showKeyboard setNormalImage:UIImageNamed(@"showKeyboard_icon")];
    [_showKeyboard setSelectedImage:UIImageNamed(@"hiddenKeyboard_icon")];
    [_showKeyboard addTarget:self action:@selector(showOrHideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
}

//切换emoji键盘或系统键盘
-(void)changeKeyboardType
{
    self.emojiKeyboard.selected = !self.emojiKeyboard.selected;
    YXTextView *textView;
    _emojiKeyboard.hidden = NO;
    if (self.emojiKeyboard.selected) {
        //替换emoji键盘
        if (self.addTitle.hidden) { //说明标题存在
            //先判断谁是第一响应者
            if (self.contentView.isFirstResponder) {
                textView = self.contentView;
            }else{
                textView = self.titleView;
                self.emojiKeyboard.selected = !self.emojiKeyboard.selected;
                textView.inputView = nil;
                [textView reloadInputViews];
                [textView becomeFirstResponder];
                return;
            }
        }else{
            textView = self.contentView;
        }
        textView.inputView = self.emoticonInputView;
        
    }else{
        //换回系统键盘
        if (self.addTitle.hidden) { //说明标题存在
            //先判断谁是第一响应者
            if (self.contentView.isFirstResponder) {
                textView = self.contentView;
            }else{
                textView = self.titleView;
                _emojiKeyboard.hidden = YES;
            }
        }else{
            textView = self.contentView;
        }
        textView.inputView = nil;
        
    }
    
    [textView reloadInputViews];

    if (!textView.isFirstResponder) {
        [textView becomeFirstResponder];
    }
}

//显示添加标题点击事件
-(void)addTitleAction:(UIButton *)sender
{
    sender.hidden = YES;
    _titleView.sd_resetLayout
    .leftEqualToView(_mainScrollView)
    .topEqualToView(_mainScrollView)
    .rightEqualToView(_mainScrollView)
    .heightIs(90)
    ;
}

//显隐键盘
-(void)showOrHideKeyboard:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //如果已经弹出了
    if (sender.selected) {
        //没有弹出则弹出
        if (self.addTitle.hidden) { //说明标题存在
            _emojiKeyboard.hidden = YES;
            [self.titleView becomeFirstResponder];
        }else{
            _emojiKeyboard.hidden = NO;
            [self.contentView becomeFirstResponder];
        }
        [self.mainScrollView scrollToTopAnimated:YES];
    }else{
        [self.view endEditing:YES];
    }
}

-(void)keyboardWillShowChangeFrameNotification:(NSNotification *)note{
    
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //取得键盘最后的frame(根据userInfo的key----UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";)
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.size.height;
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        //平移
        self.bottomView.frame = CGRectMake(0, ScreenH - transformY-(50 + BOTTOM_MARGIN) - NAVI_HEIGHT, ScreenW, (50 + BOTTOM_MARGIN));
    }];
}

-(void)keyboardWillHideChangeFrameNotification:(NSNotification *)note{
    
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        //平移
        self.bottomView.frame = CGRectMake(0, ScreenH - (50 + BOTTOM_MARGIN) - NAVI_HEIGHT, ScreenW, (50 + BOTTOM_MARGIN));
    }];
}

#pragma mark --- EmotionKeyBoardDelegate ---
- (void)clickEmotionName:(NSString *)name
{
    NSString *emotionString = [[WTUtils getEmoticonData] allKeysForObject:name][0];
    YXTextView *textView;
    if (self.titleView.isFirstResponder) {
        textView = self.titleView;
    }else{
        textView = self.contentView;
    }
    [textView replaceRange:textView.selectedTextRange withText:emotionString];
}

- (void)clickDelete
{
    YXTextView *textView;
    if (self.titleView.isFirstResponder) {
        textView = self.titleView;
    }else{
        textView = self.contentView;
    }
    [textView deleteBackward];
}

#pragma mark --- YYTextViewDelegate ---
-(BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    return YES;
}

-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //禁止标题输入换行
    if (textView == _titleView&&[text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(YYTextView *)textView
{
    if (textView == _titleView) {
        if (textView.text.length>25) {
            LRToast(@"标题长度不可超过25个字符哦");
            textView.text = [textView.text substringToIndex:25];
        }
        self.postModel.postTitle = [textView.text removeSpace];
    }else if (textView == _contentView){
        self.postModel.postContent = [textView.text removeSpace];
    }
}

-(void)textViewDidBeginEditing:(YYTextView *)textView
{
    GGLog(@"已经开始编辑");
    if (textView == self.titleView) {
        _emojiKeyboard.hidden = YES;
    }else{
        _emojiKeyboard.hidden = NO;
    }
    self.showKeyboard.selected = YES;
}

-(void)textViewDidEndEditing:(YYTextView *)textView
{
    GGLog(@"已经结束编辑");
    self.showKeyboard.selected = NO;
    self.emojiKeyboard.selected = NO;
    _emojiKeyboard.hidden = NO;
    textView.inputView = nil;
    
}



@end
