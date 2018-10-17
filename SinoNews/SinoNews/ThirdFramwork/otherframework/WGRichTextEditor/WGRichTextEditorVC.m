//
//  WGRichTextEditorVC.m
//  SinoNews
//
//  Created by Michael on 2018/10/17.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "WGRichTextEditorVC.h"
#import "NewPublishModel.h"
#import "YBPopupMenu.h"

#import "WGCommon.h"
#import "HXPhotoPicker.h"
#import "HXAlbumListViewController.h"

NSString *const kEditorURL = @"richText_editor";
NSString *const kEditorURL_noTitle = @"richText_editor_noTitle";

@interface WGRichTextEditorVC ()<UITextViewDelegate,UIWebViewDelegate,KWEditorBarDelegate,HXAlbumListViewControllerDelegate,UIAlertViewDelegate,YBPopupMenuDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) KWEditorBar *toolBarView;
@property (nonatomic,strong) HXPhotoManager *manager;

@end

@implementation WGRichTextEditorVC
- (KWEditorBar *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [KWEditorBar editorBar];
        _toolBarView.frame = CGRectMake(0,self.view.frame.size.height - KWEditorBar_Height, self.view.frame.size.width, KWEditorBar_Height);
        _toolBarView.backgroundColor = COLOR(237, 237, 237, 1);
        if (_hiddenSettingBtn) {
            [_toolBarView.keyboardButton setHidden:YES];
        }
    }
    return _toolBarView;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString *resource = kEditorURL;
        if (self.hiddenTitle) {
            resource = kEditorURL_noTitle;
        }
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:resource                                                              ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [_webView loadHTMLString:htmlCont baseURL:baseURL];
        _webView.scrollView.bounces=NO;
        _webView.hidesInputAccessoryView = YES;
        //        _webView.detectsPhoneNumbers = NO;
        
    }
    return _webView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolBarView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.toolBarView.delegate = self;
    
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.webView.frame = CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height - KWEditorBar_Height);
}

-(NSString *)getTitle
{
    return [self.webView titleText];
}

-(NSString *)contentNoH5
{
    return [self.webView contentText];
}

-(NSString *)contentH5
{
    return [self.webView contentHtmlText];
}

#pragma mark -webviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    NSString *draft = self.draftModel.content;
    if (!kStringIsEmpty(draft)) {
        [webView setupTitle:self.draftModel.title];
        [webView setupContent:draft];
        [webView clearContentPlaceholder];
    }
    
    if (_hiddenTitle) {
        [webView showKeyboardContent];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"NSError = %@",error);
    
    if([error code] == NSURLErrorCancelled){
        return;
    }
}

//获取IMG标签
-(NSArray*)getImgTags:(NSString *)htmlText
{
    if (htmlText == nil) {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length])];
    
    return arrayOfAllMatches;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"loadURL = %@",urlString);
    
    [self handleEvent:urlString];
    
    if ([urlString rangeOfString:@"re-state-content://"].location != NSNotFound) {
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"re-state-content://" withString:@""];
        
        if ([self.webView contentText].length <= 0) {
            [self.webView showContentPlaceholder];
            if ([self getImgTags:[self.webView contentHtmlText]].count > 0) {
                [self.webView clearContentPlaceholder];
            }
        }else{
            [self.webView clearContentPlaceholder];
        }
        
        if ([[className componentsSeparatedByString:@","] containsObject:@"unorderedList"]) {
            [self.webView clearContentPlaceholder];
        }
        
        
    }
    
    return YES;
}

#pragma mar - webView监听处理事件
- (void)handleEvent:(NSString *)urlString{
    if ([urlString hasPrefix:@"re-state-content://"]) {
        
        self.toolBarView.hidden = NO;
        if ([self.webView contentText].length <= 0) {
            //            [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        //        else{
        //            [self.webView autoScrollTop:[self.webView getCaretYPosition]];
        //        }
    }
    
    if ([urlString hasPrefix:@"re-state-title://"]) {
        self.toolBarView.hidden = YES;
    }
    
}

//是否显示占位文字
- (void)isShowPlaceholder{
    if ([self.webView contentText].length <= 0)
    {
        [self.webView showContentPlaceholder];
    }else{
        [self.webView clearContentPlaceholder];
    }
}

#pragma mark -editorbarDelegate
- (void)editorBar:(KWEditorBar *)editorBar didClickIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //插入图片
//            if (!self.toolBarView.keyboardButton.selected) {
//                [self.webView showKeyboardContent];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self showPhotos];
//                });
//            }else{
//                [self showPhotos];
//            }
            
            [self openPhoto];
            
        }
            break;
        case 1:{
            //加粗
            [self.webView bold];
            
        }
            break;
        case 2:{
            //回退
            [self.webView undo];
            [self isShowPlaceholder];
        }
            break;
        case 3:{
            //撤销
            [self.webView redo];
            [self isShowPlaceholder];
        }
            break;
            
        case 4:{
            //设置
            [self.webView hiddenKeyboard];
            [YBPopupMenu showRelyOnView:self.toolBarView.keyboardButton titles:@[@"保存草稿",@"放弃编辑"] icons:@[@"publish_save",@"publish_delete"] menuWidth:180 delegate:self];
        }
            break;
        default:
            break;
    }
    
}

//打开相册，选择图片后上传
-(void)openPhoto
{
    @weakify(self);
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        @strongify(self)
        
        GCDAfterTime(0.5, ^{
            
            //上传至服务器
            [RequestGather uploadSingleImage:(UIImage *)data Success:^(id response) {
                //上传成功
                NSString *imgUrlStr = response[@"data"];
                GCDAsynMain(^{
                    //插入图片
                    [self.webView insertImageUrl:imgUrlStr alt:@""];
                });
                
            } failure:nil];
            
        });
        
    }];
    
}

#pragma mark -keyboard
- (void)keyBoardWillChangeFrame:(NSNotification*)notification{
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.frame = CGRectMake(0,self.view.frame.size.height - KWEditorBar_Height, self.view.frame.size.width, KWEditorBar_Height);
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.frame = CGRectMake(0,self.view.frame.size.height - KWEditorBar_Height - frame.size.height, self.view.frame.size.width, KWEditorBar_Height);
        }];
    }
}


#pragma mark -上传图片
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    
    [self.manager clearSelectedList];
    
    if (photoList.count > 0) {
        for (int i = 0; i<photoList.count; i++) {
            
            HXPhotoModel *picM = photoList[i];
            WGUploadPictureModel *uploadM = [[WGUploadPictureModel alloc] init];
            uploadM.image = picM.thumbPhoto;
            uploadM.key = [NSString uuid];
            uploadM.imageData = UIImageJPEGRepresentation(picM.thumbPhoto,0.8f);
            
            //上传至服务器
            [RequestGather uploadSingleImage:uploadM.image Success:^(id response) {
                //上传成功
                NSString *imgUrlStr = response[@"data"];
                //插入图片
                [self.webView insertImageUrl:imgUrlStr alt:@""];
                
            } failure:nil];
            
        }
        
    }
    
}

#pragma mark -图片选择器
- (void)showPhotos{
    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithRootViewController:vc];
    nav.supportRotation = self.manager.configuration.supportRotation;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.toolBarTitleColor = COLOR(33,189,109,1);
        //        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.photoMaxNum = 1;
        _manager.configuration.imageMaxSize = 5;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.rowCount = 4;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.supportRotation = NO;
        _manager.configuration.hideOriginalBtn = YES;
        _manager.configuration.navigationTitleColor = [UIColor blackColor];
        _manager.configuration.showDateSectionHeader =NO;
        _manager.configuration.singleSelected = YES;
    }
    return _manager;
}

#pragma mark --- YBPopupMenuDelegate
-(void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (self.selectedBlock) {
        self.selectedBlock(index);
    }
}

@end
