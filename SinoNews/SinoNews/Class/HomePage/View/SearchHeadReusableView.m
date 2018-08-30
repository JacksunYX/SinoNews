//
//  SearchHeadReusableView.m
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SearchHeadReusableView.h"

@interface SearchHeadReusableView ()<STSegmentViewDelegate>
{
    UIView *selectView;
    UIImageView *img;
    UILabel *sectionTitle;
}
@property (nonatomic ,strong) STSegmentView *segmentView;
@end

@implementation SearchHeadReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
//        self.backgroundColor = WhiteColor;
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    selectView = [UIView new];
    img = [UIImageView new];
    sectionTitle = [UILabel new];
    sectionTitle.font = Font(16);
    sectionTitle.lee_theme.LeeConfigTextColor(@"titleColor");
    
    [self sd_addSubviews:@[
                           selectView,
                           img,
                           sectionTitle,
                           ]];
    selectView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(50)
    ;
    [selectView updateLayout];
    [selectView addBorderTo:BorderTypeBottom borderColor:CutLineColorNight];
    
    img.sd_layout
    .leftSpaceToView(self, 10)
    .bottomSpaceToView(self, 17)
    .widthIs(20)
    .heightEqualToWidth()
    ;
    
    sectionTitle.sd_layout
    .leftSpaceToView(img, 5)
    .centerYEqualToView(img)
    .autoHeightRatio(0)
    ;
    [sectionTitle setSingleLineAutoResizeWithMaxWidth:200];
    
    _segmentView = [[STSegmentView alloc]initWithFrame:CGRectMake(self.width/2 - 150, 0, 300, 50)];
    [_segmentView.selectedBgView addBakcgroundColorTheme];
    _segmentView.titleArray = @[@"文章",@"娱乐城",@"作者"];
    _segmentView.sliderColor = HexColor(#1282EE);
    _segmentView.titleSpacing = 50;
    _segmentView.sliderHeight = 2;
    _segmentView.labelFont = PFFontL(14);
    _segmentView.topLabelTextColor = HexColor(#1282EE);
    _segmentView.bottomLabelTextColor = HexColor(#888888);
    _segmentView.duration = 0.2;
    _segmentView.delegate = self;
    [selectView addSubview: _segmentView];
}

-(void)setTitle:(NSString *)title Icon:(NSString *)image
{
    sectionTitle.text = GetSaveString(title);
    img.image = UIImageNamed(image);
}

- (void)buttonClick:(NSInteger)index
{
    if (self.selectBlock) {
        self.selectBlock(index);
    }
}

//设置下标
-(void)setSelectedIndex:(NSInteger)index
{
    [_segmentView setButtonSelected:index];
}

@end
