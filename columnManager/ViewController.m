//
//  ViewController.m
//  columnManager
//
//  Created by toro宇 on 2018/6/1.
//  Copyright © 2018年 yijie. All rights reserved.
//

#import "ViewController.h"
#import "ColumnMenuViewController.h"
#import "UIView+JM.h"

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YY";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"栏目管理Test" forState:UIControlStateNormal];
    btn.backgroundColor = kRandomColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    btn.width = 100;
    btn.height = 40;
    btn.center = self.view.center;
    btn.layer.cornerRadius = 4.f;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)btnClick:(UIButton *)btn {
    ColumnMenuViewController *menuVC = [ColumnMenuViewController columnMenuViewController:^(NSString *menuStr) {
        
    }];
    [self presentViewController:menuVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
