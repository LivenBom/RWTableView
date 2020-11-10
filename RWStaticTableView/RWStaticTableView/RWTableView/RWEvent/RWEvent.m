//
//  RWEvent.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWEvent.h"

@implementation RWEvent
@synthesize indexPath = _indexPath;
@synthesize sender = _sender;
@synthesize userInfo = _userInfo;

- (instancetype)init {
    self = [super init];
    if (self) {
        _userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
