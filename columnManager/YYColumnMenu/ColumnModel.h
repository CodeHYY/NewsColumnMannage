//
//  ColumnModel.h
//  columnManager
//
//  Created by toro宇 on 2018/6/4.
//  Copyright © 2018年 yijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColumnModel : NSObject
/** title */
@property (nonatomic, copy) NSString *title;
/** 是否选中 */
@property (nonatomic, assign) BOOL selected;
/** 是否允许删除 */
@property (nonatomic, assign) BOOL resident;
/** 是否显示加号 */
@property (nonatomic, assign) BOOL showAdd;
@end
