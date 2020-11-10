//
//  RWTestCell.m
//  RWStaticTableView
//
//  Created by Liven on 2020/11/6.
//

#import "RWTestCell.h"
#import "RWTestCellViewModel.h"

@implementation RWTestCell

- (void)rw_setData:(RWTestCellViewModel *)data {
    self.textLabel.text = data.title;
    self.imageView.image = data.headerImage;
    self.backgroundColor = UIColor.lightGrayColor;
}

@end
