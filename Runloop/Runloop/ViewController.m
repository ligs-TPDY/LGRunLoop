//
//  ViewController.m
//  Runloop
//
//  Created by carnet on 2018/5/15.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "ViewController.h"
#import "MyThread.h"
@interface ViewController ()
@property (nonatomic,strong) MyThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[NSThread currentThread]);
    self.thread = [[MyThread alloc]initWithTarget:self selector:@selector(subThreadTodo) object:nil];
    self.thread.name = @"subThread";
    [self.thread start];
    NSLog(@"%@",[NSThread currentThread]);
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSLog(@"----监听到RunLoop状态发生改变---%zd", activity);
        
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(wantTodo) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)subThreadTodo
{
    NSLog(@"%@",[NSThread currentThread]);
    
    NSRunLoop *RunLoop = [NSRunLoop currentRunLoop];
    
    [RunLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    [RunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    NSLog(@"%@",[NSThread currentThread]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(wantTodo) onThread:self.thread withObject:nil waitUntilDone:NO];
}
- (void)wantTodo{
    
    
    
    NSLog(@"当前线程:%@执行任务处理数据", [NSThread currentThread]);
    
    
    
}
@end
