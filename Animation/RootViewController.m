//
//  RootViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "RootViewController.h"
#import "FisrtViewController.h"
#import "ProxyViewController.h"
#import "ReactiveViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "Reactive.h"
#import "IGCollectionViewController.h"
#import "SecondViewController.h"

typedef NS_ENUM(NSInteger, Direction) {
    DirectionUp,
    DirectionDown,
    DirectionLeft,
    DirectionRight
};

@interface RootViewController () <NSURLSessionDownloadDelegate>

@property (copy) NSMutableArray *dataArray;
@property (nonatomic, assign) UIViewController *testAss;

@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Root" style:UIBarButtonItemStylePlain target:self action:@selector(pushAction)];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"输入...";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.enabled = NO;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *regex = @"^[eE][mM][sS][0-9]{12}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:textField.text];
        if (isValid) {
            NSLog(@"验证通过..............");
        }
    }];
    [self.view addSubview:button];
    
    UILabel *content = [UILabel new];
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:12];
    content.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:content];
//    [content mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(textField);
//        make.top.equalTo(button.mas_bottom).offset(10);
//    }];
    
    RAC(button, enabled) = [RACSignal combineLatest:@[textField.rac_textSignal] reduce:^id(NSString *text){
        return @(text.length > 0);
    }];
    
    RAC(content, text) = textField.rac_textSignal;
    
    [[RACObserve(content, text) filter:^BOOL(NSString *value) {
        return [value hasPrefix:@"Q"];
    }] subscribeNext:^(id x) {
        NSLog(@"Observer value: %@", x);
    }];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    content.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:40]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:40]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:80]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:100]];
    
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view).offset(20);
//        make.trailing.equalTo(self.view).offset(-20);
//        make.top.equalTo(self.view).offset(100);
//        make.height.mas_equalTo(44);
//    }];
//    
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(textField);
//        make.top.equalTo(textField.mas_bottom).offset(10);
//        make.size.mas_equalTo(CGSizeMake(80, 40));
//    }];
    
    RACSubject *sub = [self subject];
    [sub subscribeNext:^(id x) {
        content.text = x;
    }];
    
    [self testValist:@"name1", @"name2", @"name3", nil];
    
    self.testAss = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"dispatch_syncdispatch_sync-----");
        });
    });
}

- (void)testValist:(NSString *)name,... {
    va_list va;
    va_start(va, name);
    NSString *temp = name;
    while (temp != nil) {
//        NSLog(@"tempValue-------------%@", temp);
        temp = va_arg(va, NSString *);
    }
    va_end(va);
    
    dispatch_queue_t queue = dispatch_queue_create("queueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1111111111");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier_async-------------------");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2222222222");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3333333333");
    });
}

- (RACSubject *)subject {
    RACSubject *subject = [RACSubject subject];
    [[[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] take:1] map:^id(NSString *value) {
        NSString *s = @"upperCaseString";
        [subject sendNext:s];
        [subject sendCompleted];
        return nil;
    }] subscribeNext:^(id x) {}];
    return subject;
}

- (void)pushAction {
//    ReactiveViewController *react = [ReactiveViewController new];
//    react.subjectDelegate = [RACSubject subject];
//    [react.subjectDelegate subscribeNext:^(id x) {
//        NSLog(@"x------------- %@", x);
//    }];
//    IGCollectionViewController *ig = [IGCollectionViewController new];
//    FisrtViewController *first = [FisrtViewController new];
    SecondViewController *second = [SecondViewController new];
    [self.navigationController pushViewController:second animated:YES];
}

- (void)testNetWork1 {
    NSURL *url = [NSURL URLWithString:@"http://bmob-cdn-8782.b0.upaiyun.com/2017/01/17/c6b6bb1640e9ae9e80b221c454c4e90d.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [task resume];
}

- (void)testNetwork2 {
    NSURL *url = [NSURL URLWithString:@""];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *down = [session downloadTaskWithURL:url];
    [down resume];
    
    [down cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        
    }];
    
    NSURLSessionDownloadTask *resume = [session downloadTaskWithResumeData:[NSData new]];
    [resume resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}

- (UIImage *)rotateImage:(UIImage *)image direction:(Direction)direction {
    void(^block)(CGContextRef context);
    CGSize imageSize;
    switch (direction) {
            case DirectionDown:
        {
            imageSize = image.size;
            block = ^(CGContextRef context) {
                CGContextTranslateCTM(context, 0, imageSize.height);
                CGContextScaleCTM(context, 1, -1);
            };
        }
            break;
            case DirectionLeft:
        {
            imageSize = CGSizeMake(imageSize.height, imageSize.width);
            block = ^(CGContextRef context) {
                CGContextRotateCTM(context, M_PI / 2);
                CGContextTranslateCTM(context, -imageSize.height, imageSize.width);
                CGContextScaleCTM(context, -1, 1);
            };
        }
            break;
            case DirectionRight:
        {
            imageSize = CGSizeMake(imageSize.height, imageSize.width);
            block = ^(CGContextRef context) {
                CGContextRotateCTM(context, -M_PI / 2);
                CGContextScaleCTM(context, -1, 1);
            };
        }
            break;
        default:
            break;
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    block(UIGraphicsGetCurrentContext());
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    return result;
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
