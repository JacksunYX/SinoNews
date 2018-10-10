//
//  GetImageSizeTool.m
//  SinoNews
//
//  Created by Michael on 2018/9/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#define dispatch_main_sync_safe

#import "GetImageSizeTool.h"

@implementation GetImageSizeTool

singleton_implementation(GetImageSizeTool)

+(CGSize)downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    
    if([imageURL isKindOfClass:[NSURL class]]){
        
        URL = imageURL;
        
    }
    
    if([imageURL isKindOfClass:[NSString class]]){
        
        URL = [NSURL URLWithString:imageURL];
        
    }
    
    if(URL == nil) {
        NSLog(@"网址有误!");
        return CGSizeZero;    // url为空则返回CGSizeZero
        
    }else{
        if ([URL.absoluteString containsString:@"@"]) {
            URL = [URL URLByAppendingPathComponent:@"@100p"];
        }
    }
    NSString* absoluteString = URL.absoluteString;
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:absoluteString]) {
//        
//        //将最终的自适应的高度 本地化处理
//        [[NSUserDefaults standardUserDefaults] setObject:@(13) forKey:absoluteString];
//    }
    
    //如果未使用SDWebImage，则忽略；检查是否缓存过该图片
    
#ifdef dispatch_main_sync_safe
    
    if([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:absoluteString])
        
    {
        
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        
        if(!image)
            
        {
            
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            
            image = [UIImage imageWithData:data];
            
        }
        
        if(image)
            
        {
            
            return image.size;
            
        }
        
    }
    
#endif
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    
    if([pathExtendsion isEqualToString:@"png"]){
        
        size =  [self getPNGImageSizeWithRequest:request];
        
    }
    
    else if([pathExtendsion isEqual:@"gif"])
        
    {
        
        size =  [self getGIFImageSizeWithRequest:request];
        
    }
    //jpg或jpeg
    else{
        
        size = [self getJPGImageSizeWithRequest:request];
        
    }
    
    if(CGSizeEqualToSize(CGSizeZero, size))
        
    {
        
        // 如果获取文件头信息失败,请求原图
        
//        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        NSData* data = [NSData dataWithContentsOfURL:URL];
        
        UIImage* image = [UIImage imageWithData:data];
        
        if(image)
            
        {
            
            //如果未使用SDWebImage，则忽略；缓存该图片
            
#ifdef dispatch_main_sync_safe
            
//            [[SDImageCache sharedImageCache] storeImage:image imageData:data forKey:absoluteString toDisk:YES completion:nil];
            [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:absoluteString];
#endif
            
            size = image.size;
            
        }
        
    }
    
    return size;
}

//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 8)
        
    {
        
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        
        long h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        
        return CGSizeMake(w, h);
        
    }
    
    return CGSizeZero;
    
}

//  获取GIF图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(data.length == 4)
        
    {
        
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        
        short w = w1 + (w2 << 8);
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        
        short h = h1 + (h2 << 8);
        
        return CGSizeMake(w, h);
        
    }
    
    return CGSizeZero;
    
}

//  获取JPG图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    if ([data length] <= 0x58) {
        
        return CGSizeZero;
        
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        
        short w1 = 0, w2 = 0;
        
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        
        short w = (w1 << 8) + w2;
        
        short h1 = 0, h2 = 0;
        
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        
        short h = (h1 << 8) + h2;
        
        return CGSizeMake(w, h);
        
    } else {
        
        short word = 0x0;
        
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        
        if (word == 0xdb) {
            
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            
            if (word == 0xdb) {// 两个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
                
            } else {// 一个DQT字段
                
                short w1 = 0, w2 = 0;
                
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                
                short w = (w1 << 8) + w2;
                
                short h1 = 0, h2 = 0;
                
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                
                short h = (h1 << 8) + h2;
                
                return CGSizeMake(w, h);
                
            }
            
        } else {
            
            return CGSizeZero;
            
        }
        
    }
    
}

@end
