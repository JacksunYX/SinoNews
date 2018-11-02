//
//  SelectImagesView.m
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SelectImagesView.h"

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
    [_imagesArr addObject:@"addImageOrVedio_icon"];
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
    for (int i = 0; i < _imagesArr.count; i ++) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 10089 + i;
        [self addSubview:imageView];
        CGFloat currentX = x;
        CGFloat currentY = y;
//        GGLog(@"currentX:%lf\ncurrentY:%lf",currentX,currentY);
//        imageView.sd_layout
//        .leftSpaceToView(self, currentX)
//        .leftSpaceToView(self, currentY)
//        .widthIs(avgW)
//        .heightIs(avgH)
//        ;
//        [imageView updateLayout];
        imageView.frame = CGRectMake(currentX, currentY, avgW, avgH);
        
        if (i == _imagesArr.count - 1) {
            lastView = imageView;
            imageView.tag = 22222;
            imageView.image = UIImageNamed(GetSaveString(_imagesArr[i]));
        }else{
            imageView.image = _imagesArr[i];
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
        [self checkLocalPhoto];
    }else{
        GGLog(@"点击了:%ld",tap.view.tag - 10089);
    }
    
}

- (void)checkLocalPhoto{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxNum delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = NO;
//    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    [[HttpRequest currentViewController] presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark --- TZImagePickerControllerDelegate ---
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    _imagesArr = [photos mutableCopy];
    [self setUI];
}

@end
