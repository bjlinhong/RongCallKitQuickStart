//
//  CallRecordViewController.m
//  RongCallKitQuickStart
//
//  Created by liulinhong on 2021/9/9.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "CallRecordViewController.h"
#import <RongIMLib/RongIMLib.h>
#import <RongCallLib/RongCallLib.h>
#import "RCCallKitUtility.h"

@interface CallRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation CallRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通话记录";
    self.view.backgroundColor = [UIColor redColor];
    
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initData {
    NSArray *tmpArray = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE
                                                                 targetId:[self.delegate getRemoteUserId]
                                                               objectName:@"RC:VCSummary"
                                                          oldestMessageId:0
                                                                    count:50];
    self.messageArray = [NSMutableArray arrayWithArray:tmpArray];
    [self.tableView reloadData];
}

- (void)initView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
                                                  style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *identifer = [NSString stringWithFormat:@"Cell%zd%zd", section, row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    RCMessage *rcMessage = (RCMessage *)self.messageArray[row];
    RCCallSummaryMessage *callMessage = (RCCallSummaryMessage *)rcMessage.content;
    if (callMessage.duration > 1000) {
        cell.textLabel.text =
            [NSString stringWithFormat:@"%@ %@", RCCallKitLocalizedString(@"VoIPCallTotalTime"),
                                       [RCCallKitUtility getReadableStringForTime:(long)(callMessage.duration / 1000)]];
    } else {
        cell.textLabel.text = [RCCallKitUtility getReadableStringForMessageCell:callMessage.hangupReason];
    }
    
    
    NSMutableString *detailedMsg = [NSMutableString string];
    if (rcMessage.messageDirection == MessageDirection_SEND) {
        [detailedMsg appendString:@"己方"];
    }
    else if (rcMessage.messageDirection == MessageDirection_RECEIVE) {
        [detailedMsg appendString:@"对方"];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:rcMessage.sentTime/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    [detailedMsg appendString:currentDateStr];
    
    cell.detailTextLabel.text = detailedMsg;
    
    return cell;
}

@end
