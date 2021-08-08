//
//  FSBaseManager.m
//  FSBaseController
//
//  Created by FudonFuchina on 2021/8/8.
//

#import "FSBaseManager.h"

@implementation FSBaseManager

- (FSInfiniteDatas *)infiniteDatas {
    if (!_infiniteDatas) {
        _infiniteDatas = [[FSInfiniteDatas alloc] init];
    }
    return _infiniteDatas;
}

@end
