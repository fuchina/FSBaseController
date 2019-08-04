//
//  FSSelectController.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/6/10.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"

@class FSSelectController;
typedef void(^FSSelectControllerBlock)(FSSelectController *bSelectController,NSIndexPath *bIndexPath,NSArray *bArray);

@interface FSSelectController : FSBaseController

// 是否时是多选模式
@property (nonatomic,assign) BOOL                           isMultiSelect;

@property (nonatomic,strong) NSArray                        *array;

// 单选的回调
@property (nonatomic,copy) FSSelectControllerBlock          block;

// 多选的回调
@property (nonatomic,copy) void (^multiSelectCallback)(FSSelectController *bSelectController,NSArray<NSIndexPath *> *selecteds,NSArray *bArray);

@property (nonatomic,copy) void (^configCell)(UITableViewCell *bCell,NSIndexPath *bIndexPath,NSArray *bArray);

@end
