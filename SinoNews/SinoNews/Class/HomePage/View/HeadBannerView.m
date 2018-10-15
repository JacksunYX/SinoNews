//
//  HeadBannerView.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HeadBannerView.h"
#import "NewPagedFlowView.h"
#import "PGCustomBannerView.h"
#import "LWDPageControl.h"
#import "HomePageBannerModel.h"

@interface HeadBannerView ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
//轮播图
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

//图片数组
@property (nonatomic, strong) NSMutableArray *imageArray;
//标题数组
@property (nonatomic, strong) NSMutableArray *titlesArray;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) LWDPageControl * pageControl;

@end

@implementation HeadBannerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
//        self.backgroundColor = WhiteColor;
        [self addBakcgroundColorTheme];
    }
    return self;
}

-(void)setupUIWithImageUrls:(NSArray *)imgs
{
    [self.imageArray addObjectsFromArray:imgs];
    [self setupUI];
}

-(void)setupUIWithModels:(NSArray <ADModel*> *)models
{
    for (int i = 0; i < models.count; i ++) {
        ADModel *model = models[i];
        [self.imageArray addObject:GetSaveString(model.url)];
        [self.titlesArray addObject:GetSaveString(model.name)];
    }
    [self setupUI];
}

-(void)setupUIWithModels2:(NSArray <HomePageBannerModel*> *)models
{
    self.modelArray = [models mutableCopy];
    for (int i = 0; i < models.count; i ++) {
        HomePageBannerModel *model = models[i];
        [self.imageArray addObject:GetSaveString(model.image)];
        [self.titlesArray addObject:GetSaveString(model.newsTitle)];
    }
    [self setupUI];
}

- (void)setupUI {
    
    CGFloat Width = self.frame.size.width;
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, Width,self.frame.size.height - 30)];
    [pageFlowView addBakcgroundColorTheme];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    
    //左右卡片间距30,底部对齐
    pageFlowView.leftRightMargin = 10;
    pageFlowView.topBottomMargin = 0;
    
    pageFlowView.orginPageCount = self.imageArray.count;

    [pageFlowView reloadData];
    [self addSubview:pageFlowView];
    
    //初始化pageControl
    _pageControl = [[LWDPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageFlowView.frame) + 10, Width, 10) indicatorMargin:5.f indicatorWidth:5.f currentIndicatorWidth:12.f indicatorHeight:5];
    _pageControl.numberOfPages = self.imageArray.count;
    
    [self addSubview:_pageControl];
    
    self.pageFlowView = pageFlowView;
    
}

#pragma mark --NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
//    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    if (self.selectBlock) {
        self.selectBlock(subIndex);
    }
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    _pageControl.currentPage = pageNumber;
}

//左右中间页显示大小为 Width - 50, (Width - 50) * 9 / 16
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    CGFloat Width = self.frame.size.width;
    if (self.type == NormalType) {
        return CGSizeMake(Width, self.frame.size.height - 15);
    }
    return CGSizeMake(Width - 30, self.frame.size.height - 15 - 10);
}

#pragma mark --NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGCustomBannerView *bannerView = (PGCustomBannerView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGCustomBannerView alloc] init];
//        bannerView.layer.cornerRadius = 0;
//        bannerView.layer.masksToBounds = YES;
    }
//    NSLog(@"图片地址:%@",self.imageArray[index]);
    //在这里下载网络图片
//    NSString *imgstr = [NSString stringWithFormat:@"%@%@",defaultUrl,self.imageArray[index]];
    [bannerView.mainImageView sd_setImageWithURL:UrlWithStr(self.imageArray[index]) placeholderImage:UIImageNamed(@"placeholder_logo_day")];
    
//    bannerView.mainImageView.image = UIImageNamed(self.imageArray[index]);
    bannerView.indexLabel.hidden = !self.showTitle;
    bannerView.indexLabelBackView.hidden = !self.showTitle;
    HomePageBannerModel *model = self.modelArray[index];
    bannerView.isTopic = model.topic;
    bannerView.indexLabel.text = self.titlesArray[index];
    
    return bannerView;
}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)titlesArray {
    if (_titlesArray == nil) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

@end
