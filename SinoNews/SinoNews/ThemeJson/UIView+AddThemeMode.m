//
//  UIView+AddThemeMode.m
//  SinoNews
//
//  Created by Michael on 2018/7/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UIView+AddThemeMode.h"

@implementation UIView (AddThemeMode)

//添加背景颜色主题
-(void)addBakcgroundColorTheme
{
    self.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
}

//添加标题颜色主题
-(void)addTitleColorTheme
{
    self.lee_theme.LeeConfigTextColor(@"titleColor");
}

//添加内容颜色主题
-(void)addContentColorTheme
{
    self.lee_theme.LeeConfigTextColor(@"contentColor");
}

//添加按钮label字体颜色主题
-(void)addButtonTextColorTheme
{
    self.lee_theme.LeeConfigButtonTitleColor(@"titleColor", UIControlStateNormal);
}

//添加按钮normal模式的图片
-(void)addButtonNormalImage:(NSString *)identify
{
    self.lee_theme.LeeConfigButtonImage(identify, UIControlStateNormal);
}

//添加按钮selected模式的图片
-(void)addButtonSelectedImage:(NSString *)identify
{
    self.lee_theme.LeeConfigButtonImage(identify, UIControlStateSelected);
}

//添加分割线颜色
-(void)addCutLineColor
{
    self.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:CutLineColorNight];
        }else{
            [(UIView *)item setBackgroundColor:CutLineColor];
        }
    });
}


@end
