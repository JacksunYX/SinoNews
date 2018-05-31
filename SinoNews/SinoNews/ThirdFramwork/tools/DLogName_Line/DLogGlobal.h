
//
//  DLogGlobal.h
//  DLogFileNameLine
//
//  Created by 云宝 Dean on 16/4/8.
//  Copyright © 2016年 云宝 Dean. All rights reserved.
//

//引用这个头文件就可以了

#ifndef DLogGlobal_h
#define DLogGlobal_h
#import "NSObject+DLClass.h"

//打印带文件名：行数

#define __DFILE__  ([[NSString stringWithFormat:@"%s",__FILE__] nsLogFileName]) //文件名

#define DLog(format, args...) (NSLog(@"[%@:%d行]: " format "\n", __DFILE__, __LINE__, ## args))

#endif /* DLogGlobal_h */


