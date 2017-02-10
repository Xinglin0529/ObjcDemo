//
//  FisrtViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "FisrtViewController.h"
#import "LoginViewController.h"

@interface FisrtViewController ()

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation FisrtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"First" style:UIBarButtonItemStylePlain target:self action:@selector(pushAction)];
    self.number = 1;
    self.lock = [[NSLock alloc] init];
    
    ///
    //NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1:) object:nil];
    //[thread start];
    
    ///
    //[NSThread detachNewThreadSelector:@selector(run2:) toTarget:self withObject:nil];
    
    ///
    //[self performSelectorInBackground:@selector(run:) withObject:nil];
    
    //[self performSelectorOnMainThread:@selector(run1:) withObject:nil waitUntilDone:YES];
    //[self performSelector:@selector(run1:) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    ///串行队列
    //dispatch_queue_t queue1 = dispatch_queue_create("com", NULL);
    ///并发队列
//    dispatch_queue_t queue1 = dispatch_queue_create("com.pingan.queue1", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue1, ^{
//        [self run1:nil];
//    });
    
//    dispatch_queue_t queue3 = dispatch_queue_create("com.pingan.queue3", NULL);
//    dispatch_barrier_async(queue3, ^{
//        NSLog(@"im barrier queue");
//    });
    //dispatch_queue_t queue4 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
//    dispatch_queue_t queue2 = dispatch_queue_create("com.pingan.queue2", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue2, ^{
//        [self run2:nil];
//    });
    
//    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t t) {
//        NSLog(@"==================%zu", t);
//    });

//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 3;
//    NSInvocationOperation *invocation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run1:) object:nil];
//    
//    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
//        [self run2:nil];
//    }];
//    block.completionBlock = ^{
//        NSLog(@"计数结束!.........");
//    };
//    
//    [queue addOperation:invocation];
//    [queue addOperation:block];

//    [[NSOperationQueue new] addOperationWithBlock:^{
//        NSLog(@"子线程任务");
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            NSLog(@"主线程任务");
//        }];
//    }];
    
    [self judgeIsMainThread];
}

- (void)judgeIsMainThread {
    if ([NSThread isMainThread]) {
        NSLog(@"是主线程");
        return;
    }
    NSLog(@"非主线程");
}

- (void)run1:(NSThread *)thread {
    [self.lock lock];
    for (NSInteger i = 0; i < 100; i++) {
        ++self.number;
        NSLog(@"thread start1, value--------::%ld",(long)self.number);
    }
    [self.lock unlock];
}


- (void)run2:(NSThread *)thread {
    [self.lock lock];
    for (NSInteger i = 0; i < 100; i++) {
        --self.number;
        NSLog(@"thread start2, value--------::%ld",(long)self.number);
    }
    [self.lock unlock];
}

- (void)pushAction {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
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
