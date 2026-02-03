////
////  FSSelectController.m
////  ShareEconomy
////
////  Created by FudonFuchina on 16/6/10.
////  Copyright © 2016年 FudonFuchina. All rights reserved.
////
//
//#import "FSSelectController.h"
//
//@implementation FSSelectModel
//
//+ (NSArray<FSSelectModel *> *)fastModelsWithTexts:(NSArray<NSString *> *)texts {
//    if (![texts isKindOfClass:NSArray.class]) {
//        return nil;
//    }
//    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:texts.count];
//    for (int x = 0; x < texts.count; x ++) {
//        NSString *txt = texts[x];
//        
//        FSSelectModel *m = [[FSSelectModel alloc] init];
//        m.content_id = txt;
//        m.content_show = txt;
//        [list addObject:m];
//    }
//    return list.copy;
//}
//
//+ (NSArray<FSSelectModel *> *)selectedModelsFromModels:(NSArray<FSSelectModel *> *)models {
//    NSMutableArray *list = [[NSMutableArray alloc] init];
//    for (int x = 0; x < models.count; x ++) {
//        FSSelectModel *m = models[x];
//        if (m.selected) {
//            [list addObject:m];
//        }
//    }
//    return list.copy;
//}
//
//@end
//
//@interface FSSelectController ()<UITableViewDelegate,UITableViewDataSource>
//
//@end
//
//@implementation FSSelectController
//
//- (void)confirmSelected {
//    if (self.multiSelectCallback) {
//        self.multiSelectCallback(self, [FSSelectModel selectedModelsFromModels:_models]);
//    }
//}
//
//- (void)componentWillMount {
//    [super componentWillMount];
//        
//    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmSelected)];
//    self.navigationItem.rightBarButtonItem = bbi;
//    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, HEIGHTFC) style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.rowHeight = 55;
//    tableView.tableFooterView = [UIView new];
//    tableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:tableView];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _models.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"i";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    
//    if (_configCell) {
//        _configCell(cell,indexPath,_models);
//    }
//    
//    FSSelectModel *m = _models[indexPath.row];
//    cell.textLabel.text = m.content_show;
//        
//    if (m.selected) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    FSSelectModel *m = _models[indexPath.row];
//    m.selected = !m.selected;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    
//    if (_block) {
//        _block(self, indexPath, [FSSelectModel selectedModelsFromModels:_models]);
//    }
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
