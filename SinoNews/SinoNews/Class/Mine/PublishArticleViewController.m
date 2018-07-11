//
//  PublishArticleViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishArticleViewController.h"

#import "LMWordViewController.h"
#import "LMWordView.h"
#import "LMTextHTMLParser.h"

@interface PublishArticleViewController ()
@property (nonatomic, strong) LMWordViewController *wordViewController;

//@property (nonatomic, strong) RichEditorView *editorView;
//@property (nonatomic, strong) KeyboardManager *keyboardManager;
@end

@implementation PublishArticleViewController
//-(RichEditorView *)editorView
//{
//    if (!_editorView) {
//        _editorView = [RichEditorView new];
//        _editorView.backgroundColor = YellowColor;
//        [self.view addSubview:_editorView];
//        _editorView.sd_layout
//        .topSpaceToView(self.view, 30)
//        .leftSpaceToView(self.view, 10)
//        .rightSpaceToView(self.view, 10)
//        .bottomSpaceToView(self.view, BOTTOM_MARGIN + 44)
//        ;
//    }
//    return _editorView;
//}

- (LMWordViewController *)wordViewController {
    
    if (!_wordViewController) {
        _wordViewController = [[LMWordViewController alloc] init];
    }
    return _wordViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"发布文章";
    [self setNavigation];
    [self setUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
//    [self.keyboardManager beginMonitoring];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
//    [self.keyboardManager stopMonitoring];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation
{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 40, 20);
    editBtn.titleLabel.font = PFFontL(15);
    [editBtn setNormalTitleColor:RGBA(18, 130, 238, 1)];
    [editBtn setNormalTitle:@"发布"];
    editBtn.layer.cornerRadius = 3;
    editBtn.layer.borderColor = RGBA(18, 130, 238, 1).CGColor;
    editBtn.layer.borderWidth = 1;
    [editBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
}

-(void)setUI
{
    [self addChildViewController:self.wordViewController];
    [self.view addSubview:self.wordViewController.view];
    self.wordViewController.textView.titleTextField.placeholder = @"请输入标题";
    self.wordViewController.textView.titleTextField.placeholder = @"请输入标题";
    self.wordViewController.view.frame = self.view.bounds;
}

-(void)setUI2
{
//    self.editorView.delegate = self;
//    self.editorView.placeholder = @"这里输入内容...";
    
//    self.keyboardManager = [[KeyboardManager alloc] initWithView:self.view];
//    self.keyboardManager.toolbar.editor = self.editorView;
//
//    self.keyboardManager.toolbar.delegate = self;
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
//    view.backgroundColor = RedColor;
//    self.editorView.inputAccessoryView = view;
}

-(void)publishAction:(UIButton *)sender
{
    if ([NSString isEmpty:self.wordViewController.textView.titleTextField.text]) {
        LRToast(@"请输入标题");
        return;
    }else if (self.wordViewController.textView.attributedText.length<=0){
        LRToast(@"还没编辑内容哟");
        return;
    }
    [self requestPublishArticleWithContent:[self. wordViewController exportHTML]];
//    [self requestPublishArticleWithContent:self.editorView.text];
}

//#pragma mark - RichEditorViewDelegate
//
//- (void)richEditor:(RichEditorView * __nonnull)editor contentDidChange:(NSString * __nonnull)content {
//
//    GGLog(@"content:%@",content);
//}

//插入图片
//-(void)richEditorToolbarInsertImage:(RichEditorToolbar *)toolbar
//{
//    //处理图片
//    [[ZZYPhotoHelper shareHelper] getPhotoWithResultBlock:^(id data) {
//        //压缩
////        NSData *imgData = [(UIImage *)data compressWithMaxLength:100 * 1024];
////        UIImage *img = [UIImage imageWithData:imgData];
//        //裁剪
//        UIImage *dataImg = (UIImage *)data;
//        CGFloat w = (ScreenW - 20);
//        CGFloat h = w*dataImg.size.height/ dataImg.size.width;
//        UIImage *img = [dataImg cutToSize:CGSizeMake(w, h)];
//        [RequestGather uploadSingleImage:img Success:^(id response) {
//            NSString *imgUrl = GetSaveString(response[@"data"]);
//            if (toolbar.editor) {
//                [toolbar.editor insertImage:imgUrl alt:@"Gravatar"];
//            }
//        } failure:nil];
//    }];
//}

#pragma make ----- 请求发送
-(void)requestPublishArticleWithContent:(NSString *)content
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    //所属频道需要自己提前保存
    parameters[@"title"] = self.wordViewController.textView.titleTextField.text;
    parameters[@"channelId"] = @(64);
    parameters[@"content"] = GetSaveString(content);
//    [HttpRequest postWithURLString:News_create parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:nil RefreshAction:nil];
}


@end
