//
//  KRMutableLevelTableView.h
//  Level3SelectTable
//
//  Created by qi777 on 16/12/15.
//  Copyright © 2016年 Jzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KRMutableLevelTableViewDelegate <NSObject>

- (CGFloat)heightForUnderlRoot:(NSInteger)underlRoot subRoot:(NSInteger)subRoot Root:(NSInteger)root;
- (CGFloat)heightForSubRoot:(NSInteger)subRoot Root:(NSInteger)root;
- (CGFloat)heightForRoot:(NSInteger)root;

- (void)didSelectRowAtUnderlRoot:(NSInteger)underlRoot subRoot:(NSInteger)subRoot Root:(NSInteger)root;

- (NSInteger)numberOfFirstSection;
- (NSInteger)numberOfSecondSectionIn:(NSInteger)root;
- (NSInteger)numberOfThirdSectionIn:(NSInteger)subRoot root:(NSInteger)root;

- (UIView *)viewForFirstInRoot:(NSInteger)root;
- (UIView *)viewForSecondInSubRoot:(NSInteger)subRoot root:(NSInteger)root;
- (UIView *)viewForThirdInUnderlRoot:(NSInteger)underlRoot subRoot:(NSInteger)subRoot Root:(NSInteger)root;

@end

@protocol KRMutableLevelTableViewDataSource <NSObject>

//
@end

@interface KRMutableLevelTableView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, weak)id<KRMutableLevelTableViewDelegate>MTVdelegate;
@property (nonatomic, strong)NSMutableArray * datas;

@property (nonatomic, strong)NSMutableArray * showDatas;

@property (nonatomic, strong)NSMutableArray * moveArr;

@property (nonatomic, strong)NSMutableArray * reloadArray;

@property (nonatomic, strong)NSMutableArray * parentsTitles;

@property (nonatomic, assign)CGFloat headerViewHeight;

@property (nonatomic, strong)NSMutableArray * indexes;

- (void)reloadData;

@end
