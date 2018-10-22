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
@property (nonatomic,assign) BOOL disableEdit;  //是否无法编辑
@property (nonatomic, strong) NewPublishModel *draftModel;

@property (nonatomic,copy) void(^selectedBlock)(NSInteger index);
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSString *content;

-(NSString *)getTitle;      //获取标题
-(NSString *)contentNoH5;   //无标签的内容
-(NSString *)contentH5;     //有标签的内容

@end

NS_ASSUME_NONNULL_END
