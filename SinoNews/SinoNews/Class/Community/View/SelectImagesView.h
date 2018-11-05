//
//  SelectImagesView.h
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//
//自定义选择图片的视图

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface SelectImageModel : NSObject
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) PHAsset *asset;    //视频资源
@property (nonatomic,assign) BOOL isUploaded;   //是否已上传
@end

typedef enum : NSUInteger {
    UploadingNone = 0,
    Uploading,
    UploadSuccess,
    UploadFailure,
} UploadStatus;

@interface SelectedImage : UIView
@property (nonatomic,strong) UIImage * _Nullable image;
@property (nonatomic,assign) UploadStatus status;
@end

@interface SelectImagesView : UIView
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, assign) NSInteger numPerRow;  //每行个数
@property (nonatomic, assign) NSInteger maxNum;     //最多显示数目
@end

NS_ASSUME_NONNULL_END
