# RongCallKitQuickStart-ios

1. 请登录官网获取 `AppKey` , 填写在 `ViewController.m` 的下面方法中
    
    ```objective-c
    [[RCIMClient sharedRCIMClient] initWithAppKey:@""]; //请在融云官网获取AppKey
    ```
    
    
    
2. 请使用自定义 User1 的ID 和 User2 的ID, 生成对应 User1 的 Token 和 User1 的 Token, 填写在 `ViewController.m` 中

3. 如果发起群组呼叫, 请填写真实群组 `targetID`, 并且保证上面两个 User 的 ID 为此群组内的用户

4. 在 `pod install` 之前, 请使用 `pod repo update` 更新本地库

5. 使用 demo 中的 podfile, 通过 `pod install` 获取最新版本的融云SDK

6. pod 安装完成后, 请打开 pod 生成的 `RongCallKitQuickStart.xcworkspace`

7. 本 demo 使用 Xcode11 创建

