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
    FSTextView *descrip = [FSTextView textView];
    [self.view sd_addSubviews:@[
                                descrip,
                                _videoView,
                                ]];
    descrip.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(100)
    ;
    [descrip updateLayout];
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
    
    _videoView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(descrip, 0)
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

@end
