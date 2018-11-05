//
//  SelectImagesView.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SelectImagesView.h"

@implementation SelectImageModel


@end

@interface SelectedImage ()
{
    UIImageView *imageV;
    UILabel *statusLabel;
}
@end

@implementation SelectedImage

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        imageV.userInteractionEnabled = YES;
        
        statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
        statusLabel.backgroundColor = HexColorAlpha(#000000, 0.36);
        statusLabel.textColor = WhiteColor;
        statusLabel.font = PFFontL(12);
        statusLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:imageV];
        [self addSubview:statusLabel];
        
        self.status = UploadingNone;
    }
    return self;
}

-(void)setStatus:(UploadStatus)status
{
    _status = status;
    statusLabel.hidden = NO;
    switch (status) {
        case UploadingNone:
        {
            statusLabel.hidden = YES;
            statusLabel.text = @"";
        }
            break;
        case Uploading:
        {
            statusLabel.text = @"正在上传";
        }
            break;
        case UploadSuccess:
        {
            statusLabel.text = @"上传成功";
        }
            break;
        case UploadFailure:
        {
            statusLabel.text = @"上传失败";
        }
            break;
            
        default:
            break;
    }
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    imageV.image = image;
}

@end


@interface SelectImagesView ()<TZImagePickerControllerDelegate>
//保存创建的图片视图
@property (nonatomic,strong) NSMutableArray *imageViewsArr;
@end

@implementation SelectImagesView

-(instancetype)init
{
    if (self == [super init]) {
        _numPerRow = 3;
        _maxNum = 9;
        _imagesArr = [NSMutableArray new];
        _imageViewsArr = [NSMutableArray new];
    }
    return self;
}

-(void)setImagesArr:(NSMutableArray *)imagesArr
{
    _imagesArr = [imagesArr mutableCopy];
    [self setUI];
}

-(void)setUI
{
    NSMutableArray *copyArr = [NSMutableArray arrayWithArray:_imagesArr];
    [copyArr addObject:@"addImageOrVedio_icon"];
    [self removeAllSubviews];
    [_imageViewsArr removeAllObjects];
    //平均宽高
    CGFloat wid = self.frame.size.width;
    CGFloat avgSpaceX = 10;
    CGFloat avgSpaceY = 10;
    CGFloat avgW = (wid - ((_numPerRow-1)*avgSpaceX))/_numPerRow;
    CGFloat avgH = avgW;
    CGFloat x = 0;
    CGFloat y = 0;
    UIView *lastView;
    for (int i = 0; i < copyArr.count; i ++) {
        CGFloat currentX = x;
        CGFloat currentY = y;
        
        SelectedImage *imageView = [[SelectedImage alloc]initWithFrame:CGRectMake(currentX, currentY, avgW, avgH)];
        
        imageView.tag = 10089 + i;
        [self addSubview:imageView];
        //设置图片
        if (i == copyArr.count - 1) {
            lastView = imageView;
            imageView.tag = 22222;
            imageView.image = UIImageNamed(GetSaveString(copyArr[i]));
        }else{
            [_imageViewsArr addObject:imageView];
            UIImageView *delete = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.width - 8, -8, 16, 16)];
            delete.userInteractionEnabled = YES;
            delete.image = UIImageNamed(@"deleteSelectedImage_icon");
            [imageView addSubview:delete];
            
            SelectImageModel *photoModel = copyArr[i];
            imageView.image = photoModel.image;
            //已经有上传操作了
            if (photoModel.status != UploadingNone) {
                imageView.status = photoModel.status;
            }else{
                
                imageView.status = Uploading;
                photoModel.status = Uploading;
                if (photoModel.videoData) {
                    GGLog(@"上传视频");
                    [RequestGather uploadVideo:photoModel.videoData Success:^(id response) {
                        //上传成功(这里取数组中保存的视图，是为了防止某些资源(比如视频)正在上传时，用户又添加了另外一个资源，此时如果不这么获取，原来的视图已经被移除，无法再修改其状态了)
                        SelectedImage *imageV = (SelectedImage *)self.imageViewsArr[i];
                        imageV.status = UploadSuccess;
                        photoModel.status = UploadSuccess;
                        photoModel.videoUrl = GetSaveString(response[@"data"]);
                    } failure:^(NSError *error) {
                        //上传失败
                        SelectedImage *imageV = (SelectedImage *)self.imageViewsArr[i];
                        imageV.status = UploadFailure;
                        photoModel.status = UploadFailure;
                    }];
                    
                }else{
                    GGLog(@"上传图片");
                    //上传过程
                    [RequestGather uploadSingleImage:photoModel.image Success:^(id response) {
                        //上传成功
                        SelectedImage *imageV = (SelectedImage *)self.imageViewsArr[i];
                        imageV.status = UploadSuccess;
                        photoModel.status = UploadSuccess;
                        photoModel.imageUrl = GetSaveString(response[@"data"]);
                    } failure:^(NSError *error) {
                        //上传失败
                        SelectedImage *imageV = (SelectedImage *)self.imageViewsArr[i];
                        imageV.status = UploadFailure;
                        photoModel.status = UploadFailure;
                    }];
                }
            }
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        tap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tap];
        
        NSInteger morethan = (i+1)%self.numPerRow;
        if (morethan==0) {
            //此时需要换行
            y += avgH + avgSpaceY;
        }
        
        x = (avgSpaceX+avgW)*morethan;
    }
    [self setupAutoHeightWithBottomView:lastView bottomMargin:10];
    [self.superview updateLayout];
}

-(void)click:(UIGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    if (tag == 22222) {
        //添加按钮
        UIAlertController *popNotice = [UIAlertController alertControllerWithTitle:@"选择添加的类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *selectVedio = [UIAlertAction actionWithTitle:@"选择视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkLocalVedio];
        }];
        UIAlertAction *selectPhoto = [UIAlertAction actionWithTitle:@"选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkLocalPhoto];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [popNotice addAction:cancel];
        [popNotice addAction:selectVedio];
        [popNotice addAction:selectPhoto];
        [[HttpRequest currentViewController] presentViewController:popNotice animated:YES completion:nil];
    }else{
        
        NSInteger index = tag - 10089;
        GGLog(@"点击了:%ld",index);
        SelectImageModel *model = self.imagesArr[index];
        if (model.status == Uploading) {
            LRToast(@"请等待上传完成");
            return;
        }
        NSString *noticeStr = @"确认删除图片";
        if (model.videoData) {
            noticeStr = @"确认删除视频";
        }
        UIAlertController *popNotice = [UIAlertController alertControllerWithTitle:noticeStr message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //从数组删除
            [self.imagesArr removeObjectAtIndex:index];
            [self.imageViewsArr removeObjectAtIndex:index];
            
            [self setUI];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
        [popNotice addAction:cancel];
        [popNotice addAction:confirm];
        [[HttpRequest currentViewController] presentViewController:popNotice animated:YES completion:nil];
    }
}

//选择图片
- (void)checkLocalPhoto{
    //最大数初始化为1，且不让允许选择图片时，就变成了单选视频了
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxNum delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingVideo = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
    
}

//选择视频
-(void)checkLocalVedio
{
    //最大数初始化为1，且不让允许选择图片时，就变成了单选视频了
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowTakePicture = NO;
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingImage = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark --- TZImagePickerControllerDelegate ---
//选择图片后会进入该代理方法，
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    for (UIImage *image in photos) {
        SelectImageModel *photoModel = [SelectImageModel new];
        photoModel.image = image;
        photoModel.status = UploadingNone;
        [_imagesArr addObject:photoModel];
    }
    [self setUI];
}

//选择视频后会进入该代理方法，返回了封面和视频资源文件
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset
{
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        GGLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
        NSURL *videoURL = [NSURL fileURLWithPath:outputPath];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        
        SelectImageModel *photoModel = [SelectImageModel new];
        photoModel.image = coverImage;
        photoModel.videoData = videoData;
        photoModel.status = UploadingNone;
        [self.imagesArr addObject:photoModel];
        [self setUI];
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    
}

@end
