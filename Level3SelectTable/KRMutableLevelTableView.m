//
//  KRMutableLevelTableView.m
//  Level3SelectTable
//
//  Created by qi777 on 16/12/15.
//  Copyright © 2016年 Jzhang. All rights reserved.
//

#import "KRMutableLevelTableView.h"

#define screenwidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define screenheight CGRectGetHeight([UIScreen mainScreen].bounds)


@interface KRMutableLevelModel : NSObject

@property (nonatomic, assign)BOOL isExpand;

@property (nonatomic, copy)NSString * title;

@property (nonatomic, strong)NSArray * subModels;

@end

@implementation KRMutableLevelModel

@end

@implementation KRMutableLevelTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self setDatas];
        [self tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    KRMutableLevelModel * model = self.datas[section];
    if (model.isExpand) {
        NSArray * arr = _showDatas[section];
        return arr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
        
    }
    NSArray * array = self.showDatas[indexPath.section];
//    NSLog(@"%@",array);
    NSArray * indexArr = self.indexes[indexPath.section];
    if ([array[indexPath.row] isKindOfClass:[KRMutableLevelModel class]]) {
        NSInteger indx = 0;
        for (NSInteger i = 0; i < indexArr.count; i ++) {
            if ([indexArr[i] integerValue] == indexPath.row) {
                indx = i;
                break;
            }
        }
        if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(viewForSecondInSubRoot:root:)]) {
            cell.backgroundView = [self.MTVdelegate viewForSecondInSubRoot:indx root:indexPath.section];
        }

        
    }else {
        NSInteger indx = 0;
        NSInteger uindx = 0;
        for (NSInteger i = 0; i < indexArr.count; i ++) {
//            NSLog(@"%ld-%@",indexPath.row, indexArr[i]);
            if (i == indexArr.count - 1) {
                uindx = i;
                indx = indexPath.row - 1 - [indexArr[i] integerValue];
                break;
            }
            if ([indexArr[i + 1] integerValue] > indexPath.row - 1) {
                uindx = i;
                indx = indexPath.row - 1 - [indexArr[i] integerValue];
//                NSLog(@"%ld-%ld-%ld",indexPath.section, uindx, indx);
                break;
            }
        }
        if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(viewForThirdInUnderlRoot:subRoot:Root:)]) {
            cell.backgroundView = [self.MTVdelegate viewForThirdInUnderlRoot:indx subRoot:uindx Root:indexPath.section];
        }
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.textLabel.text = array[indexPath.row];
    }
    return cell;
}

- (void)reloadIndexes {
    [self.indexes removeAllObjects];
    
    for (NSArray * array in self.showDatas) {
        NSMutableArray * showdatas = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i ++) {
            if ([array[i] isKindOfClass:[KRMutableLevelModel class]]) {
                [showdatas addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        [self.indexes addObject:showdatas];
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionView;
//    if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(titleOfRootList)]) {
////        label.text = [self.MTVdelegate titleOfRootList][section];

//    }
    if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(viewForFirstInRoot:)]) {
        //        label.text = [self.MTVdelegate titleOfRootList][section];
        sectionView = [self.MTVdelegate viewForFirstInRoot:section];
    }
    sectionView.tag = section;
    [sectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRootView:)]];
    return sectionView;
}

- (void)clickRootView:(UITapGestureRecognizer *)tap {
    UIView * view = tap.view;
    NSInteger index = view.tag;
    KRMutableLevelModel * model = self.datas[index];
    model.isExpand = !model.isExpand;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index];
    [self reloadIndexes];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(heightForSubRoot:Root:)] && [self.MTVdelegate respondsToSelector:@selector(heightForUnderlRoot:subRoot:Root:)]) {
        NSArray * shows = self.showDatas[indexPath.section];
        NSArray * indexArr = [self.indexes objectAtIndex:indexPath.section];
        NSInteger indx = 0;
        NSInteger uindx = 0;
        for (NSInteger i = 0; i < indexArr.count; i ++) {
            //            NSLog(@"%ld-%@",indexPath.row, indexArr[i]);
            if (i == indexArr.count - 1) {
                uindx = i;
                indx = indexPath.row - 1 - [indexArr[i] integerValue];
                break;
            }
            if ([indexArr[i + 1] integerValue] > indexPath.row - 1) {
                uindx = i;
                indx = indexPath.row - 1 - [indexArr[i] integerValue];
                //                NSLog(@"%ld-%ld-%ld",indexPath.section, uindx, indx);
                break;
            }
        }
        if ([shows[indexPath.row] isKindOfClass:[KRMutableLevelModel class]]) {
            return [self.MTVdelegate heightForSubRoot:indx Root:indexPath.section];
        }else {
            return [self.MTVdelegate heightForUnderlRoot:indexPath.section subRoot:uindx Root:indx];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(heightForRoot:)]) {
        return [self.MTVdelegate heightForRoot:section];
    }
    return .1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * arr = _showDatas[indexPath.section];
    if ([arr[indexPath.row] isKindOfClass:[KRMutableLevelModel class]]) {
        KRMutableLevelModel * model = arr[indexPath.row];
        [self reloadDataSourceWith:indexPath isExpand:model.isExpand];
        
        model.isExpand = !model.isExpand;
    }else {
        if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(didSelectRowAtUnderlRoot:subRoot:Root:)]) {
            NSArray * indexArr = self.indexes[indexPath.section];
            NSInteger uindx = 0;
            NSInteger indx = 0;
            for (NSInteger i = 0; i < indexArr.count; i ++) {
                //            NSLog(@"%ld-%@",indexPath.row, indexArr[i]);
                if (i == indexArr.count - 1) {
                    uindx = i;
                    indx = indexPath.row - 1 - [indexArr[i] integerValue];
                    break;
                }
                if ([indexArr[i + 1] integerValue] > indexPath.row - 1) {
                    uindx = i;
                    indx = indexPath.row - 1 - [indexArr[i] integerValue];
//                    NSLog(@"%ld-%ld-%ld",indexPath.section, uindx, indx);
                    break;
                }
            }
            [self.MTVdelegate didSelectRowAtUnderlRoot:indx subRoot:uindx Root:indexPath.section];
        }
    }
}

- (void)reloadDataSourceWith:(NSIndexPath *)indexPath isExpand:(BOOL)isExpand{
    KRMutableLevelModel * arr = self.datas[indexPath.section];
    [self.reloadArray removeAllObjects];
    if (isExpand) {
        KRMutableLevelModel * model = arr.subModels[indexPath.row];
        for (int i = 0; i < model.subModels.count; i ++) {
            [self.showDatas[indexPath.section] removeObjectAtIndex:indexPath.row + 1];
            NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:indexPath.section];
            [self.reloadArray addObject:index];
        }
        [self reloadIndexes];
        [self.tableView deleteRowsAtIndexPaths:self.reloadArray withRowAnimation:UITableViewRowAnimationNone];
    }else {
        KRMutableLevelModel * model = arr.subModels[indexPath.row];
        for (int i = 0; i < model.subModels.count; i ++) {
            [self.showDatas[indexPath.section] insertObject:model.subModels[i] atIndex:indexPath.row + i + 1];
            NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:indexPath.section];
            [self.reloadArray addObject:index];
        }
        [self reloadIndexes];
        [self.tableView insertRowsAtIndexPaths:self.reloadArray withRowAnimation:UITableViewRowAnimationNone];
    }
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
//    [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//    [self reloadData];
}

- (void)foldNodesForcurrentIndex:(NSIndexPath *)currentIndex{
    KRMutableLevelModel * model = _datas[currentIndex.section];
    NSArray * array = _showDatas[currentIndex.section];
    if (currentIndex.row+1 < array.count) {
        NSMutableArray *tempArr = [model.subModels copy];
        [self.moveArr removeAllObjects];
        for (NSUInteger i = currentIndex.row + 1 ; i < tempArr.count;i++) {
                [self.moveArr addObject:[NSIndexPath indexPathForRow:i inSection:currentIndex.section]];//need reload nodes
        }
    }
}

- (NSInteger)getRowInSection:(NSIndexPath *)indexPath {
    NSInteger indx = 0;
    for (NSInteger i = 0; i < self.indexes.count; i ++) {
        if ([self.indexes[i] integerValue] == indexPath.row) {
            indx = i;
            break;
        }
    }
    return indx;
}

- (void)reloadData{
    [self setDatas];
    [self.tableView reloadData];
}

//expand
- (NSUInteger)expandNodesinsertIndex:(NSIndexPath *)indexPath{
    KRMutableLevelModel * model = self.datas[indexPath.section];
    NSArray * modelArray = model.subModels;
    NSIndexPath * insertIndex ;
    for (int i = 0 ; i<modelArray.count;i++) {
        NSInteger row = indexPath.row;
        row ++;
        insertIndex = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        [self.showDatas insertObject:modelArray[insertIndex.row - 1] atIndex:insertIndex.row];
        [self.moveArr addObject:[NSIndexPath indexPathForRow:insertIndex.row inSection:insertIndex.section]];//need reload nodes
    }
    return insertIndex.row;
}

- (void)setDatas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    if (!_showDatas) {
        _showDatas = [[NSMutableArray alloc] init];
    }
//    if (![datas.firstObject isKindOfClass:[NSArray class]]) {
//        return;
//    }else {
//        NSArray * subDatas = datas.firstObject;
//        if (![subDatas.firstObject isKindOfClass:[NSArray class]]) {
//            return;
//        }else {
//            NSArray * bottomDatas = subDatas.firstObject;
//            if ([bottomDatas.firstObject isKindOfClass:[NSArray class]]) {
//                return;
//            }
//        }
//    }
    [_datas removeAllObjects];
//    NSLog(@"%ld",[self.MTVdelegate numberOfFirstSection]);
    for (int i = 0; i < [self.MTVdelegate numberOfFirstSection]; i ++) {
        KRMutableLevelModel * model = [[KRMutableLevelModel alloc] init];
        model.isExpand = NO;
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (int j = 0; j < [self.MTVdelegate numberOfSecondSectionIn:i]; j++) {
            KRMutableLevelModel * submodel = [[KRMutableLevelModel alloc] init];
            NSMutableArray * underlyArr = [[NSMutableArray alloc] init];
            for (int k = 0; k < [self.MTVdelegate numberOfThirdSectionIn:j root:i]; k ++) {
                [underlyArr addObject:@"1"];
            }
            submodel.isExpand = NO;
            submodel.subModels = underlyArr;
            [array addObject:submodel];
        }
        [_showDatas addObject:array];
        model.subModels = array;
        [_datas addObject:model];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)indexes {
    if (!_indexes) {
        _indexes = [[NSMutableArray alloc] init];
    }
    return _indexes;
}

- (NSMutableArray *)moveArr {
    if (!_moveArr) {
        _moveArr = [[NSMutableArray alloc] init];
    }
    return _moveArr;
}

- (NSMutableArray *)reloadArray {
    if (!_reloadArray) {
        _reloadArray = [[NSMutableArray alloc] init];
    }
    return _reloadArray;
}

- (CGFloat)headerViewHeight {
    if (self.MTVdelegate && [self.MTVdelegate respondsToSelector:@selector(heightForRoot:)]) {
        return [self.MTVdelegate heightForRoot:0];
    }
    return 0;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
