//
//  ZSSCustomButtonsViewController.m
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 8/14/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import "ZSSCustomButtonsViewController.h"
#import "ZSSBarButtonItem.h"
#import "YBPopupMenu.h"

@interface ZSSCustomButtonsViewController ()<YBPopupMenuDelegate>
@property (nonatomic,assign) BOOL touch;    //是否可被点击
@end

@implementation ZSSCustomButtonsViewController
-(void)canTouch:(BOOL)yesOrNo
{
    _touch = yesOrNo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _touch = YES;
    
//    self.title = @"Custom Buttons";
    
    // HTML Content to set in the editor
//    NSString *html = @"<p>This editor is using <strong>custom buttons</strong>.</p>";
    
    // Set the HTML contents of the editor
//    [self setHTML:html];
    [self setPlaceholder:@"这里输入内容..."];
    self.alwaysShowToolbar = YES;
    // Don't allow editor toolbar buttons (you can if you want)
//    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarInsertImage,ZSSRichTextEditorToolbarBold,ZSSRichTextEditorToolbarUndo,ZSSRichTextEditorToolbarRedo];
    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarNone];
    
    [self setCustomBtns];
}

//自定义toolbar
-(void)setCustomBtns
{
    CGFloat btnW = self.view.bounds.size.width/5;
    // Create the custom buttons
    UIButton *insertImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [insertImageBtn setImage:[UIImage imageNamed:@"ZSSimage"] forState:UIControlStateNormal];
    [insertImageBtn addTarget:self
                       action:@selector(insertImage)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *boldBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [boldBtn setImage:[UIImage imageNamed:@"ZSSbold"] forState:UIControlStateNormal];
    [boldBtn addTarget:self
                action:@selector(locationBold)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *undoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [undoBtn setImage:[UIImage imageNamed:@"ZSSundo"] forState:UIControlStateNormal];
    [undoBtn addTarget:self
                action:@selector(locationUndo)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *redoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [redoBtn setImage:[UIImage imageNamed:@"ZSSredo"] forState:UIControlStateNormal];
    [redoBtn addTarget:self
                action:@selector(locationRedo)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [settingBtn setImage:[UIImage imageNamed:@"ZSSkeyboard"] forState:UIControlStateNormal];
    [settingBtn addTarget:self
                   action:@selector(popSelectView:)
      forControlEvents:UIControlEventTouchUpInside];
    
//    insertImageBtn.backgroundColor = [UIColor redColor];
//    boldBtn.backgroundColor = [UIColor orangeColor];
//    undoBtn.backgroundColor = [UIColor yellowColor];
//    redoBtn.backgroundColor = [UIColor greenColor];
//    settingBtn.backgroundColor = [UIColor greenColor];
    
    insertImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2 , 0, 0);
    boldBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2+10 , 0, 0);
    undoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2+15 , 0, 0);
    redoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2+15 , 0, 0);
    settingBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    
    [self addCustomToolbarItemWithButton:insertImageBtn];
    [self addCustomToolbarItemWithButton:boldBtn];
    [self addCustomToolbarItemWithButton:undoBtn];
    [self addCustomToolbarItemWithButton:redoBtn];
    [self addCustomToolbarItemWithButton:settingBtn];
    
}

//暂未使用
//打开相册，选择图片后上传
-(void)openPhoto
{
    if (_touch == NO) {
        return;
    }
    @weakify(self);
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        @strongify(self)
        
        GCDAfterTime(0.5, ^{
            
            //上传至服务器
            [RequestGather uploadSingleImage:(UIImage *)data Success:^(id response) {
                //上传成功
                NSString *imgUrlStr = response[@"data"];
                [self insertImageWithUrl:imgUrlStr];
                
            } failure:nil];
            
        });
        
    }];
}

//插入图片链接
-(void)insertImageWithUrl:(NSString *)url
{
    [self prepareInsert];
    //这里可以把本地图片传到服务器后拿到链接后再在当前界面显示
    [self insertImage:url alt:@""];
    [self focusTextEditor];
}

//bold
-(void)locationBold
{
    if (_touch == NO) {
        return;
    }
    [self setBold];
}

//undo
-(void)locationUndo
{
    if (_touch == NO) {
        return;
    }
    [self undo];
}

//redo
-(void)locationRedo
{
    if (_touch == NO) {
        return;
    }
    [self redo];
}

-(void)popSelectView:(UIButton *)sender
{
    if (_touch == NO) {
        return;
    }
    [self.view endEditing:YES];
    [YBPopupMenu showRelyOnView:sender titles:@[@"保存草稿",@"放弃编辑"] icons:@[@"publish_save",@"publish_delete"] menuWidth:180 delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- YBPopupMenuDelegate
-(void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (self.selectedBlock) {
        self.selectedBlock(index);
    }
}


@end
