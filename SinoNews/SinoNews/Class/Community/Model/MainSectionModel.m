//
//  MainSectionModel.m
//  SinoNews
//
//  Created by Michael on 2018/11/19.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "MainSectionModel.h"

@implementation MainSectionModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"subSections" : [MainSectionModel class],
             };
}

@end
