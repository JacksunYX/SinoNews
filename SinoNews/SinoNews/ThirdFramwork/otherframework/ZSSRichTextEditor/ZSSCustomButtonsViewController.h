//
//  ZSSCustomButtonsViewController.h
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 8/14/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import "ZSSRichTextEditor.h"

@interface ZSSCustomButtonsViewController : ZSSRichTextEditor

@property (nonatomic,copy) void(^selectedBlock)(NSInteger index);

-(void)canTouch:(BOOL)yesOrNo;

@property (nonatomic,assign) BOOL hiddenSettingBtn;   //是否隐藏设置按钮

@end
