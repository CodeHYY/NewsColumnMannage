//
//  ColumnCell.m
//  columnManager
//
//  Created by toro宇 on 2018/6/4.
//  Copyright © 2018年 yijie. All rights reserved.
//

#import "ColumnCell.h"
#import "UIView+JM.h"
#import "JMConfig.h"
@interface ColumnCell()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *columnLab;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@property (nonatomic, strong)ColumnModel *model;
@end
@implementation ColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [JMConfig colorWithHexString:@"#f4f4f4"];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.f;
    self.columnLab.font = [UIFont systemFontOfSize:15];
    self.columnLab.textAlignment = NSTextAlignmentCenter;
   
    self.removeBtn.hidden = YES;
    self.addBtn.hidden = YES;

    // Initialization code
}

-(void)configUIWithData:(ColumnModel *)model closeBtn:(void(^)(ColumnModel *model))closeBtnBlock
{
    _model = model;
    _closeBtnBlock = closeBtnBlock;
    
    // 根据模型布局UI
    [self layoutIfNeeded];
    
}

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    
    self.columnLab.text = [NSString stringWithFormat:@"%@",_model.title];
    _addBtn.hidden = !_model.showAdd;
    _removeBtn.hidden = !_model.selected;

    if (_model.resident) {
        [self.columnLab setTextColor:[UIColor redColor]];
        
    }else
    {
        [self.columnLab setTextColor:[UIColor blackColor]];
    }
    
    //标题文字处理
    
    if (_model.title.length == 2) {
        self.columnLab.font = [UIFont systemFontOfSize:15];
    } else if (_model.title.length == 3) {
        self.columnLab.font = [UIFont systemFontOfSize:14];
    } else if (_model.title.length == 4) {
        self.columnLab.font = [UIFont systemFontOfSize:13];
    } else if (_model.title.length > 4) {
        self.columnLab.font = [UIFont systemFontOfSize:12];
    }
    
    self.columnLab.size = [self returnTitleSize];
    if (_model.showAdd) {
        self.columnLab.center = CGPointMake(self.width/2 + 6, self.height / 2);
    }else
    {
        self.columnLab.center = CGPointMake(self.width / 2, self.height / 2);

    }
    self.addBtn.size = CGSizeMake(10, 10);
    self.addBtn.centerY = self.columnLab.centerY;
    self.addBtn.x = CGRectGetMinX(self.columnLab.frame) - 12;
    
}

- (CGSize)returnTitleSize {
    CGFloat maxWidth = self.width - 12;
    CGSize size = [self.columnLab.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:self.columnLab.font}
                                                context:nil].size;
    return size;
}
- (IBAction)removeBtn:(UIButton *)sender {
    if (self.closeBtnBlock) {
        self.closeBtnBlock(_model);
    }
}

@end
