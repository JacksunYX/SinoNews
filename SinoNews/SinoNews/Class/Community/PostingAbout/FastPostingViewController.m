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

@interface FastPostingViewController ()<UITextViewDelegate>
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) FSTextView *titleView;
@property (nonatomic,strong) FSTextView *contentView;
@property (nonatomic,strong) SelectImagesView *addImageView;
@property (nonatomic,strong) RemindOthersToReadView *remindView;
@property (nonatomic,strong) UIButton *addTitle;    //添加标题按钮
@property (nonatomic,strong) UIView *bottomView;    //下方视图
@property (nonatomic,strong) UIButton *showKeyboard;
@property (nonatomic,strong) UIButton *publishBtn;

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
    
    _titleView = [FSTextView textView];
    _titleView.font = PFFontR(20);
    _titleView.textColor = BlackColor;
    _titleView.delegate = self;
    
    _contentView = [FSTextView textView];
    _contentView.font = PFFontL(15);
    _contentView.textColor = BlackColor;
    _contentView.delegate = self;
    
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
    
    _titleView.placeholder = @"快来起个厉害的标题吧！";
    _titleView.placeholderColor = HexColor(#BAC3C7);
    _titleView.placeholderFont = PFFontR(20);
    // 限制输入最大字符数.
    _titleView.maxLength = 25;
    // 添加输入改变Block回调.
    @weakify(self);
    [_titleView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        @strongify(self);
        self.postModel.postTitle = textView.formatText;
    }];
    // 添加到达最大限制Block回调.
    [_titleView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
        LRToast(@"帖子标题最多支持25个字符");
    }];
    
    _contentView.sd_layout
    .topSpaceToView(_titleView, 1)
    .leftEqualToView(_mainScrollView)
    .rightEqualToView(_mainScrollView)
    .heightIs(200)
    ;
    _contentView.placeholder = @"分享观点，谈谈自己的看法，这就是一个任你发挥的平台...";
    _contentView.placeholderColor = HexColor(#B9C3C7);
    _contentView.placeholderFont = PFFontL(15);
    // 添加输入改变Block回调.
    [_contentView addTextDidChangeHandler:^(FSTextView *textView) {
        @strongify(self);
        // 文本改变后的相应操作.
        NSString *string = textView.formatText;
        if (string.length>0) {
            self.publishBtn.enabled = YES;
            [self.publishBtn setNormalTitleColor:HexColor(#1282EE)];
        }else{
            self.publishBtn.enabled = NO;
            [self.publishBtn setNormalTitleColor:HexColor(#959595)];
        }
        self.postModel.postContent = textView.formatText;
    }];
    _contentView.borderColor = HexColor(#E3E3E3);
    _contentView.borderWidth = 1;
    
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
    [self.view whenTap:^{
        @strongify(self);
        [self.view endEditing:YES];
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
    
    UIButton *emojiKeyboard = [UIButton new];
    _showKeyboard = [UIButton new];
    
    [_bottomView sd_addSubviews:@[
                                  emojiKeyboard,
                                  _showKeyboard,
                                  ]];
    emojiKeyboard.sd_layout
    .leftSpaceToView(_bottomView, 15)
    .topSpaceToView(_bottomView, 14)
    .widthIs(23)
    .heightEqualToWidth()
    ;
    [emojiKeyboard setNormalImage:UIImageNamed(@"emojiKeyBoard_icon")];
    
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
            [self.titleView becomeFirstResponder];
        }else{
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

#pragma mark --- UITextViewDelegate ---
//有可能是点击输入框弹起的键盘,需要手动修改按钮状态
-(void)textViewDidBeginEditing:(UITextView *)textView
{
//    GGLog(@"已经开始编辑");
    self.showKeyboard.selected = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
//    GGLog(@"已经结束编辑");
    self.showKeyboard.selected = NO;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //禁止标题输入换行
    if (textView == _titleView&&[text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

@end
