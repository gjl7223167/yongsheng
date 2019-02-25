//
//  UITableView+Ant.h
//  AntLive
//
//  Created by Long on 2018/11/6.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Ant)
- (__kindof UITableViewCell <TableViewCellProtocol> *)ant_rowHeightCalculateCellForClass:(Class <TableViewCellProtocol>)aClass;

@end

NS_ASSUME_NONNULL_END
