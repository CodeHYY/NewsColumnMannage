//
//  ColumnMenuViewController.m
//  columnManager
//
//  Created by toro宇 on 2018/6/1.
//  Copyright © 2018年 yijie. All rights reserved.
//

#import "ColumnMenuViewController.h"
#import "UIView+JM.h"
#import "ColumnModel.h"
#import "ColumnCell.h"
#import "ColumnHeadView.h"
@interface ColumnMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 导航栏的view */
@property (nonatomic, weak) UIView *navView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *menuDataSource;// 数据源
@property (nonatomic, weak)ColumnHeadView *headViewOne;
@property (nonatomic, weak)ColumnHeadView *headViewTwo;


/** 引用headView编辑字符串 */
@property(nonatomic, assign)UIButton *editBtn;

@end

@implementation ColumnMenuViewController

+(ColumnMenuViewController *)columnMenuViewController:(void(^)(NSString *menuStr))clickMenuCellBlock;
{
    ColumnMenuViewController *VC = [[ColumnMenuViewController alloc] init];
    VC.clickMenuCellBlock = clickMenuCellBlock;
    return VC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.Use UIScrollView's contentInsetAdjustmentBehavior instead = NO;

    //初始化UI
    [self initCustomUI];
    
    // 配置网络接口数据并刷新
    [self requetData];
    // Do any additional setup after loading the view.
}

- (void)initCustomUI
{
    // 配置导航栏
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    navView.backgroundColor = [UIColor blackColor];
    self.navView = navView;
    [self.view addSubview:navView];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.navView.centerX - 100, self.navView.centerY, 200, 20)];
    navTitle.text = @"频道定制";
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor whiteColor];
    [self.navView addSubview:navTitle];
    
    UIButton *navCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navCloseBtn.frame = CGRectMake(self.navView.width - 30, CGRectGetMinY(navTitle.frame), 20, 20);
    [navCloseBtn setImage:[UIImage imageNamed:@"close_one"] forState:UIControlStateNormal];
    [navCloseBtn addTarget:self action:@selector(navCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:navCloseBtn];
    
    
    //视图布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - self.navView.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ColumnCell" bundle:nil] forCellWithReuseIdentifier:@"ColumnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ColumnHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ColumnHeadView"];
    //添加手势
    UILongPressGestureRecognizer *longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressed:)];
    [self.collectionView addGestureRecognizer:longPressRec];
    
}

#pragma mark - 手势识别
- (void)onLongPressed:(UILongPressGestureRecognizer *)sender {
    if (!self.editBtn.selected) {
        [self clickEditBtn];
    }

    //获取点击在collectionView的坐标
    CGPoint point = [sender locationInView:sender.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath.section == 0 && indexPath.item == 0) {
                return;
            }
            
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (indexPath.section == 0 && indexPath.item == 0) {
                return;
            }
            
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default: {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }
}


#pragma mark - Req
- (void)requetData
{
    NSMutableArray *myTagsArrM = [NSMutableArray arrayWithObjects:@"要闻",@"视频",@"娱乐",@"军事",@"新时代",@"独家",@"广东",@"社会",@"图文",@"段子",@"搞笑视频", nil];
    NSMutableArray *otherArrM = [NSMutableArray arrayWithObjects:@"八卦",@"搞笑",@"短视频",@"图文段子",@"极限第一人", nil];

    for (NSString *tagStr in myTagsArrM) {
        ColumnModel *model = [[ColumnModel alloc] init];
        model.title = tagStr;
        model.showAdd = NO;
        model.selected = NO;
        if ([tagStr isEqualToString:@"要闻"]) {
            model.resident = YES;
        }
        [self.menuDataSource[0] addObject:model];
    }
    
    for (NSString *title in otherArrM) {
        ColumnModel *model = [[ColumnModel alloc] init];
        model.title = title;
        model.showAdd = YES;
        model.selected = NO;
        [self.menuDataSource[1] addObject:model];
    }
    
    [self.collectionView reloadData];

}
#pragma mark -Lazy

-(NSMutableArray *)menuDataSource
{
    if (!_menuDataSource) {
        _menuDataSource = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    }
    return _menuDataSource;
}
#pragma mark - 导航栏右侧关闭按钮点击事件

- (void)navCloseBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delegate

//一共有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.menuDataSource[1]) {
        return 2;
    }else
    {
        return 1;
    }
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.menuDataSource[0] count];
    } else {
        return [self.menuDataSource[1] count];
    }
}

//每一个cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColumnCell" forIndexPath:indexPath];
    
    NSMutableArray *sectionAry = self.menuDataSource[indexPath.section];
    __weak typeof(self) weakSelf = self;
    [cell configUIWithData:sectionAry[indexPath.row] closeBtn:^(ColumnModel *model) {
        [weakSelf colseBtnClick:model];
    }];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
         __weak typeof(self) weakSelf = self;
        
        if (indexPath.section == 0 && _headViewOne)  {
            return _headViewOne;
        }else if (indexPath.section == 1 && _headViewTwo){
            return _headViewTwo;
        }
        
        ColumnHeadView *headView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ColumnHeadView" forIndexPath:indexPath];
        headView.editBtnBlock = ^() {
            [weakSelf clickEditBtn];
        };
    
            if (indexPath.section == 0) {
                
                headView.biaotiLab.text = @"已选频道";
                headView.tishiLab.text = @"按住拖动调整排序";
                headView.editBtn.hidden = NO;
                _editBtn = headView.editBtn;
                _headViewOne = headView;
            }else
            {
                headView.biaotiLab.text = @"频道推荐";
                headView.tishiLab.text = @"点击添加频道";
                headView.editBtn.hidden = YES;
                _headViewTwo = headView;
            }
        
        return headView;
    }else
    {
        return nil;
    }
    
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

//头部视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
        return CGSizeMake(self.view.width, 40);
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    return CGSizeMake(0, 0);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.collectionView.width * 0.25 - 10, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    ColumnModel *model;
    if (indexPath.section == 0) {
        model = self.menuDataSource[0][indexPath.item];
        //判断是否为编辑状态
        if (!_headViewOne.editBtn.selected) { // 非编辑状态直接会上一级,返回title
            if (self.clickMenuCellBlock) {
                self.clickMenuCellBlock(model.title);
            }
            [self navCloseBtnClick];
        }else
        {
            //编辑状态
            if (model.resident) { // 不可删除
                return;
            }
            
            model.selected = NO;
            model.showAdd = YES;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];

            [self.menuDataSource[0] removeObjectAtIndex:indexPath.row];
            [self.menuDataSource[1] insertObject:model atIndex:0];
            
            NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];

        }
    }else
    {
        model = self.menuDataSource[1][indexPath.item];
        model.showAdd = NO;
        model.selected = _headViewOne.editBtn.selected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];

        [self.menuDataSource[1] removeObjectAtIndex:indexPath.item];
        [self.menuDataSource[0] addObject:model];
        
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:[self.menuDataSource[0] count]-1 inSection:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }
}


//在开始移动是调动此代理方法
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"开始移动");
    return YES;
}

//在移动结束的时候调用此代理方法

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 取出数据源
    ColumnModel *model;
    if (sourceIndexPath.section == 0) {
        model = self.menuDataSource[0][sourceIndexPath.item];
        [self.menuDataSource[0] removeObjectAtIndex:sourceIndexPath.item];
    } else {
        model = self.menuDataSource[1][sourceIndexPath.item];
        [self.menuDataSource[1] removeObjectAtIndex:sourceIndexPath.item];
    }
    
    if (destinationIndexPath.section == 0) {
        model.selected = YES;
        model.showAdd = NO;
        [self.menuDataSource[0] insertObject:model atIndex:destinationIndexPath.item];
    } else  if (destinationIndexPath.section == 1) {
        model.selected = NO;
        model.showAdd = YES;
        [self.menuDataSource[1] insertObject:model atIndex:destinationIndexPath.item];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];

    
}

#pragma mark -Action
//关闭按钮点击事件  
- (void)colseBtnClick:(ColumnModel *)model;
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForItem:[self.menuDataSource[0] indexOfObject:model] inSection:0] ;
    model.selected = NO;
    model.showAdd = YES;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];

    [self.menuDataSource[0] removeObject:model];
    [self.menuDataSource[1] insertObject:model atIndex:0];
    
    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];

}
// 点击编辑按钮
- (void)clickEditBtn
{
    _headViewOne.editBtn.selected = !_headViewOne.editBtn.selected;
    for (ColumnModel *model in self.menuDataSource[0]) {
        if (model.resident) {
            continue;
        }
        model.selected = _headViewOne.editBtn.selected;
    }
    [self.collectionView reloadData];
}


@end
