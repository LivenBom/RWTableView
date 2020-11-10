//
//  RWSectionModel.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWSectionModel.h"

@implementation RWSectionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemsArray = [[NSMutableArray alloc]init];
        _sectionHeaderHeight = CGFLOAT_MIN;
        _sectionFooterHeight = CGFLOAT_MIN;
    }
    return self;
}

@end
