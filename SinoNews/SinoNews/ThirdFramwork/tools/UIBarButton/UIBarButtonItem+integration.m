//
//  UIBarButtonItem+integration.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UIBarButtonItem+integration.h"

@implementation UIBarButtonItem (integration)

+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title
{
    
    if (kStringIsEmpty(title)) {
        
        //设置图片
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //按钮点击事件
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
        btn.contentMode = 4;
        UIImage *backimg = [UIImage imageNamed:image];
        //如果图片宽度小于这个btn的宽度，就需要做缩进
        if (backimg.size.width<=40) {
//            CGFloat insetLeft = 20 - backimg.size.width/2;
            //当没有hlightimg时默认是右按钮，缩进相反,暂定
            if (!kStringIsEmpty(hightimage)) {
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
            }else{
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
            }
        }
        [btn setImage:backimg forState:UIControlStateNormal];
        [btn setImage:backimg forState:UIControlStateHighlighted];
        
        //设置尺寸
        btn.frame = CGRectMake(0, 0, 40, 40);
        
//        NSLog(@"w:%lf  h:%lf  ",btn.frame.size.width,btn.frame.size.height);
        return  [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        
    }else if (kStringIsEmpty(image)&&kStringIsEmpty(hightimage)){
        //只有文字的按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //按钮点击事件
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
        
        [btn.titleLabel setFont:PFFontL(16)];
        
        btn.frame = CGRectMake(0, 0, 40, 40);
        
        return  [[UIBarButtonItem alloc]initWithCustomView:btn];
        
    }else{
        //图片跟文字都存在
        //设置图片
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        //按钮点击事件
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:hightimage] forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn.titleLabel setFont:PFR15Font];
        //设置尺寸
        //btn.size=btn.currentBackgroundImage.size;
        
        btn.frame = CGRectMake(0, 0, 80, 40);
        
        //影响按钮内的titleLable;
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 0);
        //影响按钮内部imageView
        btn.imageEdgeInsets=UIEdgeInsetsMake(10, 0, 10, 50);
        
        //    // 直接设置按钮的图片和文字的布局样式以及之间的间隔
        //    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5.0];
        
        
        return  [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        
    }
    
    
}


+(UIBarButtonItem *)itemBottomWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title
{
    //设置图片
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    //按钮点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightimage] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGB(135, 135, 135) forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:PFR10Font];
    
    //设置尺寸
    //btn.size=btn.currentBackgroundImage.size;
    
    btn.frame = CGRectMake(0, 0, 30, 30);
    
    //    //影响按钮内的titleLable;
    //    btn.titleEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 0);
    //    //影响按钮内部imageView
    //    btn.imageEdgeInsets=UIEdgeInsetsMake(10, 0, 10, 50);
    
    // 直接设置按钮的图片和文字的布局样式以及之间的间隔
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5.0];
    
    return  [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}

@end
