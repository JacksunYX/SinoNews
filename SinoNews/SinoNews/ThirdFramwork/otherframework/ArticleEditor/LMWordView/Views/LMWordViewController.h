//
//  LMWordViewController.h
//  SimpleWord
//
//  Created by Chenly on 16/5/13.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMWordView;

@interface LMWordViewController : UIViewController

@property (nonatomic, strong) LMWordView *textView;

@property (nonatomic, assign) BOOL showTitle;   //是否显示title

- (NSString *)exportHTML;

@end
