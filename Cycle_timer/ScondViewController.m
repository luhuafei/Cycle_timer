//
//  ScondViewController.m
//  JX_GCDTimer
//
//  Created by DengTianran on 2017/3/9.
//  Copyright © 2017年 com.joeyxu. All rights reserved.
//

#import "ScondViewController.h"

@interface ScondViewController ()
@property (strong, nonatomic)HFProxy *proxy;
@property (strong, nonatomic)NSTimer *timer;
@property (assign, nonatomic)NSInteger count;

@property (strong, nonatomic)dispatch_source_t sourceTimer;

@end

@implementation ScondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //第一种 不会走dealloc 方法_timer还被持有没有释放 会造成内存泄露 (不能用)
//     _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    
    //第二种 走dealloc  (完美解决问题)
        self.proxy = [HFProxy alloc];
        self.proxy.obj = self;
       _timer = [NSTimer timerWithTimeInterval:1 target:self.proxy selector:@selector(timerEvent) userInfo:nil repeats:YES];
       [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
//   第三种 gcd计时器
    //创建全局队列 优先级
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //定时器 事件源
    _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    /**
       1,事件源
       2,什么时候开始
       3,多久执行一次(单位纳秒 (NSEC_PER_SEC))
       4,偏差(精确度)
     */
    dispatch_source_set_timer(_sourceTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    //响应原事件
    dispatch_source_set_event_handler(_sourceTimer, ^{
        
        NSLog(@"开始计时啦");
        
        if(YES){
            dispatch_source_cancel(_sourceTimer);
            //iOS 6之后 gcd 不用再手动释放
            //OS_OBJECT_USE_OBJC 是iOS 6之后才有的, 如果是6之前 释放
#if !OS_OBJECT_USE_OBJC
            dispatch_release(_sourceTimer);
#endif
        }else
        {
            
            
        }
       
    });
    dispatch_source_set_cancel_handler(_sourceTimer, ^{
        
    });
    
     //启动
    dispatch_resume(_sourceTimer);
}


-(void)timerEvent
{
    NSLog(@"count---%d",(int)++_count);
}
-(void)dealloc
{
    NSLog(@"---dealloc----");
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


@implementation HFProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSString *selectorName = NSStringFromSelector(sel);
    NSLog(@"%@", selectorName);
   return [self.obj methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self.obj respondsToSelector:invocation.selector]) {
        NSString *selectorName = NSStringFromSelector(invocation.selector);
        
        NSLog(@"Before calling \"%@\".", selectorName);
        [invocation invokeWithTarget:self.obj];
        NSLog(@"After calling \"%@\".", selectorName);
    }
}

@end
