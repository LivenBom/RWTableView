//
//  RWButtonCellViewModel.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWButtonCellViewModel.h"
#import "RWButtonCell.h"

@implementation RWButtonCellViewModel
@synthesize cellClass = _cellClass;
@synthesize cellHeight = _cellHeight;

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellClass = RWButtonCell.class;
        _cellHeight = 44;
    }
    return self;
}

@end
