//
//  AttentionRecommendSecondCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionRecommendSecondCell.h"
#import "AttentionCollectionView.h"
#import "RecommendSecondCell.h"

@interface AttentionRecommendSecondCell ()<AttentionDelegate>
@property (nonatomic,strong) AttentionCollectionView *attentionView;
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
    self.attentionView = [[AttentionCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 204)];
//    self.attentionView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
    [self.attentionView registerViewClass:[RecommendSecondCell class] ID:RecommendSecondCellID];
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
    return self.dataSource.count/3;
}

-(UICollectionViewCell *)returnCollectionCellForIndexPath:(NSIndexPath *)indexpath collectionView:(UICollectionView *)collectionView
{
    RecommendSecondCell *cell = (RecommendSecondCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RecommendSecondCellID forIndexPath:indexpath];
    cell.tag = indexpath.row;
    NSInteger first = indexpath.row * 3;
    NSInteger second = first + 1;
    NSInteger third = first + 2;
    
    NSArray *dataArr = @[
                         self.dataSource[first],
                         self.dataSource[second],
                         self.dataSource[third],
                         
                         ];
    
//    cell.model = self.dataSource[indexpath.row];
    cell.modelArr = dataArr;
    WEAK(weakSelf, self);
    //点击
    cell.selectedIndex = ^(NSInteger line, NSInteger row) {
        if (weakSelf.selectedIndex) {
            weakSelf.selectedIndex(line, row);
        }
    };
    //关注
    cell.attentionIndex = ^(NSInteger line, NSInteger row) {
        if (weakSelf.attentionBlock) {
            weakSelf.attentionBlock(line, row);
        }
    };
    return cell;
}

-(void)didSelected:(NSIndexPath *)indexPath
{
    
}

@end
