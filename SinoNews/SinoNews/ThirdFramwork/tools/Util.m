//
//  Util.m
//  SinoNews
//
//  Created by Michael on 2018/9/3.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "Util.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIImageView+AFNetworking.h"

@implementation Util

+ (Util *)shareTool
{
    static Util *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[Util alloc] init];
    });
    return tool;
}


- (void)downloadImageWithUrl:(NSString *)src
{
    // 注意：这里并没有写专门下载图片的代码，就直接使用了AFN的扩展，只是为了省麻烦而已。
    UIImageView *imgView = [[UIImageView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
    
    [imgView setImageWithURLRequest:request
                   placeholderImage:nil
                            success:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, UIImage *_Nonnull image) {
                                NSData *data = UIImagePNGRepresentation(image);
                                NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                                NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
                                NSString *extension = [src pathExtension];
                                localPath = [localPath stringByAppendingString:[NSString stringWithFormat:@".%@", extension]];
                                
                                if (![data writeToFile:localPath atomically:NO])
                                {
                                    GGLog(@"写入本地失败：%@", src);
                                }
                                else
                                {
                                    
                                    [kNotificationCenter postNotificationName:kDownloadImageSuccessNotify object:localPath];
                                }
                            }
                            failure:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, NSError *_Nonnull error) {
                                GGLog(@"download image url fail: %@", src);
                            }];
    
//    if (self.imageViews == nil)
//    {
//        self.imageViews = [[NSMutableArray alloc] init];
//    }
//    [self.imageViews addObject:imgView];
}

- (NSString *)md5:(NSString *)sourceContent
{
    if (self == nil || [sourceContent length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

/**
 修改HTML里的<IMG src>
 
 @param urlStr 原始链接
 @return 修改之后的HTMLString
 */
+ (NSString *)changeImgSrc:(NSString *)urlStr
{
    NSString *htmlStr = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:nil];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:htmlStr options:NSMatchingReportCompletion range:NSMakeRange(0, htmlStr.length)];
    
    NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSTextCheckingResult *item = (NSTextCheckingResult *)obj;
        NSString *imgHtml = [htmlStr substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound)
        {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        }
        else if ([imgHtml rangeOfString:@"src="].location != NSNotFound)
        {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2)
        {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound)
            {
                src = [src substringToIndex:loc];
                
                GGLog(@"正确解析出来的SRC为：%@", src);
                if (src.length > 0)
                {
                    NSString *extension = [src pathExtension];
                    NSString *localPath = [docPath stringByAppendingPathComponent:[[self shareTool] md5:src]];
                    localPath = [localPath stringByAppendingString:[NSString stringWithFormat:@".%@", extension]];
                    localPath = [NSString stringWithFormat:@"�file://%@", localPath];
                    
                    // 先将链接取个本地名字，且获取完整路径
                    [urlDicts setObject:localPath forKey:src];
                }
            }
        }
    }];
    
    // 遍历所有的URL，替换成本地的URL，并异步获取图片
    for (NSString *src in urlDicts.allKeys)
    {
        NSString *localPath = [urlDicts objectForKey:src];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:src withString:localPath];
        
        localPath = [localPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        // 如果已经缓存过，就不需要重复加载了。
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
            
            [[self shareTool] downloadImageWithUrl:src];
        }
        
    }
    return htmlStr;
    
}



@end
