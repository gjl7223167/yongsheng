//
//  UITableView+Ant.m
//  AntLive
//
//  Created by Long on 2018/11/6.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import "UITableView+Ant.h"
#import <objc/runtime.h>
static const char * const ANT_CELL_HEIGHT_DICT = "ANT_CELL_HEIGHT_DICT";

@implementation UITableView (Ant)
- (__kindof UITableViewCell <TableViewCellProtocol> *)ant_rowHeightCalculateCellForClass:(Class <TableViewCellProtocol>)aClass{
    NSString * cellkay = NSStringFromClass(aClass);
    UITableViewCell<TableViewCellProtocol> * cell = [[self cellWithDict] objectForKey:cellkay];
    if (cell == nil) {
        if ([aClass conformsToProtocol:@protocol(TableViewCellProtocol)]) {
            cell = [aClass defaultCell];
            [[self cellWithDict] setObject:cell forKey:cellkay];
        }
    }
    return cell;
}

-(NSMutableDictionary *)cellWithDict{
    NSMutableDictionary * dic = objc_getAssociatedObject(self, &ANT_CELL_HEIGHT_DICT);
    if (dic == nil) {
        dic = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &ANT_CELL_HEIGHT_DICT, dic, OBJC_ASSOCIATION_RETAIN);
    }
    return dic;
}
@end
