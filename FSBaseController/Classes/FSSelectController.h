//
//  FSSelectController.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/6/10.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"

@interface FSSelectModel : NSObject

@property (nonatomic, assign) BOOL          selected;

@property (nonatomic, copy) NSString        *content_id;            // 内容的id
@property (nonatomic, copy) NSString        *content_show;          // 文字显示内容

+ (NSArray<FSSelectModel *> *)fastModelsWithTexts:(NSArray<NSString *> *)texts;

@end

@class FSSelectController;
typedef void(^FSSelectControllerBlock)(FSSelectController *bSelectController, NSIndexPath *bIndexPath, NSArray<FSSelectModel *> *bArray);

@interface FSSelectController : FSBaseController

@property (nonatomic,strong) NSArray<FSSelectModel *>       *models;

@property (nonatomic,copy) void (^configCell)(UITableViewCell *bCell, NSIndexPath *bIndexPath, NSArray<FSSelectModel *> *bArray);

// 单选的回调
@property (nonatomic,copy) FSSelectControllerBlock          block;

// 多选的回调
@property (nonatomic,copy) void (^multiSelectCallback)(FSSelectController *bSelectController, NSArray<FSSelectModel *> *bArray);

@end
