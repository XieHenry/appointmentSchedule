//
//  ViewController.m
//  demo
//
//  Created by XieHenry on 2017/5/10.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "ViewController.h"
#import "TimeCollectionViewCell.h"
#import "UIView+Layout.h"

static inline UIColor *UICOLOR_FROM_HEX(NSInteger hex)
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
/**
 @abstract 获取本机屏幕的宽度.   考虑到横屏的宽高比
 **/
static inline CGFloat SCREEN_WIDTH()
{
    return [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}
/**
 @abstract 获取本机屏幕的高度.   考虑到横屏的宽高比
 **/
static inline CGFloat SCREEN_HEIGHT()
{
    return [UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ?
    [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}

#define Color666666 0x666666
#define ColorFFFFFF 0xFFFFFF  //白色
#define Color999999 0x999999

/*
 比例
 */
// 屏幕高度 考虑到横屏的宽高比
#define XMGHeight SCREEN_HEIGHT()
// 屏幕宽度 考虑到横屏的宽高比
#define XMGWidth SCREEN_WIDTH()
// 以iPhone5为基准(UI妹纸给你的设计图是iPhone5的),当然你也可以改,但是出图是按照7P(6P)的图片出的,因为大图压缩还是清晰的,小图拉伸就不清晰了,所以只出一套最大的图片即可
#define XMGiPhone6W 375.0
#define XMGiPhone6H 667.0
// 计算比例
// x比例 1.293750 在iPhone7的屏幕上
#define XMGScaleX XMGWidth / XMGiPhone6W
// y比例 1.295775
#define XMGScaleY XMGHeight / XMGiPhone6H
// X坐标
#define LineX(l) l*XMGScaleX
// Y坐标
#define LineY(l) l*XMGScaleY
//width比例
#define LineW(l) l*XMGScaleX
//height比例
#define LineH(l) l*XMGScaleY
// 字体
#define Font(x) [UIFont systemFontOfSize:x*XMGScaleX]



@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
//年月日
@property (nonatomic, strong) NSMutableArray *yearsArray;
//周几
@property (nonatomic, strong) NSMutableArray *weeksArray;

@property (nonatomic, strong) UIScrollView *bgScrollerView;

@property (nonatomic, strong) UIScrollView *headerScrollerView;

@property (nonatomic, strong) NSArray *alltimeArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"时间预约表";
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initDataSource];
    
    
    [self initContentView];

}


- (void)initDataSource {
    
    //对头部的时间数据进行创建
    self.yearsArray = [NSMutableArray array];
    //对头部的周几数据进行创建
    self.weeksArray = [NSMutableArray array];

    //获取2周的数据
    for (int i = 0; i < 14; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        //组合时间
        [self.yearsArray addObject:dateStr];
        [self.weeksArray addObject:weekStr];
    }
    

    
    //14天时间 85*14
    _headerScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH(), LineH(44))];
    _headerScrollerView.contentSize = CGSizeMake(LineW(85)*14,LineH(44));
    _headerScrollerView.scrollEnabled = YES;
    _headerScrollerView.showsVerticalScrollIndicator = NO;
    _headerScrollerView.showsHorizontalScrollIndicator = NO;
    _headerScrollerView.pagingEnabled = NO;
    _headerScrollerView.bounces = NO;
    _headerScrollerView.delegate = self;
    _headerScrollerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_headerScrollerView];
    

    for (NSUInteger i =  0; i < self.weeksArray.count; i++) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(LineW(85)*i, 0, LineW(85), LineH(44))];
        [_headerScrollerView addSubview:headerView];
        
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, LineY(10), LineW(85), LineH(12))];
        weekLabel.text = self.weeksArray[i];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = Font(12);
        weekLabel.textColor = UICOLOR_FROM_HEX(Color666666);
        [headerView addSubview:weekLabel];
        
        
        UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,weekLabel.y+weekLabel.height+LineY(8), LineW(85), LineH(11))];
        monthLabel.text = self.yearsArray[i];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = Font(12);
        weekLabel.textColor = UICOLOR_FROM_HEX(Color999999);
        [headerView addSubview:monthLabel];
    }
    
}

#pragma mark 数据创建
- (void)initContentView {
    
    //14天时间 85*14
    _bgScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_headerScrollerView.y+_headerScrollerView.height,SCREEN_WIDTH(), SCREEN_HEIGHT()-64-LineH(44))];
    _bgScrollerView.contentSize = CGSizeMake(LineW(85)*14,31*LineH(52));
    _bgScrollerView.scrollEnabled = YES;
    _bgScrollerView.showsVerticalScrollIndicator = NO;
    _bgScrollerView.showsHorizontalScrollIndicator = NO;
    _bgScrollerView.pagingEnabled = NO;
    _bgScrollerView.delegate = self;
    _bgScrollerView.bounces = NO;
    _bgScrollerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_bgScrollerView];
    

    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置每个item的大小
    layout.itemSize = CGSizeMake(LineW(1), LineH(1));
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 9.f, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LineW(85)*14, 31*LineH(52)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;
    [_bgScrollerView addSubview:_collectionView];
    
    
    [_collectionView registerClass:[TimeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    _alltimeArray = @[@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30"];
    
    
//    [_collectionView reloadData];
    
}

//设置两个UIScrollView联动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if(scrollView == self.headerScrollerView) {
        
        CGFloat offsetY = self.headerScrollerView.contentOffset.x;
        CGPoint offset = self.bgScrollerView.contentOffset;
        offset.x = offsetY;
        self.bgScrollerView.contentOffset = offset;
        
        
    } else {
        CGFloat offsetY = self.bgScrollerView.contentOffset.x;
        CGPoint offset = self.headerScrollerView.contentOffset;
        offset.x = offsetY;
        self.headerScrollerView.contentOffset = offset;

    }
        
}


- (void)tableView:(UITableView *)tableView scrollFollowTheOther:(UITableView *)other{
    CGFloat offsetY= other.contentOffset.y;
    CGPoint offset=tableView.contentOffset;
    offset.y=offsetY;
    tableView.contentOffset=offset;
}

#pragma mark 以下是UICollectionView的代理
//section 的个数 //返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 14;
}

//cell的个数 //返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _alltimeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    TimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"-----------------");
    }
    
    for (NSUInteger i = 0; i< _alltimeArray.count; i++) {
        if (indexPath.row == i) {
            cell.timeLabel.text = _alltimeArray[i];
            cell.timeLabel.textColor = [UIColor blackColor];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",@(indexPath.row).description);
}

#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LineW(85), LineH(52));
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0,0);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}


@end
