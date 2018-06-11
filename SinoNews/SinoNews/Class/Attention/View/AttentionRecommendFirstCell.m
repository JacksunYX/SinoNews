//
//  AttentionRecommendFirstCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionRecommendFirstCell.h"
#import "AttentionCollectionView.h"
#import "RecommendFirstCell.h"

@interface AttentionRecommendFirstCell ()<AttentionDelegate>
@property (nonatomic,strong) AttentionCollectionView *attentionView;
@end

@implementation AttentionRecommendFirstCell

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
    self.attentionView = [[AttentionCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 140)];
    [self.attentionView registerViewClass:[RecommendFirstCell class] ID:RecommendFirstCellID];
    self.attentionView.delegate = self;
    [self.contentView addSubview:self.attentionView];
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.attentionView reloadata];
}

#pragma mark --- AttentionDelegate ---

-(NSInteger)numberOfItemsInSection
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)returnCollectionCellForIndexPath:(NSIndexPath *)indexpath collectionView:(UICollectionView *)collectionView
{
    RecommendFirstCell *cell = (RecommendFirstCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RecommendFirstCellID forIndexPath:indexpath];
    cell.tag = indexpath.row;
    cell.model = self.dataSource[indexpath.row];
    
    WEAK(weakSelf, self);
    cell.attentionIndex = ^(NSInteger row) {
        if (weakSelf.attentionIndex) {
            weakSelf.attentionIndex(row);
        }
    };
    
    return cell;
}

-(void)didSelected:(NSIndexPath *)indexPath
{
    if (self.selectedIndex) {
        self.selectedIndex(indexPath.row);
    }
}



@end
