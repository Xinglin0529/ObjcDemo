//
//  SecondViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SecondViewController.h"
#import <objc/runtime.h>
#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import <RFQuiltLayout/RFQuiltLayout.h>
#import "RFQuiltLayoutCollectionViewCell.h"

@implementation RFViewModel

@end

@interface SecondViewController () <UICollectionViewDataSource, UICollectionViewDelegate, RFQuiltLayoutDelegate>

@property (nonatomic, copy) NSString *clsName;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Second" style:UIBarButtonItemStylePlain target:self action:@selector(objcTest)];
    RFViewModel *vm1 = [RFViewModel new];
    vm1.row = 1;
    vm1.colomn = 1;
    vm1.title = @"1";
    
    RFViewModel *vm2 = [RFViewModel new];
    vm2.row = 3;
    vm2.colomn = 1;
    vm2.title = @"2";

    RFViewModel *vm3 = [RFViewModel new];
    vm3.row = 2;
    vm3.colomn = 1;
    vm3.title = @"3";

    RFViewModel *vm4 = [RFViewModel new];
    vm4.row = 2;
    vm4.colomn = 1;
    vm4.title = @"4";

    RFViewModel *vm5 = [RFViewModel new];
    vm5.row = 1;
    vm5.colomn = 1;
    vm5.title = @"5";

    RFViewModel *vm6 = [RFViewModel new];
    vm6.row = 1;
    vm6.colomn = 1;
    vm6.title = @"6";
    
    RFViewModel *vm7 = [RFViewModel new];
    vm7.row = 3;
    vm7.colomn = 1;
    vm7.title = @"7";
    
    RFViewModel *vm8 = [RFViewModel new];
    vm8.row = 2;
    vm8.colomn = 1;
    vm8.title = @"8";
    
    RFViewModel *vm9 = [RFViewModel new];
    vm9.row = 2;
    vm9.colomn = 1;
    vm9.title = @"9";
    
    RFViewModel *vm10 = [RFViewModel new];
    vm10.row = 1;
    vm10.colomn = 1;
    vm10.title = @"10";

    self.array = @[vm1, vm2, vm3, vm4, vm5, vm6, vm7, vm8, vm9, vm10];
    
    RFQuiltLayout *layout = [[RFQuiltLayout alloc] init];
    layout.blockPixels = CGSizeMake(100, 100);
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[RFQuiltLayoutCollectionViewCell class] forCellWithReuseIdentifier:@"RFQuiltLayoutCollectionViewCell"];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *lay1 = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *lay2 = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *lay3 = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *lay4 = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraints:@[lay1, lay2, lay3, lay4]];
}

- (CGSize)blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RFViewModel *vm = self.array[indexPath.item];
    return CGSizeMake(vm.row, vm.colomn);
}

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RFQuiltLayoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RFQuiltLayoutCollectionViewCell" forIndexPath:indexPath];
    [cell configCellWitgModel:self.array[indexPath.item]];
    return cell;
}


- (void)objcTest {
    Class cls = objc_allocateClassPair([NSObject class], "Person", 0);
    class_addIvar(cls, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    class_addIvar(cls, "_age", sizeof(NSInteger), log2(sizeof(NSInteger)), @encode(NSInteger));
//    objc_registerClassPair(cls);
    
    id obj = [[cls alloc] init];
    [obj setValue:@"xiaoming" forKey:@"name"];
    Ivar ageIvar = class_getInstanceVariable(cls, "_age");
    object_setIvar(obj, ageIvar, @(18));
    NSLog(@"name == %@ age === %ld", [obj objectForKey:@"name"], [[obj objectForKey:@"age"] integerValue]);
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"ivar name == %@", @(ivar_getName(ivar)));
    }
    
    [[LoginViewController new] callLoginPage];
}

- (void)pushAction {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
