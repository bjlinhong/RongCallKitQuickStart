//
//  ViewController.m
//  RongCallKitQuickStart
//
//  Created by LiuLinhong on 2019/10/10.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import "ViewController.h"
#import <RongIMLibCore/RongIMLibCore.h>
#import <RongCallKit/RongCallKit.h>
#import "RCCallRequestJoinMessage.h"
#import <RongRTCLib/RongRTCLib.h>
#import "CallRecordViewController.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController () <RCIMReceiveMessageDelegate, CallRecordDelegate>

@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *callUser1Id, *callUser2Id, *callUser3Id;
@property (nonatomic, strong) NSString *callUser1Token, *callUser2Token, *callUser3Token;
@property (nonatomic, assign) BOOL isContect1, isContect2, isContect3, isSingleCall;
@property (nonatomic, assign) RCCallMediaType mediaType;
@property (nonatomic, strong) UILabel *statusLabel, *infoLabel;
@property (nonatomic, strong) UIButton *callUser1Button, *callUser2Button, *callUser3Button;
@property (nonatomic, strong) UIButton *joinCallButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIButton *callRecordsButton;
@property (nonatomic, strong) UISwitch *audioVideoSwitch, *singleMultiSwitch;
@property (nonatomic, strong) UILabel *mediaLabel, *singleMultiLabel;
@property (nonatomic, strong) CallRecordViewController *callRecordViewController;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //User1
    self.callUser1Id = @"";    //请自定义User1的ID
    self.callUser1Token = @""; //请使用自定义User1的ID 生成User1的Token
    
    //User2
    self.callUser2Id = @"";    //请自定义User2的ID
    self.callUser2Token = @""; //请使用自定义User2的ID 生成User2的Token
        
    self.callUser3Id = @"";    //请自定义User3的ID
    self.callUser3Token = @""; //请使用自定义User3的ID 生成User3的Token

    self.targetId = @""; //群组ID, 只有在多人通话时才会用到, 单人通话时可以不填写, 发起多人通话时, 上面的两个用户必须在此群组targetId的群里, 且targetId不能为@"",否则无法正常通话
    
    self.isContect1 = NO;
    self.isContect2 = NO;
    self.isContect3 = NO;
    self.isSingleCall = YES;
    self.mediaType = RCCallMediaVideo;
    
    [[RCIMClient sharedRCIMClient] initWithAppKey:@""]; //请登录融云官网获取AppKey
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Verbose;
    [RCCall sharedRCCall]; //必须初始化, 否则无法收到来电
    [[RCCoreClient sharedCoreClient] registerMessageType:[RCCallRequestJoinMessage class]];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
    [self initUIView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initUIView {
    // 连接状态信息
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 40)];
    [self.view addSubview:self.statusLabel];
    
    // 连接IM服务按钮
    CGFloat buttonWidth = (kScreenWidth - 20 * 4) / 3;
    
    self.callUser1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callUser1Button.frame = CGRectMake(20, self.statusLabel.frame.origin.y + self.statusLabel.frame.size.height, buttonWidth, 40);
    self.callUser1Button.backgroundColor = [UIColor redColor];
    [self.callUser1Button setTitle:@"CallUser1" forState:UIControlStateNormal];
    [self.callUser1Button setTitle:@"CallUser1" forState:UIControlStateHighlighted];
    [self.callUser1Button addTarget:self action:@selector(callUser1ButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callUser1Button];
    
    self.callUser2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callUser2Button.frame = CGRectMake(20 * 2 + buttonWidth, self.statusLabel.frame.origin.y + self.statusLabel.frame.size.height, buttonWidth, 40);
    self.callUser2Button.backgroundColor = [UIColor redColor];
    [self.callUser2Button setTitle:@"CallUser2" forState:UIControlStateNormal];
    [self.callUser2Button setTitle:@"CallUser2" forState:UIControlStateHighlighted];
    [self.callUser2Button addTarget:self action:@selector(callUser2ButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callUser2Button];
    
    self.callUser3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callUser3Button.frame = CGRectMake(20 * 3 + buttonWidth * 2, self.statusLabel.frame.origin.y + self.statusLabel.frame.size.height, buttonWidth, 40);
    self.callUser3Button.backgroundColor = [UIColor redColor];
    [self.callUser3Button setTitle:@"CallUser3" forState:UIControlStateNormal];
    [self.callUser3Button setTitle:@"CallUser3" forState:UIControlStateHighlighted];
    [self.callUser3Button addTarget:self action:@selector(callUser3ButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callUser3Button];
    
    // 通话按钮
    self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callButton.frame = CGRectMake(40, self.callUser1Button.frame.origin.y + self.callUser1Button.frame.size.height + 20, 100, 60);
    self.callButton.backgroundColor = [UIColor greenColor];
    [self.callButton setTitle:@"发起呼叫" forState:UIControlStateNormal];
    [self.callButton setTitle:@"发起呼叫" forState:UIControlStateHighlighted];
    [self.callButton addTarget:self action:@selector(callButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callButton];
    
    self.callRecordsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callRecordsButton.frame = CGRectMake(40, self.callButton.frame.origin.y + self.callButton.frame.size.height + 20, 100, 60);
    self.callRecordsButton.backgroundColor = [UIColor blueColor];
    [self.callRecordsButton setTitle:@"通话记录" forState:UIControlStateNormal];
    [self.callRecordsButton setTitle:@"通话记录" forState:UIControlStateHighlighted];
    [self.callRecordsButton addTarget:self action:@selector(callRecordsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callRecordsButton];
    
    self.joinCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinCallButton.frame = CGRectMake(self.callButton.frame.origin.x + self.callButton.frame.size.width + 20, self.callButton.frame.origin.y + self.callButton.frame.size.height + 20, 100, 60);
    self.joinCallButton.backgroundColor = [UIColor orangeColor];
    [self.joinCallButton setTitle:@"主动加入" forState:UIControlStateNormal];
    [self.joinCallButton setTitle:@"主动加入" forState:UIControlStateHighlighted];
    [self.joinCallButton addTarget:self action:@selector(joinCallButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.joinCallButton];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(self.joinCallButton.frame.origin.x + self.joinCallButton.frame.size.width + 20, self.callButton.frame.origin.y + self.callButton.frame.size.height + 20, 100, 60);
    self.playButton.backgroundColor = [UIColor lightGrayColor];
    [self.playButton setTitle:@"播放视频" forState:UIControlStateNormal];
    [self.playButton setTitle:@"播放视频" forState:UIControlStateHighlighted];
    [self.playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    
    // 通话选项
    self.singleMultiLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.callButton.frame.origin.x + self.callButton.frame.size.width, self.callUser1Button.frame.origin.y + self.callUser1Button.frame.size.height + 24, 100, 24)];
    self.singleMultiLabel.text = @"单人通话";
    self.singleMultiLabel.textColor = [UIColor orangeColor];
    self.singleMultiLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.singleMultiLabel];
    
    self.singleMultiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230, self.callUser1Button.frame.origin.y + self.callUser1Button.frame.size.height + 20, 60, 32)];
    [self.singleMultiSwitch addTarget:self action:@selector(singleMultiSwitchAction) forControlEvents:UIControlEventValueChanged];
    [self.singleMultiSwitch setOn:YES];
    [self.view addSubview:self.singleMultiSwitch];
    
    self.mediaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.singleMultiLabel.frame.origin.x, self.singleMultiLabel.frame.origin.y + self.singleMultiLabel.frame.size.height + 18, 100, 24)];
    self.mediaLabel.text = @"视频通话";
    self.mediaLabel.textColor = [UIColor redColor];
    self.mediaLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.mediaLabel];
    
    self.audioVideoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230, self.singleMultiSwitch.frame.origin.y + self.singleMultiSwitch.frame.size.height + 12, 60, 32)];
    [self.audioVideoSwitch addTarget:self action:@selector(audioVideoSwitchAction) forControlEvents:UIControlEventValueChanged];
    [self.audioVideoSwitch setOn:YES];
    [self.view addSubview:self.audioVideoSwitch];
    
    // 操作提示
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.joinCallButton.frame.origin.y + self.joinCallButton.frame.size.height + 20, kScreenWidth, 360)];
    self.infoLabel.backgroundColor = [UIColor yellowColor];
    self.infoLabel.font = [UIFont systemFontOfSize:14];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.infoLabel.text = @"  操作步骤:\n  1. 第一个手机点CallUser1连接IM\n  2. 第二个手机点CallUser2连接IM\n  3. 两个手机都连接成功之后, 点击 发起呼叫\n  4. CallUser3用于当CallUser1和CallUser2已经建立群通话后, CallUser3主动加入群通话\n\n  使用说明:\n  1. 请在登录官网获取AppKey, 填写在 ViewController.m的下面方法中\n  [[RCIMClient sharedRCIMClient] initWithAppKey:@""];\n  2. 请使用自定义 User1的ID 和 User2的ID, 生成对应 User1的Token 和 User1的Token, 填写在 ViewController.m中\n  3. 如果发起多人音视频通话必须填写正确的群组targetId, 否则无法正常发起呼叫\n  4. 使用demo中的podfile, 通过 pod install 获取最新版本的融云SDK\n  5. pod安装完成后, 请打开pod生成的 RongCallKitQuickStart.xcworkspace\n  6. 本demo使用Xcode11创建";
    [self.view addSubview:self.infoLabel];
}

#pragma mark - Action
- (void)callUser1ButtonAction {
    self.isContect1 = YES;
    [[RCIMClient sharedRCIMClient] connectWithToken:self.callUser1Token
                                           dbOpened:^(RCDBErrorCode code) {}
                                            success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = [NSString stringWithFormat:@"  Success CallUser1: %@", userId];
        });
    } error:^(RCConnectErrorCode errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = [NSString stringWithFormat:@"  Error status: %zd", errorCode];
        });
    }];
}

- (void)callUser2ButtonAction {
    self.isContect2 = YES;
    [[RCIMClient sharedRCIMClient] connectWithToken:self.callUser2Token
                                           dbOpened:^(RCDBErrorCode code) {}
                                            success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = [NSString stringWithFormat:@"Success CallUser2: %@", userId];
        });
    } error:^(RCConnectErrorCode errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = [NSString stringWithFormat:@"Error status: %zd", errorCode];
        });
    }];
}

- (void)callUser3ButtonAction {
    self.isContect3 = YES;
    [[RCIMClient sharedRCIMClient] connectWithToken:self.callUser3Token
                                           dbOpened:^(RCDBErrorCode code) {}
                                            success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = [NSString stringWithFormat:@"Success Join CallUser3: %@", userId];
        });
    } error:^(RCConnectErrorCode errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = [NSString stringWithFormat:@"Error status: %zd", errorCode];
        });
    }];
}

- (void)singleMultiSwitchAction {
    if (self.singleMultiSwitch.on) {
        self.singleMultiLabel.text = @"单人通话";
        self.singleMultiLabel.textColor = [UIColor orangeColor];
    }
    else {
        self.singleMultiLabel.text = @"多人通话";
        self.singleMultiLabel.textColor = [UIColor darkGrayColor];
    }
    
    self.isSingleCall = self.singleMultiSwitch.on;
}

- (void)audioVideoSwitchAction {
    if (self.audioVideoSwitch.on) {
        self.mediaType = RCCallMediaVideo;
        self.mediaLabel.text = @"视频通话";
        self.mediaLabel.textColor = [UIColor redColor];
    }
    else {
        self.mediaType = RCCallMediaAudio;
        self.mediaLabel.text = @"音频通话";
        self.mediaLabel.textColor = [UIColor blueColor];
    }
}

- (void)callButtonAction {
    if (self.isSingleCall) {
        NSString *calledUserId;
        if (self.isContect1) {
            calledUserId = self.callUser2Id;
        }
        else if (self.isContect2) {
            calledUserId = self.callUser1Id;
        }
        else if (self.isContect3) {
            NSAssert(NO, @"CallUser3仅用于群通话时, 主动加入通话使用, 请使用CallUser1或CallUser2发起呼叫");
        }
        
        [[RCCall sharedRCCall] startSingleCall:calledUserId
                                     mediaType:self.mediaType];
    }
    else {
        NSAssert(self.targetId.length > 0, @"群组的self.targetId不能为空, 请填写正确的群组ID, 否则无法正常发起呼叫");
        
        NSArray *userIdArray;
        if (self.isContect1) {
            userIdArray = @[self.callUser2Id, self.callUser3Id];
        }
        else if (self.isContect2) {
            userIdArray = @[self.callUser1Id, self.callUser3Id];
        }
        else if (self.isContect3) {
            NSAssert(NO, @"CallUser3仅用于群通话时, 主动加入通话使用, 请使用CallUser1或CallUser2发起呼叫");
        }
        
        [[RCCall sharedRCCall] startMultiCallViewController:ConversationType_GROUP
                                                   targetId:self.targetId
                                                  mediaType:self.mediaType
                                                 userIdList:userIdArray];
    }
}

- (void)joinCallButtonAction {
    NSArray *receiverList;
    if (self.isContect1) {
        receiverList = @[self.callUser2Id, self.callUser3Id];
    }
    else if (self.isContect2) {
        receiverList = @[self.callUser1Id, self.callUser3Id];
    }
    else if (self.isContect3) {
        receiverList = @[self.callUser1Id, self.callUser2Id];
    }
    
    [self sendRequestJoinSignal:self.targetId to:receiverList];
}

- (void)playButtonAction {
    if (!self.isPlaying) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videolow" ofType:@"mp4"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerLayer.frame = CGRectMake(0, self.joinCallButton.frame.origin.y + self.joinCallButton.frame.size.height + 20, kScreenWidth, 360);
        [self.view.layer addSublayer:self.playerLayer];
    }
    else {
        [self.player pause];
        [self.playerLayer removeFromSuperlayer];
    }
    
    self.isPlaying = !self.isPlaying;
}

- (void)callRecordsButtonAction {
    self.callRecordViewController = [[CallRecordViewController alloc] init];
    self.callRecordViewController.delegate = self;
    
    if (![self.navigationController.topViewController isKindOfClass:[CallRecordViewController class]]) {
        [self.navigationController pushViewController:self.callRecordViewController animated:YES];
    }
}

#pragma mark - Message
- (void)sendRequestJoinSignal:(NSString *)targetId to:(NSArray *)userIdList {
//    [RCCall sharedRCCall].acceptAuto = YES; //自动加入群通话时设置
    
    RCCallRequestJoinMessage *joinMessage = [[RCCallRequestJoinMessage alloc] initWithUserId:[self getLocalUserId]];
    RCMessage *message = [[RCMessage alloc] initWithType:ConversationType_GROUP
                                                targetId:targetId
                                               direction:MessageDirection_SEND
                                               messageId:0
                                                 content:joinMessage];
    
    [[RCCoreClient sharedCoreClient] sendDirectionalMessage:message
                                               toUserIdList:userIdList
                                                pushContent:nil
                                                   pushData:nil
                                               successBlock:^(RCMessage *successMessage) {}
                                                 errorBlock:^(RCErrorCode nErrorCode, RCMessage *errorMessage) {}];
}

#pragma mark - RCIMReceiveMessageDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isMemberOfClass:[RCCallRequestJoinMessage class]]) {
        RCCallRequestJoinMessage *requestJoinMessage = (RCCallRequestJoinMessage *)message.content;
        NSString *sendUserId = requestJoinMessage.userId;
        [[RCCall sharedRCCall] startMultiCallViewController:ConversationType_GROUP
                                                   targetId:self.targetId
                                                  mediaType:self.mediaType
                                                 userIdList:@[sendUserId]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"视频资源有误，加载失败");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"视频资源加载成功，准备好播放了");
                [self.player play];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                break;
            default:
                break;
        }
    }
}

- (NSString *)getRemoteUserId {
    if (self.isContect1) {
        return self.callUser2Id;
    }
    else if (self.isContect2) {
        return self.callUser1Id;
    }
    
    return @"";
}

#pragma mark - Private
- (NSString *)getLocalUserId {
    NSString *calledUserId;
    if (self.isContect1) {
        calledUserId = self.callUser1Id;
    }
    else if (self.isContect2) {
        calledUserId = self.callUser2Id;
    }
    else if (self.isContect3) {
        calledUserId = self.callUser3Id;
    }
    return calledUserId;
}

@end
