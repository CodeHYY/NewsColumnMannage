//
//  ColumnCell.h
//  columnManager
//
//  Created by toro宇 on 2018/6/4.
//  Copyright © 2018年 yijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColumnModel.h"
@interface ColumnCell : UICollectionViewCell
@property (nonatomic, strong)void(^closeBtnBlock)(ColumnModel *model);

-(void)configUIWithData:(ColumnModel *)model closeBtn:(void(^)(ColumnModel *model))closeBtnBlock;

@end
