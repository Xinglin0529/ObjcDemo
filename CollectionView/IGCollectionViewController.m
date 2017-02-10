//
//  IGCollectionViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/10.
//  Copyright © 2017年 com. All rights reserved.
//

#import "IGCollectionViewController.h"
#import <IGListKit/IGListKit.h>
#import <Masonry/Masonry.h>
#import "GridSectionController.h"
#import "TextSectionController.h"

@interface IGCollectionViewController () <IGListAdapterDataSource>

@property (nonatomic, strong) IGListCollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSMutableArray <GridModel *> *dataList;

@end

@implementation IGCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    GridModel *g = [GridModel new];
    g.text = @"1";
    g.count = 5;
    self.dataList = @[g, @"load method has being calledload method has being calledload method has being calledload method has being called"].mutableCopy;
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataList;
}

- (IGListSectionController<IGListSectionType> *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if (![object isKindOfClass:[GridModel class]]) {
        return [TextSectionController new];
    }
    return [GridSectionController new];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - getter

- (IGListAdapter *)adapter {
    if (!_adapter) {
        IGListAdapterUpdater *updater = [[IGListAdapterUpdater alloc] init];
        _adapter = [[IGListAdapter alloc] initWithUpdater:updater viewController:self workingRangeSize:0];
    }
    return _adapter;
}

- (IGListCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[IGListCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    }
    return _collectionView;
}

@end
