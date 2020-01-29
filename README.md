# RongCallKitQuickStart-ios

1. 请在登录官网获取AppKey, 填写在 ViewController.m的下面方法中
    [[RCIMClient sharedRCIMClient] initWithAppKey:@""]; //请在融云官网获取AppKey
    
2. 请使用自定义 User1的ID 和 User2的ID, 生成对应 User1的Token 和 User1的Token, 填写在 ViewController.m中

3. 如果发起群组呼叫, 请填写真实群组targetID, 并且保证上面两个User的ID为此群组内的用户

4. 使用demo中的podfile, 通过 pod install 获取最新版本的融云SDK

5. pod安装完成后, 请打开pod生成的 RongCallKitQuickStart.xcworkspace 

6. 本demo使用Xcode11创建

