//
//  XLChannelView.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelView.h"
#import "XLChannelItem.h"
#import "XLChannelHeader.h"
#import "XLChannelModel.h"

//菜单列数
static NSInteger ColumnNumber = 4;
//横向和纵向的间距
static CGFloat CellMarginX = 10.0f;
static CGFloat CellMarginY = 20.0f;


@interface XLChannelView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    //被拖拽的item
    XLChannelItem *_dragingItem;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
    
    BOOL canEdit;   //是否是编辑状态
}
@end

@implementation XLChannelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat cellWidth = (self.bounds.size.width - (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
    CGFloat cellHeight = cellWidth * 30 / 78;
    flowLayout.itemSize = CGSizeMake(cellWidth,cellHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 40);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[XLChannelItem class] forCellWithReuseIdentifier:@"XLChannelItem"];
    [_collectionView registerClass:[XLChannelHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLChannelHeader"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.3f;
    [_collectionView addGestureRecognizer:longPress];
    
    _dragingItem = [[XLChannelItem alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    _dragingItem.hidden = true;
    [_collectionView addSubview:_dragingItem];
}

#pragma mark -
#pragma mark LongPressMethod
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    if (!canEdit) {
        return;
    }
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}

//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point{
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    [_collectionView bringSubviewToFront:_dragingItem];
    XLChannelItem *item = (XLChannelItem*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    item.isMoving = true;
    //更新被拖拽的item
    _dragingItem.hidden = false;
    _dragingItem.frame = item.frame;
    _dragingItem.title = item.title;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
}

//正在被拖拽、、、
-(void)dragChanged:(CGPoint)point{
    if (!_dragingIndexPath) {return;}
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rearrangeInUseTitles];
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

//拖拽结束
-(void)dragEnd{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        self->_dragingItem.frame = endFrame;
    }completion:^(BOOL finished) {
        self->_dragingItem.hidden = true;
        XLChannelItem *item = (XLChannelItem*)[self->_collectionView cellForItemAtIndexPath:self->_dragingIndexPath];
        item.isMoving = false;
        [self reloadData];
    }];
}

#pragma mark -
#pragma mark 辅助方法

//获取被拖动IndexPath的方法
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    //最后剩一个怎不可以排序
    if ([_collectionView numberOfItemsInSection:0] == 1) {return dragIndexPath;}
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {continue;}
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                dragIndexPath = indexPath;
            }
//            XLChannelModel *model = _inUseTitles[indexPath.row];
//            if (model.status != 2) {
//                dragIndexPath = indexPath;
//            }
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        //第二组不需要排序
        if (indexPath.section > 0) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                targetIndexPath = indexPath;
            }
        }
    }
    return targetIndexPath;
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? _inUseTitles.count : _unUseTitles.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XLChannelHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLChannelHeader" forIndexPath:indexPath];
    headerView.showLine = NO;
    if (indexPath.section == 0) {
        headerView.title = @"我的频道";
        headerView.subTitle = @"点击进入频道";
        if (canEdit) {
            headerView.rightTitle = @"完成";
            headerView.subTitle = @"按住拖动调整排序";
        }else{
            headerView.rightTitle = @"编辑";
        }
        
        __weak typeof(self) weakSelf = self;
        headerView.isEditBlock = ^(BOOL isedit) {
            if (isedit) {
                NSLog(@"可以编辑");
                self->canEdit = YES;
            }else{
                NSLog(@"完成编辑");
                self->canEdit = NO;
            }
            [weakSelf reloadData];
        };
    }else{
//        headerView.showLine = YES;
        headerView.title = @"频道推荐";
        headerView.subTitle = @"点击添加频道";
        headerView.rightTitle = @"";
    }
    return headerView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"XLChannelItem";
    XLChannelModel *model = indexPath.section == 0 ? _inUseTitles[indexPath.row] : _unUseTitles[indexPath.row];
    XLChannelItem* item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//    item.title = indexPath.section == 0 ? _inUseTitles[indexPath.row] : _unUseTitles[indexPath.row];
    item.title = model.channelName;
//    item.isFixed = indexPath.section == 0 && indexPath.row == 0;
    if (model.status == 2) {    //固定
        item.isFixed = YES;
    }else{
        item.isFixed = NO;
    }
    if (indexPath.section == 0&&canEdit) {
        item.canDelete = !item.isFixed;
    }else{
        item.canDelete = NO;
    }
    
    item.isNew = model.isNew;
    
    
    return  item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (canEdit) {
        
        if (indexPath.section == 0) {
            //只剩一个的时候不可删除
            if ([_collectionView numberOfItemsInSection:0] == 1) {return;}
            //第一个不可删除
//            if (indexPath.row  == 0) {return;}
            XLChannelModel *obj = [_inUseTitles objectAtIndex:indexPath.row];
            if (obj.status == 2) {
                return;
            }
            [_inUseTitles removeObject:obj];
            [_unUseTitles insertObject:obj atIndex:0];
            [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            
        }else{
            XLChannelModel *model = [_unUseTitles objectAtIndex:indexPath.row];
            model.isNew = NO;
            [_unUseTitles removeObject:model];
            [_inUseTitles addObject:model];
            [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:_inUseTitles.count - 1 inSection:0]];
            
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadData];
        });
        
    }else{
        
        if (indexPath.section == 0) {
            id obj = [_inUseTitles objectAtIndex:indexPath.row];
//            NSLog(@"点击了%@",obj);
            if (self.clickBlock) {
                self.clickBlock(obj);
            }
        }
        
    }
    
}

#pragma mark -
#pragma mark 刷新方法
//拖拽排序后需要重新排序数据源
-(void)rearrangeInUseTitles
{
    id obj = [_inUseTitles objectAtIndex:_dragingIndexPath.row];
    [_inUseTitles removeObject:obj];
    [_inUseTitles insertObject:obj atIndex:_targetIndexPath.row];
}

-(void)reloadData
{
    [_collectionView reloadData];
}

@end
