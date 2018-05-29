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

@interface HeadBannerView ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

//图片数组
@property (nonatomic, strong) NSMutableArray *imageArray;

//轮播图
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation HeadBannerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = RedColor;
    }
    return self;
}

-(void)setupUIWithImageUrls:(NSArray *)imgs
{
    [self.imageArray addObjectsFromArray:imgs];
    [self setupUI];
}

- (void)setupUI {
    
    CGFloat Width = self.frame.size.width;
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, Width, Width * 9 / 16)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    
    //左右卡片间距30,底部对齐
    pageFlowView.leftRightMargin = 10;
    pageFlowView.topBottomMargin = 0;
    
    pageFlowView.orginPageCount = self.imageArray.count;
    
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, Width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView reloadData];
    [self addSubview:pageFlowView];
    
    self.pageFlowView = pageFlowView;
    
}

#pragma mark --NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
//    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
//    NSLog(@"CustomViewController 滚动到了第%ld页",pageNumber);
}

//左右中间页显示大小为 Width - 50, (Width - 50) * 9 / 16
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    CGFloat Width = self.frame.size.width;
    return CGSizeMake(Width - 30, (Width - 30) * 9 / 16);
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
    //[bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,self.imageArray[index]]] placeholderImage:[UIImage imageNamed:@""]];

    bannerView.mainImageView.image = UIImageNamed(self.imageArray[index]);
//    bannerView.indexLabel.text = [NSString stringWithFormat:@"第%ld张图",(long)index + 1];
    return bannerView;
}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}



@end
