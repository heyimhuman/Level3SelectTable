//
//  ViewController.m
//  Level3SelectTable
//
//  Created by qi777 on 16/12/15.
//  Copyright © 2016年 Jzhang. All rights reserved.
//

#import "ViewController.h"
#import "KRMutableLevelTableView.h"

@interface ViewController ()<KRMutableLevelTableViewDelegate> {
    NSMutableArray * _rootTitles;
    NSMutableArray * _subRootTitles;
    NSMutableArray * _datas;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"三层TableView";
    _rootTitles = [[NSMutableArray alloc] init];
    _subRootTitles = [[NSMutableArray alloc] init];
    _datas = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    KRMutableLevelTableView * krTableView = [[KRMutableLevelTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 64)];
    krTableView.MTVdelegate = self;
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary * dic in array) {
        NSArray * subarray = [dic objectForKey:@"cities"];
        NSMutableArray * subarr = [[NSMutableArray alloc] init];
        NSMutableArray * subTitleArr = [[NSMutableArray alloc] init];
        for (NSDictionary * subdic in subarray) {
            NSArray * arr = [subdic objectForKey:@"areas"];
            [subTitleArr addObject:[subdic objectForKey:@"city"]];
            [subarr addObject:arr];
        }
        [_subRootTitles addObject:subTitleArr];
        [_rootTitles addObject:[dic objectForKey:@"state"]];
        [_datas addObject:subarr];
    }
    [krTableView reloadData];
//    krTableView.datas = _datas;
    [self.view addSubview:krTableView];
}

- (NSMutableArray *)getArray {
    NSArray * arr1 = @[@"1", @"2", @"3"];
    NSArray * arr2 = @[@"2", @"3", @"4"];
    NSArray * arr3 = @[@"3", @"4", @"5"];
    NSArray * arR1 = @[arr1, arr2];
    NSArray * arR2 = @[arr3];
    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:@[arR1, arR2]];
    return arr;
}

- (NSInteger)numberOfFirstSection {
    return _datas.count;
}

- (NSInteger)numberOfSecondSectionIn:(NSInteger)root {
    NSArray * arr = _datas[root];
    return arr.count;
}

- (NSInteger)numberOfThirdSectionIn:(NSInteger)subRoot root:(NSInteger)root{
    NSArray * arr = _datas[root];
    NSArray * subArr = arr[subRoot];
    return subArr.count;
}

- (CGFloat)heightForRoot:(NSInteger)root{
    return 50;
}
- (CGFloat)heightForUnderlRoot:(NSInteger)underlRoot subRoot:(NSInteger)subRoot Root:(NSInteger)root{
    return 50;
}
- (CGFloat)heightForSubRoot:(NSInteger)subRoot Root:(NSInteger)root {
    return 50;
}
- (void)didSelectRowAtUnderlRoot:(NSInteger)underlRoot subRoot:(NSInteger)subRoot Root:(NSInteger)root{
    NSLog(@"%ld-%ld-%ld",root, subRoot, underlRoot);
}

- (UIView *)viewForFirstInRoot:(NSInteger)root {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
    view.backgroundColor = [UIColor grayColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(view.frame) - 20, CGRectGetHeight(view.frame))];
    label.text = _rootTitles[root];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}

- (UIView *)viewForSecondInSubRoot:(NSInteger)subRoot root:(NSInteger)root {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(view.frame) - 20, CGRectGetHeight(view.frame))];
    NSArray * arr = _subRootTitles[root];
    label.text = arr[subRoot];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}

- (UIView *)viewForThirdInUnderlRoot:(NSInteger)underlRoot subRoot:(NSInteger)subRoot Root:(NSInteger)root {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(view.frame) - 20, CGRectGetHeight(view.frame))];
    label.text = _datas[root][subRoot][underlRoot];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    return view;
}

- (NSArray *)titleOfSubRootList {
    return _subRootTitles;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
