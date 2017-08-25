//
//  ZWHSettingTableView.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZWHSettingTableViewDelegate <NSObject>

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)changeFlyModel:(BOOL)model;
@end

@interface ZWHSettingTableView : UIView

@property(nonatomic, strong) NSArray *titleArr;          //

@property(nonatomic, weak) id<ZWHSettingTableViewDelegate> delegate;          //

@property(nonatomic, assign)UITableViewCellAccessoryType accessoryType;

@property(nonatomic, strong) UITableView *tableView;          //

@end
