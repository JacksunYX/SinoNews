//
//  SeniorPostingAddVideoCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingAddVideoCell.h"

NSString * const SeniorPostingAddVideoCellID = @"SeniorPostingAddVideoCellID";

@interface SeniorPostingAddVideoCell ()
{
    UIImageView *selectVideo;
    UIButton *uploadStatus;
    YXLabel *videoDescript;
    //排序视图
    UIView *sortBackView;
    UIImageView *goUpTouch;
    UIImageView *goDownTouch;
    UIImageView *deleteTouch;
}
@end

@implementation SeniorPostingAddVideoCell

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
    selectVideo = [UIImageView new];
    UIImageView *videoIcon = [UIImageView new];
    uploadStatus = [UIButton new];
    videoDescript = [YXLabel new];
    videoDescript.textVerticalAlignment = YYTextVerticalAlignmentTop;
    videoDescript.numberOfLines = 0;
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 selectVideo,
                                 videoDescript,
                                 ]];
    selectVideo.sd_layout
    .topSpaceToView(fatherView, 15)
    .leftSpaceToView(fatherView, 10)
    .widthIs(105)
    .heightEqualToWidth()
    ;
    selectVideo.contentMode = UIViewContentModeScaleAspectFill;
    selectVideo.clipsToBounds = YES;
//    selectVideo.backgroundColor = Arc4randomColor;
    
    videoDescript.sd_layout
    .topEqualToView(selectVideo)
    .leftSpaceToView(selectVideo, 10)
    .rightSpaceToView(fatherView, 10)
    .bottomEqualToView(selectVideo)
    ;
    videoDescript.textColor = HexColor(#161A24);
    videoDescript.font = PFFontR(15);
    videoDescript.userInteractionEnabled = NO;
    
    [selectVideo addSubview:videoIcon];
    videoIcon.sd_layout
    .centerXEqualToView(selectVideo)
    .centerYEqualToView(selectVideo)
    .widthIs(42)
    .heightEqualToWidth()
    ;
//    videoIcon.backgroundColor = kWhite(0.4);
//    videoIcon.sd_cornerRadius = @21;
    videoIcon.image = UIImageNamed(@"videoCover_icon");
    
    
    [selectVideo addSubview:uploadStatus];
    uploadStatus.sd_layout
    .bottomEqualToView(selectVideo)
    .leftEqualToView(selectVideo)
    .rightEqualToView(selectVideo)
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
    
    [self setupAutoHeightWithBottomView:selectVideo bottomMargin:15];
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
    
    selectVideo.image = model.imageData.toImage;
    
    uploadStatus.backgroundColor = kWhite(0.36);
    uploadStatus.selected = NO;
    switch (model.videoStatus) {
        case VideoUploadSuccess:
        {
            uploadStatus.selected = YES;
            uploadStatus.backgroundColor = HexColor(#1282EE);
        }
            break;
        case VideoUploadFailure:
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
    
    NSString *text = GetSaveString(model.videoDes);
    if ([NSString isEmpty:text]) {
        videoDescript.text = @"给视频配点文案～";
        videoDescript.textColor = HexColor(#B9C3C7);
    }else{
        videoDescript.text = text;
        videoDescript.textColor = HexColor(#161A24);
    }
}

@end
