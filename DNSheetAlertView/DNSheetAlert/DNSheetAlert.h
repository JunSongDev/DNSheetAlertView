//
//  DNSheetAlert.h
//  163Music
//
//  Created by zjs on 2018/7/31.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
// 申明代理方法
@protocol DNSheetAlertDelegate <NSObject>
@required;
- (void)dnSheetAlertSelectedIdentifier:(NSString *)identifier selectIndex:(NSIndexPath *)selectIndex;
@end

@interface DNSheetAlert : UIView

@property (nonatomic, weak) id <DNSheetAlertDelegate> delegate;

+ (instancetype)shareInstance;

- (void)alertWithData:(NSArray *)data Delegate:(id<DNSheetAlertDelegate>)delegate;

@end

@interface DNSheetAlertCell : UITableViewCell


@end
