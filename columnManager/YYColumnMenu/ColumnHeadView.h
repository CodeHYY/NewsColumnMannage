//
//  ColumnHeadView.h
//  columnManager
//
//  Created by toro宇 on 2018/6/4.
//  Copyright © 2018年 yijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnHeadView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *biaotiLab;
@property (weak, nonatomic) IBOutlet UILabel *tishiLab;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (nonatomic, strong)void(^editBtnBlock)();

@end
