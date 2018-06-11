//
//  AttentionRecommendSecondCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionRecommendSecondCell.h"
#import "AttentionCollectionView.h"

@interface AttentionRecommendSecondCell ()<AttentionDelegate>

@end

@implementation AttentionRecommendSecondCell

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
        [self setUI];
    }
    return self;
}


-(void)setUI
{
    AttentionCollectionView *attentionView = [[AttentionCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 205)];
    [attentionView registerViewClass:[UICollectionViewCell class] ID:@"Cell"];
    attentionView.delegate = self;
    [self.contentView addSubview:attentionView];
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
}

#pragma mark --- AttentionDelegate ---

-(NSInteger)numberOfItemsInSection
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)returnCollectionCellForIndexPath:(NSIndexPath *)indexpath collectionView:(UICollectionView *)collectionView
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexpath];
    cell.layer.cornerRadius = 9.0f;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = Arc4randomColor;
    return cell;
}

-(void)didSelected:(NSIndexPath *)indexPath
{
    if (self.selectedIndex) {
        self.selectedIndex(indexPath.row);
    }
}

@end
