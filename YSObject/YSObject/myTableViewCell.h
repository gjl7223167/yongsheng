//
//  myTableViewCell.h
//  YSObject
//
//  Created by Long on 2019/2/23.
//  Copyright © 2019 Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellProtocol.h"
#import "UITableView+Ant.h"

NS_ASSUME_NONNULL_BEGIN

@interface myTableViewCell : UITableViewCell<TableViewCellProtocol>

-(void)isHiddenImage:(id )item;

@end

NS_ASSUME_NONNULL_END
