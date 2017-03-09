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
@end

@implementation ScondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.proxy = [HFProxy alloc];
    self.proxy.obj = self;
    
    //第一种 不会走dealloc 方法_timer还被持有没有释放 会造成内存泄露 (不能用)
//     _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    
    //第二种 走dealloc  (完美解决问题)
    _timer = [NSTimer timerWithTimeInterval:1 target:self.proxy selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

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
