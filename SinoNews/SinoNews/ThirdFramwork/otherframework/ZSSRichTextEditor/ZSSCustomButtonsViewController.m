//
//  ZSSCustomButtonsViewController.m
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 8/14/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import "ZSSCustomButtonsViewController.h"
#import "ZSSBarButtonItem.h"

@interface ZSSCustomButtonsViewController ()

@end

@implementation ZSSCustomButtonsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                action:@selector(setBold)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *undoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [undoBtn setImage:[UIImage imageNamed:@"ZSSundo"] forState:UIControlStateNormal];
    [undoBtn addTarget:self
                action:@selector(undo)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *redoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [redoBtn setImage:[UIImage imageNamed:@"ZSSredo"] forState:UIControlStateNormal];
    [redoBtn addTarget:self
                action:@selector(redo)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.0f, btnW, 49.0f)];
    [settingBtn setImage:[UIImage imageNamed:@"ZSSkeyboard"] forState:UIControlStateNormal];
//    [settingBtn addTarget:self
//                action:@selector(setBold)
//      forControlEvents:UIControlEventTouchUpInside];
    
//    insertImageBtn.backgroundColor = [UIColor redColor];
//    boldBtn.backgroundColor = [UIColor orangeColor];
//    undoBtn.backgroundColor = [UIColor yellowColor];
//    redoBtn.backgroundColor = [UIColor greenColor];
//    settingBtn.backgroundColor = [UIColor greenColor];
    
    insertImageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2 - 15, 0, 0);
    boldBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2+10 , 0, 0);
    undoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2+10 , 0, 0);
    redoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -btnW/2+10 , 0, 0);
    settingBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    
    [self addCustomToolbarItemWithButton:insertImageBtn];
    [self addCustomToolbarItemWithButton:boldBtn];
    [self addCustomToolbarItemWithButton:undoBtn];
    [self addCustomToolbarItemWithButton:redoBtn];
    [self addCustomToolbarItemWithButton:settingBtn];
    
}

//重写父类的方法
-(void)insertImage
{
    [self prepareInsert];
    //这里可以把本地图片传到服务器后拿到链接后再在当前界面显示
    [self insertImage:@"http://192.168.2.142:8087/pic/editor/9153a26f-0be9-4aa8-9c92-d2295d49e2c9.png" alt:@"width:100%;height:100%;"];
    [self focusTextEditor];
    
}


- (void)didTapCustomToolbarButton:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Custom Button!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:nil];
    [alertView show];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
