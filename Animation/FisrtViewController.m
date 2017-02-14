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
    [self testMethod];
    [self timerSource];
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

- (void)testMethod {
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"1111");
//    }];
//    [timer setFireDate:[NSDate date]];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
//    typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
//        kCFRunLoopEntry = (1UL << 0),   //即将进入Runloop
//        kCFRunLoopBeforeTimers = (1UL << 1),    //即将处理NSTimer
//        kCFRunLoopBeforeSources = (1UL << 2),   //即将处理Sources
//        kCFRunLoopBeforeWaiting = (1UL << 5),   //即将进入休眠
//        kCFRunLoopAfterWaiting = (1UL << 6),    //刚从休眠中唤醒
//        kCFRunLoopExit = (1UL << 7),            //即将退出runloop
//        kCFRunLoopAllActivities = 0x0FFFFFFFU   //所有状态改变
//    };
//    
//    通过Observer监听RunLoop的状态，一旦监听到RunLoop即将进入睡眠等待状态，就释放自动释放池（kCFRunLoopBeforeWaiting）
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
                case kCFRunLoopEntry:
                NSLog(@"runloop进入");
                break;
                case kCFRunLoopBeforeTimers:
                NSLog(@"runloop要去处理timer");
                break;
                case kCFRunLoopBeforeSources:
                NSLog(@"runloop要去处理Sources");
                break;
                case kCFRunLoopBeforeWaiting:
                NSLog(@"runloop要睡觉了");
                break;
                case kCFRunLoopAfterWaiting:
                NSLog(@"runloop醒来啦");
                break;
                
                case kCFRunLoopExit:
                NSLog(@"runloop退出");
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
}

- (void)timerSource {
    static NSInteger number = 0;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"dispatch timer start: %ld", (long)number);
        number++;
        if (number == 20) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
}

- (void)pushAction {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)callLoginPage {
    NSLog(@"message has been forwarding to fisrtViewController");
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
