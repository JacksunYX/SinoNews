//
//  WGRichTextEditorVC.h
//  SinoNews
//
//  Created by Michael on 2018/10/17.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NewPublishModel;
@interface WGRichTextEditorVC : UIViewController

@property (nonatomic,assign) BOOL hiddenTitle;    //是否显示标题
@property (nonatomic,assign) BOOL hiddenSettingBtn;
@property (nonatomic, strong) NewPublishModel *draftModel;

@property (nonatomic,copy) void(^selectedBlock)(NSInteger index);

-(NSString *)getTitle;      //获取标题
-(NSString *)contentNoH5;   //无标签的内容
-(NSString *)contentH5;     //有标签的内容

@end

NS_ASSUME_NONNULL_END
