//
//  PubLishChannelSelectVC.m
//  SinoNews
//
//  Created by Michael on 2018/8/6.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PubLishChannelSelectVC.h"
#import "XLChannelModel.h"
#import "PublishArticleViewController.h"


@interface PubLishChannelSelectVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *channelArr;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation PubLishChannelSelectVC
-(NSMutableArray *)channelArr
{
    if (!_channelArr) {
        _channelArr = [self getAllChannels];
    }
    return _channelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTopLine];
    self.navigationItem.title = @"频道";
    [self setUI];
}

-(void)setUI
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemW = (ScreenW - 10*2 - 25*2)/3;
    CGFloat itemH = itemW * 40 / 100;
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 20;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView addBakcgroundColorTheme];
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ChannelCellID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取本地保存的所有频道
-(NSMutableArray *)getAllChannels
{
    NSArray* columnArr = [NSArray bg_arrayWithName:@"columnArr"];
    NSMutableArray *totalArr = [NSMutableArray new];
    if (columnArr.count>0) {
        NSArray *arr1 = [NSMutableArray arrayWithArray:columnArr[0]];
        NSArray *arr2 = columnArr[1];
        totalArr = [[arr1 arrayByAddingObjectsFromArray:arr2] mutableCopy];
        for (XLChannelModel *channel in [arr1 arrayByAddingObjectsFromArray:arr2]) {
            //过滤掉最新和问答频道
            if (CompareString(channel.channelId, @"82")||CompareString(channel.channelName, @"最新")||CompareString(channel.channelName, @"问答")) {
                [totalArr removeObject:channel];
            }
        }
    }else{
        GGLog(@"无任何频道");
    }
    
    return totalArr;
}

#pragma mark ----- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChannelCellID" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.layer.borderColor = HexColor(#B9B9B9).CGColor;
    cell.layer.borderWidth = 1;
    if (cell.contentView.subviews.count) {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    UILabel *channelName = [UILabel new];
    [channelName addTitleColorTheme];
    channelName.textAlignment = NSTextAlignmentCenter;
    channelName.font = PFFontL(18);
    
    [cell.contentView addSubview:channelName];
    channelName.sd_layout
    .leftEqualToView(cell.contentView)
    .topEqualToView(cell.contentView)
    .rightEqualToView(cell.contentView)
    .bottomEqualToView(cell.contentView)
    ;
    XLChannelModel *model = self.channelArr[indexPath.row];
    channelName.text = GetSaveString(model.channelName);
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLChannelModel *model = self.channelArr[indexPath.row];
    PublishArticleViewController *paVC = [PublishArticleViewController new];
    paVC.channelId = model.channelId;
    @weakify(self);
    [self.rt_navigationController pushViewController:paVC animated:YES complete:^(BOOL finished) {
        @strongify(self);
        [self.rt_navigationController removeViewController:self];
    }];

}



@end
