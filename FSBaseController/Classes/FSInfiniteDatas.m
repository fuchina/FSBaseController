//
//  HEInfiniteFrames.m
//  ModuleOxfordUtils
//
//  Created by 扶冬冬 on 2021/7/3.
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
