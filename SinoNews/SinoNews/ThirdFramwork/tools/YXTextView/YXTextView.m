//
//  YXTextView.m
//  SinoNews
//
//  Created by Michael on 2018/11/16.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "YXTextView.h"

@implementation YXTextView

-(instancetype)init
{
    if (self == [super init]) {
        //设置本地表情识别
        self.textParser = BrowsNewsSingleton.singleton.parser;
    }
    return self;
}

@end
