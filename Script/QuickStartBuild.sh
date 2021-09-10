
Version="4"

if [ ${Version} = "4" ]; then
    echo "*** RTC 4.0 started ****"

    #IMlib
    rm -rf ${PROJECT_DIR}/Pods/RongCloudIM/RongCloudIM/RongIMLib.framework
    cp -af ~/Documents/ios-sealdev/ios-imsdk/imlib/bin/RongIMLib.framework ${PROJECT_DIR}/Pods/RongCloudIM/RongCloudIM/


    #RTCLib
    rm -rf ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongRTCLib.framework
    cp -af ~/Documents/ios-sealdev/ios-rtcsdk/RongRTCLib/bin/RongRTCLib.framework ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/


    #CallLib
    rm -rf ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongCallLib.framework
    cp -af ~/Documents/ios-sealdev/ios-rtcsdk/RongCallLib/bin/RongCallLib.framework ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/


    #CallKit
    rm -rf ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongCallKit.framework
    cp -af ~/Documents/ios-sealdev/ios-rtcsdk/RongCallKit/bin/RongCallKit.framework ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/
    
    echo "*** RTC 4.0 ended ****"
###-----------------------------------------------------------------------------------------###

elif [ ${Version} = "5" ];then
        
    echo "*** RTC 5.0 started ****"

    #RTCLib
    rm -rf ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongRTCLib.xcframework/ios-arm64_armv7/RongRTCLib.framework
    cp -af ~/Documents/ios-sealdev/ios-rtcsdk/RongRTCLib/bin/RongRTCLib.framework ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongRTCLib.xcframework/ios-arm64_armv7/


    #CallLib
    rm -rf ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongCallLib.xcframework/ios-arm64_armv7/RongCallLib.framework
    cp -af ~/Documents/ios-sealdev/ios-rtcsdk/RongCallLib/bin/RongCallLib.framework ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongCallLib.xcframework/ios-arm64_armv7/


    #CallKit
    rm -rf ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongCallKit.xcframework/ios-arm64_armv7/RongCallKit.framework
    cp -af ~/Documents/ios-sealdev/ios-rtcsdk/RongCallKit/bin/RongCallKit.framework ${PROJECT_DIR}/Pods/RongCloudRTC/RongCloudRTC/RongCallKit.xcframework/ios-arm64_armv7/

    echo "*** RTC 5.0 ended ****"
fi
