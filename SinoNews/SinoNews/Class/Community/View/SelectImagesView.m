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

@end

@implementation SelectImagesView

-(instancetype)init
{
    if (self == [super init]) {
        _numPerRow = 3;
        _maxNum = 9;
        _imagesArr = [NSMutableArray new];
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
            UIImageView *delete = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.width - 8, -8, 16, 16)];
            delete.userInteractionEnabled = YES;
            delete.image = UIImageNamed(@"deleteSelectedImage_icon");
            [imageView addSubview:delete];
            
            SelectImageModel *photoModel = copyArr[i];
            imageView.image = photoModel.image;
            if (photoModel.isUploaded) {
                imageView.status = UploadSuccess;
            }else{
                imageView.status = Uploading;
                
                if (photoModel.asset) {
                    GGLog(@"上传视频");
                    imageView.status = UploadSuccess;
                    photoModel.isUploaded = YES;
                }else{
                    GGLog(@"上传图片");
                    //上传过程
                    [RequestGather uploadSingleImage:photoModel.image Success:^(id response) {
                        //上传成功
                        imageView.status = UploadSuccess;
                        photoModel.isUploaded = YES;
                    } failure:^(NSError *error) {
                        //上传失败
                        imageView.status = UploadFailure;
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
        NSString *noticeStr = @"确认删除图片";
        if (model.asset) {
            noticeStr = @"确认删除视频";
        }
        UIAlertController *popNotice = [UIAlertController alertControllerWithTitle:noticeStr message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.imagesArr removeObject:model];
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
        photoModel.isUploaded = NO;
        [_imagesArr addObject:photoModel];
    }
    [self setUI];
}

//选择视频后会进入该代理方法，返回了封面和视频资源文件
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset
{
    SelectImageModel *photoModel = [SelectImageModel new];
    photoModel.image = coverImage;
    photoModel.asset = asset;
    photoModel.isUploaded = NO;
    [_imagesArr addObject:photoModel];
    [self setUI];
}

@end
