//
//  CallRecordViewController.h
//  RongCallKitQuickStart
//
//  Created by liulinhong on 2021/9/9.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CallRecordDelegate <NSObject>

- (NSString *)getRemoteUserId;

@end

@interface CallRecordViewController : UIViewController

@property (nonatomic, weak) id<CallRecordDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
