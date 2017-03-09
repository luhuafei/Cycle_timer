//
//  ViewController.m
//  Cycle_timer
//
//  Created by DengTianran on 2017/3/9.
//  Copyright © 2017年 DengTianran. All rights reserved.
//

#import "ViewController.h"
#import "ScondViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[ScondViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
