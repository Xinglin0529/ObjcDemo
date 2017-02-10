//
//  GridSectionController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/10.
//  Copyright © 2017年 com. All rights reserved.
//

#import "GridSectionController.h"
#import <Masonry/Masonry.h>
#import "ReactiveViewController.h"
@implementation GridModel

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return YES;
}

@end

@interface GridCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;
- (void)updateGridCellWithText:(NSString *)text;

@end

@implementation GridCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)updateGridCellWithText:(NSString *)text {
    self.textLabel.text = text;
    self.contentView.backgroundColor = [UIColor redColor];
}

@end


@interface GridSectionController ()

@property (nonatomic, strong) GridModel *model;

@end

@implementation GridSectionController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 1;
        self.minimumInteritemSpacing = 1;
        self.inset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    return self;
}

- (NSInteger)numberOfItems {
    return self.model.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = (self.collectionContext.containerSize.width - 3) / 4;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    GridCollectionCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GridCollectionCell class] forSectionController:self atIndex:index];
    [cell updateGridCellWithText:self.model.text];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.model = object;
    [self.collectionContext reloadSectionController:self];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"-------------88888888888888888");
}

@end
