//
//  FSInfiniteDatas.m
//  FSBaseController
//
//  Created by FudonFuchina on 2021/8/8.
//

#import "FSInfiniteDatas.h"

@implementation FSInfiniteDatas

- (FSInfiniteDatas *)sub {
    if (!_sub) {
        _sub = [[FSInfiniteDatas alloc] init];
    }
    return _sub;
}

@end
