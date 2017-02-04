//
//  ReactiveViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ReactiveViewController.h"
#import <Masonry/Masonry.h>

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@implementation Person
@end

@interface ReactiveViewController ()
{
    RACCommand *_command;
}
@property (nonatomic, copy) NSString *reactiveName;

@end

@implementation ReactiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reactiveName = @"11111";
//    [self testRACSignal1];
//    [self testRACSignal2];
//    [self testRACSignal3];
//    [self testRACSignal4];
//    [self testRACSignal5];
//    [self testRACSignal6];
//    [self testRACSignal7];
//    [self testRACSignal8];
    [self testRACSignal9];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_command execute:nil];
//    if (self.subjectDelegate) {
//        [self.subjectDelegate sendNext:@"111"];
//    }
//    self.reactiveName = @"222222";
//}

// RACSignal使用步骤：
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 - (void)sendNext:(id)value


// RACSignal底层实现：
// 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
// 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
// 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
// 2.1 subscribeNext内部会调用siganl的didSubscribe
// 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
// 3.1 sendNext底层其实就是执行subscriber的nextBlock
- (void)testRACSignal1 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        Person *p = [Person new];
        p.name = @"小明";
        p.age = 20;
        [subscriber sendNext:p];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号销毁");
        }];
    }];
    
    [signal subscribeNext:^(Person *x) {
        NSLog(@"收到信号: %@", x.name);
    }];
}

// RACSubject使用步骤
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 sendNext:(id)value

// RACSubject:底层实现和RACSignal不一样。
// 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
// 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
- (void)testRACSignal2 {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe value1: %@", x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe value2: %@", x);
    }];
    
    [subject sendNext:@"我就试试"];
}

// RACReplaySubject使用步骤:
// 1.创建信号 [RACReplaySubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.可以先订阅信号，也可以先发送信号。
// 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 2.2 发送信号 sendNext:(id)value

// RACReplaySubject:底层实现和RACSubject不一样。
// 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
// 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock

// 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
// 也就是先保存值，在订阅值。
- (void)testRACSignal3 {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    [subject sendNext:@"我试试"];
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe before: %@", x);
    }];
    [subject sendNext:@"我就是试试"];
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe after: %@", x);
    }];
}

- (void)testRACSignal4 {
    // 1.遍历数组
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    NSArray *numbers = @[@1, @2, @3, @4];
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"subject value: %@", x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name": @"小明", @"age": @"18"};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"key: %@, value: %@", key, value);
    }];
}

// 一、RACCommand使用步骤:
// 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
// 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
// 3.执行命令 - (RACSignal *)execute:(id)input

// 二、RACCommand使用注意:
// 1.signalBlock必须要返回一个信号，不能传nil.
// 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
// 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
// 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。

// 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
// 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
// 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。

// 四、如何拿到RACCommand中返回信号发出的数据。
// 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
// 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

// 五、监听当前命令是否正在执行executing

// 六、使用场景,监听按钮点击，网络请求
- (void)testRACSignal5 {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           [subscriber sendNext:@"send command event"];
           [subscriber sendCompleted];
           return [RACDisposable disposableWithBlock:^{
               
           }];
       }];
    }];
    
    _command = command;
    
    [command.executionSignals subscribeNext:^(id x) {
       [x subscribeNext:^(id x) {
           NSLog(@"receive signal: %@", x);
       }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"receive signal by switchToLatest: %@", x);
    }];
}

// RACMulticastConnection使用步骤:
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.创建连接 RACMulticastConnection *connect = [signal publish];
// 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
// 4.连接 [connect connect]

// RACMulticastConnection底层原理:
// 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
// 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
// 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
// 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
// 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
// 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
// 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock


// 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
// 解决：使用RACMulticastConnection就能解决.
- (void)testRACSignal6 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@"1111"];
        [subscriber sendCompleted];
        return nil;
    }];
    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"接受数据1");
//    }];
//    
//    [signal subscribeNext:^(id x) {
//        NSLog(@"接受数据2");
//    }];
    
    RACMulticastConnection *connect = [signal publish];
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者信号1");
    }];
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者信号2");
    }];
    [connect connect];
}

- (void)testRACSignal7 {
    // RACScheduler:RAC中的队列，用GCD封装的。
    
    // RACUnit :表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
    
    // RACEvent: 把数据包装成信号事件(signal event)。它主要通过RACSignal的-materialize来使用，然并卵。
    
    [[self rac_valuesAndChangesForKeyPath:@"reactiveName" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"reactiveName: %@", x);
    }];
    
//    [RACObserve(self, reactiveName) subscribeNext:^(id x) {
//        NSLog(@"Observe");
//    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Click" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"click at button");
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
}

- (void)testRACSignal8 {
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"111"];
        return nil;
    }];
    
    RACSignal *s2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"222"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUI:data2:) withSignalsFromArray:@[s1, s2]];
}

- (void)updateUI:(id)data1 data2:(id)data2 {
    NSLog(@"data1: %@, data2: %@", data1, data2);
}

- (void)testRACSignal9 {
    NSArray *numbers = @[@"one", @"two", @"three", @"four", @"five"];
    RACSequence *sequence = [[numbers.rac_sequence filter:^BOOL(NSString *value) {
        return value.length > 3;
    }] map:^id(NSString *value) {
        return [value uppercaseString];
    }];
    [sequence.signal subscribeNext:^(id x) {
        NSLog(@"*************::%@", x);
    }];
}

@end
