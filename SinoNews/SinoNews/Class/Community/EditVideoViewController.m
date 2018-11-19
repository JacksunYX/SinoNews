//
//  EditVideoViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "EditVideoViewController.h"

@interface EditVideoViewController ()<EmotionKeyBoardDelegate,YYTextViewDelegate>
@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong) YXTextView *descrip;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *showKeyboard;
@property (nonatomic,strong) UIButton *emojiKeyboard;
//emoji键盘
@property (nonatomic,strong) WTEmoticonInputView *emoticonInputView;

@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIImageView *videoView;
@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;
@property (nonatomic,strong)AVPlayerLayer *avLayer;
@end

@implementation EditVideoViewController
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(WTEmoticonInputView *)emoticonInputView
{
    if (!_emoticonInputView) {
        _emoticonInputView = [[WTEmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kKeyBoardH)];
        _emoticonInputView.delegate = self;
    }
    return _emoticonInputView;
}

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
        
    }
    return _bottomView;
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
    _videoView = [UIImageView new];
    _videoView.userInteractionEnabled = YES;
    _videoView.backgroundColor = BlackColor;
    _descrip = [YXTextView new];
    [self.view sd_addSubviews:@[
                                _descrip,
                                _videoView,
                                ]];
    _descrip.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(100)
    ;
    [_descrip updateLayout];
    _descrip.inputAccessoryView = self.bottomView;
    _descrip.textColor = HexColor(#161A24);
    _descrip.font = PFFontR(15);
    _descrip.placeholderText = @"给视频配点文字吧";
    _descrip.placeholderTextColor = HexColor(#B9C3C7);
    
    _descrip.text = GetSaveString(self.model.videoDes);
    _descrip.delegate = self;
    
    _videoView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(_descrip, 0)
    ;
    [_videoView updateLayout];
    _videoView.image = self.model.image;
    _videoView.contentMode = 1;
    
    _playBtn = [UIButton new];
    [_videoView addSubview:_playBtn];
    _playBtn.sd_layout
    .centerXEqualToView(_videoView)
    .centerYEqualToView(_videoView)
    .widthIs(42)
    .heightEqualToWidth()
    ;

    [_playBtn setNormalImage:UIImageNamed(@"videoCover_icon")];
    [_playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
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

//播放视频
-(void)playAction
{
    
    //本地视频
    NSURL *localVideoUrl = [NSURL fileURLWithPath:self.model.videoUrl];
    //创建播放器
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:localVideoUrl];
    self.currentPlayerItem = playerItem;
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    //配置播放参数
    _avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _avLayer.frame = _videoView.bounds;
    [_videoView.layer addSublayer:_avLayer];
    //播放
    [self.player play];
    @weakify(self);
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        //当前播放的时间
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        //视频的总时间
        NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
        if (currentTime/totalTime>=1) {
            GGLog(@"播放完成");
            [self.avLayer removeFromSuperlayer];
        }
    }];
    
}

-(void)changeKeyboardType
{
    _emojiKeyboard.selected = !_emojiKeyboard.selected;
    if (_emojiKeyboard.selected) {
        self.descrip.inputView = self.emoticonInputView;
    }else{
        self.descrip.inputView = nil;
    }
    [self.descrip reloadInputViews];
}

//隐藏键盘
-(void)showOrHideKeyboard:(UIButton *)sender
{
    [self.view endEditing:YES];
}

#pragma mark --- EmotionKeyBoardDelegate ---
- (void)clickEmotionName:(NSString *)name
{
    NSString *emotionString = [[WTUtils getEmoticonData] allKeysForObject:name][0];
    YXTextView *textView = self.descrip;
    
    [textView replaceRange:textView.selectedTextRange withText:emotionString];
}

- (void)clickDelete
{
    YXTextView *textView = self.descrip;
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
    self.model.videoDes = string;
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
