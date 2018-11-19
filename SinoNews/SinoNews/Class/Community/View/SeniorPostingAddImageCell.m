//
//  SeniorPostingAddImageCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingAddImageCell.h"

NSString * const SeniorPostingAddImageCellID = @"SeniorPostingAddImageCellID";
@interface SeniorPostingAddImageCell ()
{
    UIImageView *selectImage;
    UIButton *uploadStatus;
    YXLabel *imageDescript;
    //排序视图
    UIView *sortBackView;
    UIImageView *goUpTouch;
    UIImageView *goDownTouch;
    UIImageView *deleteTouch;
}
@end

@implementation SeniorPostingAddImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
        [self addSortView];
    }
    return self;
}

-(void)setUI
{
    selectImage = [UIImageView new];
    uploadStatus = [UIButton new];
    imageDescript = [YXLabel new];
    imageDescript.textVerticalAlignment = YYTextVerticalAlignmentTop;
    imageDescript.numberOfLines = 0;
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 selectImage,
                                 imageDescript,
                                 ]];
    selectImage.sd_layout
    .topSpaceToView(fatherView, 15)
    .leftSpaceToView(fatherView, 10)
    .widthIs(105)
    .heightEqualToWidth()
    ;
    selectImage.backgroundColor = Arc4randomColor;
    
    imageDescript.sd_layout
    .topEqualToView(selectImage)
    .leftSpaceToView(selectImage, 10)
    .rightSpaceToView(fatherView, 10)
    .bottomEqualToView(selectImage)
    ;
    
    imageDescript.textColor = HexColor(#161A24);
    imageDescript.font = PFFontR(15);
    imageDescript.userInteractionEnabled = NO;
    
    [selectImage addSubview:uploadStatus];
    uploadStatus.sd_layout
    .bottomEqualToView(selectImage)
    .leftEqualToView(selectImage)
    .rightEqualToView(selectImage)
    .heightIs(20)
    ;
    [uploadStatus setBtnFont:PFFontL(12)];
    [uploadStatus setNormalTitleColor:WhiteColor];
    [uploadStatus setSelectedTitleColor:WhiteColor];
    [uploadStatus setNormalTitle:@"正在上传"];
    [uploadStatus setSelectedTitle:@"上传成功"];
    [uploadStatus setNormalImage:nil];
    [uploadStatus setSelectedImage:UIImageNamed(@"uploadSuccess_icon")];
    [uploadStatus setBackgroundImage:[UIImage imageWithColor:HexColorAlpha(#000000, 0.36)] forState:UIControlStateNormal];
    [uploadStatus setBackgroundImage:[UIImage imageWithColor:HexColor(#1282EE)] forState:UIControlStateSelected];
    
    [self setupAutoHeightWithBottomView:selectImage bottomMargin:15];
}

//添加排序视图
-(void)addSortView
{
    sortBackView = [UIView new];
    [self.contentView addSubview:sortBackView];
    sortBackView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    //添加上升、删除、下降
    goUpTouch = UIImageView.new;
    goDownTouch = UIImageView.new;
    deleteTouch = UIImageView.new;
    
    [sortBackView sd_addSubviews:@[
                                   deleteTouch,
                                   goUpTouch,
                                   goDownTouch,
                                   ]];
    deleteTouch.sd_layout
    .centerXEqualToView(sortBackView)
    .centerYEqualToView(sortBackView)
    .widthIs(42)
    .heightEqualToWidth()
    ;
    deleteTouch.image = UIImageNamed(@"sortContent_delete");
    
    goUpTouch.sd_layout
    .centerYEqualToView(deleteTouch)
    .rightSpaceToView(deleteTouch, 40)
    .widthRatioToView(deleteTouch, 1)
    .heightEqualToWidth()
    ;
    goUpTouch.image = UIImageNamed(@"sortContent_up");
    
    goDownTouch.sd_layout
    .centerYEqualToView(deleteTouch)
    .leftSpaceToView(deleteTouch, 40)
    .widthRatioToView(deleteTouch, 1)
    .heightEqualToWidth()
    ;
    goDownTouch.image = UIImageNamed(@"sortContent_down");
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    sortBackView.hidden = !model.isSort;
    if (model.isSort) {
        @weakify(self);
        [sortBackView whenTap:^{
            
        }];
        //排序操作
        [deleteTouch whenTap:^{
            @strongify(self);
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        }];
        [goUpTouch whenTap:^{
            @strongify(self);
            if (self.goUpBlock) {
                self.goUpBlock();
            }
        }];
        [goDownTouch whenTap:^{
            @strongify(self);
            if (self.goDownBlock) {
                self.goDownBlock();
            }
        }];
        
    }else{
        sortBackView.gestureRecognizers = nil;
        deleteTouch.gestureRecognizers = nil;
        goUpTouch.gestureRecognizers = nil;
        goDownTouch.gestureRecognizers = nil;
    }
    
    selectImage.image = model.image;
    
    uploadStatus.backgroundColor = kWhite(0.36);
    uploadStatus.selected = NO;
    switch (model.imageStatus) {
        case ImageUploadSuccess:
        {
            uploadStatus.selected = YES;
            uploadStatus.backgroundColor = HexColor(#1282EE);
        }
            break;
        case ImageUploadFailure:
        {
            [uploadStatus setNormalTitle:@"上传失败"];
        }
            break;
            
        default:
        {
            //默认正在上传
            [uploadStatus setNormalTitle:@"正在上传"];
        }
            break;
    }
    
    NSString *text = GetSaveString(model.imageDes);
    if ([NSString isEmpty:text]) {
        imageDescript.text = @"给图片配点文案～";
        imageDescript.textColor = HexColor(#B9C3C7);
    }else{
        imageDescript.text = text;
        imageDescript.textColor = HexColor(#161A24);
    }
}

@end
