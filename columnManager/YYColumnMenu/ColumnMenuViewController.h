//
//  ColumnMenuViewController.h
//  columnManager
//
//  Created by toro宇 on 2018/6/1.
//  Copyright © 2018年 yijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnMenuViewController : UIViewController

/**
 点击菜单栏回调
 */
@property (nonatomic, strong)void(^clickMenuCellBlock)(NSString *menuStr);

/**
 类方法创建VC

 @return ColumnMenuViewController
 */
+(ColumnMenuViewController *)columnMenuViewController:(void(^)(NSString *menuStr))clickMenuCellBlock;

@end
