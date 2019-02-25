//
//  TableViewCellProtocol.h
//  AntLive
//
//  Created by Long on 2018/11/6.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TableViewCellProtocol <NSObject>

@required
/**
 *  创建cell
 *
 *  @return 初始化之后的CELL
 */
+ (instancetype)defaultCell;
/**
 *  获取cell的高度
 *
 *  @param tableView cell所属的TableView
 *  @param indexPath IndexPath
 *  @param model     数据模型
 *
 *  @return 正确的行高
 */
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)model;
/**
 *  给CELL赋值数据模型
 *
 *  @param model 数据模型
 */
- (void)setupCellForModel:(id)model;

//@property (nonatomic, copy) void (^selectItem)(id model,NSInteger index);
@end

NS_ASSUME_NONNULL_END
