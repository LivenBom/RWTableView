//
//  RWTestCellViewModel.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWTestCellViewModel.h"
#import "RWTestCell.h"

@implementation RWTestCellViewModel
@synthesize cellClass = _cellClass;
@synthesize cellHeight = _cellHeight;

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellClass = RWTestCell.class;
        _cellHeight = 100;
    }
    return self;
}

@end
