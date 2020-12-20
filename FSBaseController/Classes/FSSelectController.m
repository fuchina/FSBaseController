//
//  FSSelectController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/6/10.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSSelectController.h"

@interface FSSelectController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSSelectController{
    NSMutableArray  *_multis;
}

- (void)confirmSelected{
    if (self.multiSelectCallback) {
        self.multiSelectCallback(self, _multis, _array);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (_isMultiSelect) {
        _multis = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmSelected)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _fs_statusAndNavigatorHeight(), WIDTHFC, HEIGHTFC - _fs_statusAndNavigatorHeight()) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 55;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (_configCell) {
        _configCell(cell,indexPath,_array);
    }else{        
        cell.textLabel.text = _array[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (_isMultiSelect) {
        if ([_multis containsObject:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isMultiSelect) {
        if (![_multis containsObject:indexPath]) {
            [_multis addObject:indexPath];
        }else{
            [_multis removeObject:indexPath];
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        if (_block) {
            _block(self,indexPath,_array);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
