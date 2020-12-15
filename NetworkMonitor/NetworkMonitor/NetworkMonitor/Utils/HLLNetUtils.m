//
//  HLLNetUtils.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLNetUtils.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HLLReachability.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import "arpa/inet.h"
#import "netdb.h"
#import "NSObject+HLLRuntime.h"

@implementation HLLNetUtils

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define HEAD_KEYS @"head_keys_"

typedef enum _CARRIER_AP_TYPE
{
    CARRIER_AP_TYPE_CMNET,        // cmnet
    CARRIER_AP_TYPE_UNINET,        // uninet
    CARRIER_AP_TYPE_CTNET,        // ctnet
    CARRIER_AP_TYPE_MAX
} CARRIER_AP_TYPE;

const NSString *const reCrasher_CarrierApTypeStr[] =
{
    @"cmnet",
    @"uninet",
    @"ctnet",
    @"wifi"
};

+ (NSString *)getTraceId {
    
    NSString *traceId;
    
    CFUUIDRef ptraceId = CFUUIDCreate( nil );
    
    CFStringRef traceIdString = CFUUIDCreateString( nil, ptraceId );
    
    traceId = [NSString stringWithFormat:@"%@", traceIdString];
    
    CFRelease(ptraceId);
    
    CFRelease(traceIdString);
    
    return traceId;
}

+ (BOOL)isHLLNetworkMonitorOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IS_HLLNetworkMonitor_ON];
}

+ (BOOL)isInterferenceMode {
    return [[HLLNetworkMonitorManager sharedNetworkMonitorManager] getConfig].enableInterferenceMode;
}

+ (NSString *)getNetWorkInfo {
    NSString *strNetworkInfo = @"none";
    struct sockaddr_storage zeroAddress;
    bzero(&zeroAddress,sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL,(struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability,&flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if(!didRetrieveFlags){
        return strNetworkInfo;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable)!=0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired)!=0);
    if(!isReachable || needsConnection) {
        return strNetworkInfo;
    }// 网络类型判断
    if((flags & kSCNetworkReachabilityFlagsConnectionRequired)== 0) {
        strNetworkInfo = @"wifi";
    }
    if(((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            strNetworkInfo = @"wifi";
        }
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) ==kSCNetworkReachabilityFlagsIsWWAN) {
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            if (currentRadioAccessTechnology) {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                    strNetworkInfo = @"4G";
                } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                    strNetworkInfo = @"2G";
                } else {
                    strNetworkInfo = @"3G";
                }
            }
        } else {
            if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable) {
                if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
                    if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired) {
                        strNetworkInfo = @"2G";
                    } else {
                        strNetworkInfo = @"3G";
                    }
                }
            }
        }
    }
    return strNetworkInfo;
}

+ (NSString *)getSignalStrength {
    UIApplication *app = [UIApplication sharedApplication];
    if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        return @"unknow";
    }
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    UIView *dataNetworkItemView = nil;
    
    for (UIView * subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    return [NSString stringWithFormat:@"signal %d", signalStrength];
}

+ (NSString *)getIPByDomain:(const NSString *)domain {
    Boolean result = NO;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSString *_ip = @"";
    const char *str =[domain UTF8String];
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, str, kCFStringEncodingASCII);
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    if(result) {
        struct sockaddr_in* remoteAddr;
        for(int i = 0; i < CFArrayGetCount(addresses); i++) {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            if(remoteAddr != NULL) {
                char ip[16];
                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                _ip = [NSString stringWithUTF8String:ip];
            }
        }
    } else {
        EELog(@"本地获取域名IP失败");
    }
    if (hostNameRef) {
        CFRelease(hostNameRef);
    }
    if (hostRef) {
        CFRelease(hostRef);
    }
    return _ip;
}

+ (BOOL)isDomain:(NSString *)domain {
    NSString *regex = @"^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:domain];
}

+ (NSDictionary *)extractParamsFromHeader:(NSDictionary *)headerField {
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *field in headerField.allKeys) {
        if ([field containsString:HEAD_KEYS]) {
            [header setObject:headerField[field] forKey:[field stringByReplacingOccurrencesOfString:HEAD_KEYS withString:@""]];
        }
    }
    return header;
}

+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSDictionary *attri = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
    return (NSNumber *)attri[NSFileSize];
}

+ (NSString *)getCurrentTime {
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
    return [NSString stringWithFormat:@"%.f", time * 1000];
}

+ (NSMutableURLRequest *)mutableRequest:(NSURLRequest *)request {
    if ([request isKindOfClass:[NSMutableURLRequest class]]) {
        return (NSMutableURLRequest *)request;
    } else {
        return [request mutableCopy];
    }
}

+ (NSString *)getDetailApCode {
    if ([[[self class] getNetWorkInfo] isEqualToString:@"wifi"]) {
        return @"wifi";
    }
    static NSString *apCode;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *carrierName = [[self class] getCarrierName];
        apCode = [[self class] getApTypeStrByCarrierName:carrierName];
    });
    return apCode;
}

+ (NSString *)getCarrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.carrierName;
}

+ (CARRIER_AP_TYPE)getApTypeByCarrierName:(NSString *)carrierName {
    if (!carrierName) {
        return CARRIER_AP_TYPE_MAX;
    }
    
    if ([carrierName isEqualToString:@"中国移动"]) {
        return CARRIER_AP_TYPE_CMNET;
    }
    else if([carrierName isEqualToString:@"中国联通"]) {
        return CARRIER_AP_TYPE_UNINET;
    }
    else if([carrierName isEqualToString:@"中国电信"]) {
        return CARRIER_AP_TYPE_CTNET;
    }
    else {
        return CARRIER_AP_TYPE_MAX;
    }
}

+ (NSString *)getApTypeStrByType:(CARRIER_AP_TYPE)type {
    return (NSString *)reCrasher_CarrierApTypeStr[(int)type];
}

+ (NSString *)getApTypeStrByCarrierName:(NSString *)carrierName {
    return [self getApTypeStrByType:[self getApTypeByCarrierName:carrierName]];
}

+ (BOOL)isAbove_iOS_10_0 {
    static BOOL isAboveiOS_10_0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isAboveiOS_10_0 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0");
    });
    return isAboveiOS_10_0;
}

+ (NSString *)mimeType:(NSString *)type {
    static NSDictionary *MIME_MapDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MIME_MapDic = @{
                        //{后缀名，MIME类型}
                        @"3gp":@"video/3gpp",
                        @"apk":@"application/vnd.android.package-archive",
                        @"asf":@"video/x-ms-asf",
                        @"avi":@"video/x-msvideo",
                        @"bin":@"application/octet-stream",
                        @"bmp":@"image/bmp",
                        @"c":@"text/plain",
                        @"class":@"application/octet-stream",
                        @"conf":@"text/plain",
                        @"cpp":@"text/plain",
                        @"doc":@"application/msword",
                        @"docx":@"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                        @"xls":@"application/vnd.ms-excel",
                        @"xlsx":@"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                        @"exe":@"application/octet-stream",
                        @"gif":@"image/gif",
                        @"gtar":@"application/x-gtar",
                        @"gz":@"application/x-gzip",
                        @"h":@"text/plain",
                        @"htm":@"text/html",
                        @"html":@"text/html",
                        @"jar":@"application/java-archive",
                        @"java":@"text/plain",
                        @"jpeg":@"image/jpeg",
                        @"jpg":@"image/jpeg",
                        @"js":@"application/x-javascript",
                        @"log":@"text/plain",
                        @"m3u":@"audio/x-mpegurl",
                        @"m4a":@"audio/mp4a-latm",
                        @"m4b":@"audio/mp4a-latm",
                        @"m4p":@"audio/mp4a-latm",
                        @"m4u":@"video/vnd.mpegurl",
                        @"m4v":@"video/x-m4v",
                        @"mov":@"video/quicktime",
                        @"mp2":@"audio/x-mpeg",
                        @"mp3":@"audio/x-mpeg",
                        @"mp4":@"video/mp4",
                        @"mpc":@"application/vnd.mpohun.certificate",
                        @"mpe":@"video/mpeg",
                        @"mpeg":@"video/mpeg",
                        @"mpg":@"video/mpeg",
                        @"mpg4":@"video/mp4",
                        @"mpga":@"audio/mpeg",
                        @"msg":@"application/vnd.ms-outlook",
                        @"ogg":@"audio/ogg",
                        @"pdf":@"application/pdf",
                        @"png":@"image/png",
                        @"pps":@"application/vnd.ms-powerpoint",
                        @"ppt":@"application/vnd.ms-powerpoint",
                        @"pptx":@"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                        @"prop":@"text/plain",
                        @"rc":@"text/plain",
                        @"rmvb":@"audio/x-pn-realaudio",
                        @"rtf":@"application/rtf",
                        @"sh":@"text/plain",
                        @"tar":@"application/x-tar",
                        @"tgz":@"application/x-compressed",
                        @"txt":@"text/plain",
                        @"wav":@"audio/x-wav",
                        @"wma":@"audio/x-ms-wma",
                        @"wmv":@"audio/x-ms-wmv",
                        @"wps":@"application/vnd.ms-works",
                        @"xml":@"text/plain",
                        @"z":@"application/x-compress",
                        @"zip":@"application/zip",
                        @"":@"*/*"
                        };
    });
    return MIME_MapDic[type];
}


///刘海屏safeAreaInset的高度(所有的刘海屏都一致)
static const CGFloat liuHaiHeight = 44;

#pragma mark 私有方法
+ (id)getStatusBar{
    id statusBar = nil;
    //    判断是否是iOS 13
    if (@available(iOS 13.0,*)) {
         UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                statusBar = [localStatusBar performSelector:@selector(statusBar)];
            }
        }
        
    }else{
        //非iOS13
         UIApplication *app = [UIApplication sharedApplication];
         statusBar = [app valueForKeyPath:@"statusBar"];
    }
    return statusBar;
}

//  _UIStatusBarDataCellularEntry
+ (id)getCellularEntryWithStatusBar:(id)statusBar{
    id cellularEntry = nil;
    if (statusBar) {
        NSArray *statusBarArray = [statusBar HLL_getPropertyNames];
        if ([statusBarArray containsObject:@"statusBar"]) {
            statusBar = [statusBar valueForKeyPath:@"statusBar"];
        }
        NSArray *currentDataArray = [statusBar HLL_getPropertyNames];
        if ([currentDataArray containsObject:@"currentData"]) {
             id currentData = [statusBar valueForKeyPath:@"currentData"];
            NSArray *cellularArray = [currentData HLL_getPropertyNames];
            if ([cellularArray containsObject:@"cellularEntry"]) {
                cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            }
        }
    }
    
    return cellularEntry;
}

+ (id)getSecondCellularEntryWithStatusBar:(id)statusBar{
    id secondaryCellularEntry = nil;
    if (statusBar) {
        if (statusBar) {
            NSArray *statusBarArray = [statusBar HLL_getPropertyNames];
            if ([statusBarArray containsObject:@"statusBar"]) {
                statusBar = [statusBar valueForKeyPath:@"statusBar"];
            }
            NSArray *currentDataArray = [statusBar HLL_getPropertyNames];
            if ([currentDataArray containsObject:@"currentData"]) {
                id currentData = [statusBar valueForKeyPath:@"currentData"];
                NSArray *cellularArray = [currentData HLL_getPropertyNames];
                if ([cellularArray containsObject:@"secondaryCellularEntry"]) {
                     secondaryCellularEntry = [currentData valueForKeyPath:@"secondaryCellularEntry"];
                }
            }
        }
        
    }
    return secondaryCellularEntry;
}

+ (id)getWifiEntryWithStatusBar:(id)statusBar{
    id wifiEntry = nil;
    if (statusBar) {
        NSArray *statusBarArray = [statusBar HLL_getPropertyNames];
        if ([statusBarArray containsObject:@"statusBar"]) {
            statusBar = [statusBar valueForKeyPath:@"statusBar"];
        }
        NSArray *currentDataArray = [statusBar HLL_getPropertyNames];
        if ([currentDataArray containsObject:@"currentData"]) {
             id currentData = [statusBar valueForKeyPath:@"currentData"];
             NSArray *cellularArray = [currentData HLL_getPropertyNames];
             if ([cellularArray containsObject:@"wifiEntry"]) {
                  wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                }
        }
       
       
    }
    return wifiEntry;
}

#pragma mark 判断是否是刘海屏
- (BOOL)isLiuHaiScreen
{
    if (@available(iOS 11.0, *)) {
    
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        
        return safeAreaInsets.top == liuHaiHeight || safeAreaInsets.bottom == liuHaiHeight || safeAreaInsets.left == liuHaiHeight || safeAreaInsets.right == liuHaiHeight;
    }else {
        return NO;
    }
}

+ (BOOL)isLiuHai{
    return [[[self alloc]init] isLiuHaiScreen];
}

+ (UIView *)getforegroundViewWithStatusBar:(id)statusBar{
    UIView *foregroundView = nil;
    if ([self isLiuHai]) {
          id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
    }else{
        foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
    }
    
    
    return foregroundView;
}


/**
 twoCard:是否两张卡
 isCardOne:是否使用卡1
 */
+ (NSString *)getNetworkStrWithType:(NSInteger)type twoCard:(BOOL)twoCard isCardOne:(BOOL)isCardOne{
    NSString *network = @"WWAN";
    if (!twoCard) {
            if (type) {
                switch (type) {
                    case 0:
                        //无sim卡
                        network = @"NONE";
                        break;
                    case 1:
                        network = @"1G";
                        break;
                    case 4:
                        network = @"3G";
                        break;
                    case 5:
                        network = @"4G";
                        break;
                    default:
                        //默认WWAN类型
                        network = @"WWAN";
                        break;
                
                    }
            }
    }else{
        switch (type) {
        case 0://无服务
            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
            break;
        case 3:
            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
            break;
        case 4:
            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
            break;
        case 5:
            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
            break;
        default:
            break;
        }
    }
    return network;
}

+ (NSString *)getNetWorkWhereOSGN13WithStatusBar:(id)statusBar{
    NSString *network = @"NoneWhereOSGN13";
    if (statusBar) {
       id _cellularEntry = [self getCellularEntryWithStatusBar:statusBar];
          
          id _wifiEntry = [self getWifiEntryWithStatusBar:statusBar];
          //如果wifi enable，网络类型是wifi
          if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
              network = @"WIFI";
          } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
//              NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
//              network = [self getNetworkStrWithType:type.integerValue twoCard:NO isCardOne:NO];
              network = [self getNetworkTypeByReachability];
          }
        
    }
   
    return network;
}

+ (NSString *)getNetWorkWhereOSLN13WithStatusBar:(id)statusBar{
     NSString *network = @"NoneWhereOSLN13";
    
    UIView *foregroundView = [self getforegroundViewWithStatusBar:statusBar];
    if ([self isLiuHai]) {
        //刘海屏
        NSArray *subviews = [[foregroundView subviews][2] subviews];
            
        if (subviews.count == 0) {
            //iOS 12
            id wifiEntry = [self getWifiEntryWithStatusBar:statusBar];
            if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
                network = @"WIFI";
            }else {
                //卡1:
                id cellularEntry = [self getCellularEntryWithStatusBar:statusBar];
                //卡2:
                id secondaryCellularEntry = [self getSecondCellularEntryWithStatusBar:statusBar];

                if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
                    //无卡情况
                    network = @"NONE";
                }else {
                    //判断卡1还是卡2
                    BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
//                    int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
//                    network = [self getNetworkStrWithType:networkType twoCard:YES isCardOne:isCardOne];
                      network = [self getNetworkTypeByReachability];
                        
                    }
                }
            
            }else {
                
                for (id subview in subviews) {
                    if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                        network = @"WIFI";
                    }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                        network = [subview valueForKeyPath:@"originalText"];
                    }
                }
            }
            
        }else {
            //非刘海屏
            NSArray *subviews = [foregroundView subviews];
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//                    int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
//                    network = [self getNetworkStrWithType:networkType twoCard:NO isCardOne:NO];
                      network = [self getNetworkTypeByReachability];
                }
            }
        }
    return network;
}

#pragma mark 获取当前网络类型
+ (NSString *)getNetworkType
{
   
    id statusBar = [self getStatusBar];;

    NSString *network = @"";
    if (@available(iOS 13.0, *)) {
        
        network = [self getNetWorkWhereOSGN13WithStatusBar:statusBar];
    }else {
       
        network = [self getNetWorkWhereOSLN13WithStatusBar:statusBar];
    }

    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

#pragma mark 获取当前网络类型(通过Reachability)
+ (NSString *)getNetworkTypeByReachability
{
    NSString *network = @"";
    switch ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]) {
        case NotReachable:
            network = @"NONE";
            break;
        case ReachableViaWiFi:
            network = @"WIFI";
            break;
        case ReachableViaWWAN:
            network = @"WWAN";
            break;
        default:
            break;
    }
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

#pragma mark 获取Wifi信息
+ (id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

#pragma mark 获取WIFI名字
+ (NSString *)getWifiSSID
{
    return (NSString *)[self fetchSSIDInfo][@"SSID"];
}

#pragma mark 获取WIFI的MAC地址
+ (NSString *)getWifiBSSID
{
    return (NSString *)[self fetchSSIDInfo][@"BSSID"];
}

#pragma mark 获取Wifi信号强度
+ (NSString *)getNetworkSignal
{
    
    NSString *signalStrength = @"10086";
//    判断类型是否为WIFI
    if ([[self getNetworkType]isEqualToString:@"WIFI"]) {
       signalStrength = [self getWifiSignal];
    }else{
        signalStrength = [self getWLANSignal];
    }
    return signalStrength;
}
//层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
+ (NSString *)getWiFiSignalWhereOSGN13ORIphoneXWithStatusBar:(id)statusBar{
    NSString *signalStrength = @"10086";
    if (statusBar) {
       
        id wifiEntry = [self getWifiEntryWithStatusBar:statusBar];
        if ([wifiEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
            signalStrength = [[wifiEntry valueForKey:@"displayValue"] stringValue];
        }
    }
    
    return signalStrength;
}

+ (NSString *)getWiFiSignalWhereOSLN13WithStatusBar:(id)statusBar{
    NSString *signalStrength = @"10086";
    UIView *foregroundView = [self getforegroundViewWithStatusBar:statusBar];
    if ([self isLiuHai]) {
        NSArray *subviews = [[foregroundView subviews][2] subviews];
        if (subviews.count == 0) {
            signalStrength = [self getWiFiSignalWhereOSGN13ORIphoneXWithStatusBar:statusBar];
            
        }else{
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                    signalStrength = [[subview valueForKey:@"_numberOfActiveBars"] stringValue];
                    break;
                          
                      }
                  }
              }
              
          }else{
              NSArray *subviews = [foregroundView subviews];
              NSString *dataNetworkItemView = nil;
              for (id subview in subviews) {
                  if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                      dataNetworkItemView = subview;
                      break;
                  }
              }
                                        
              signalStrength = [dataNetworkItemView valueForKey:@"_wifiStrengthBars"];
          }
    
    return signalStrength;
}


+ (NSString *)getWifiSignal{
    NSString *signalStrength = @"10086";
    id statusBar = [self getStatusBar];
    
    if (@available(iOS 13.0, *)) {
        signalStrength = [self getWiFiSignalWhereOSGN13ORIphoneXWithStatusBar:statusBar];
    }else{
        signalStrength = [self getWiFiSignalWhereOSLN13WithStatusBar:statusBar];
    }

    
     return signalStrength;

}

+ (NSString *)getWLANSignalWhereOSGN13ORIphoneXWithStatusBar:(id)statusBar{
    NSString *signalStrength = @"10086";
    id cellularEntry = [self getCellularEntryWithStatusBar:statusBar];
    
    signalStrength = [cellularEntry valueForKey:@"displayValue"];

    
    return signalStrength;
}

+ (NSString *)getWLANSignalWhereOSLN13WithStatusBar:(id)stautsBar{
    NSString *signalStrength = @"10086";
    if (stautsBar) {
            NSString *dataNetworkItemView = nil;
            NSArray *subviews = [[stautsBar valueForKey:@"foregroundView"] subviews];
            for (id subview in subviews) {
                if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]] && [[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
                    dataNetworkItemView = subview;
                    signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] stringValue];
                        break;
                    }
                if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]] && ![[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
                    dataNetworkItemView = subview;
                    //signalStrength = [[dataNetworkItemView valueForKey:@"_signalStrengthRaw"] intValue];
                    signalStrength = [[dataNetworkItemView valueForKey:@"_signalStrengthBars"] stringValue];
                    break;
                    }
            
        }
    }
    return signalStrength;
}

#pragma mark 获取有线流量
+ (NSString *)getWLANSignal{
    id statusBar = [self getStatusBar];
    NSString *signalStrength = @"10086";
    if (@available(iOS 13.0,*)) {
       
        signalStrength = [self getWLANSignalWhereOSGN13ORIphoneXWithStatusBar:statusBar];
    }else{
        if ([self isLiuHai]) {
             signalStrength = [self getWLANSignalWhereOSGN13ORIphoneXWithStatusBar:statusBar];
        }else{
            signalStrength = [self getWLANSignalWhereOSLN13WithStatusBar:statusBar];
           
            
        }
    }
    return signalStrength;
}

#pragma mark 获取设备IP地址
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
//                开热点时本机的IP地址
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"bridge100"]
                    ) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}


+ (NSString *)getOperator{
    //获取本机运营商名称

    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];

    CTCarrier *carrier = [info subscriberCellularProvider];

    //当前手机所属运营商名称

    NSString *mobile;

    //先判断有没有SIM卡，如果没有则不获取本机运营商

    if (!carrier.isoCountryCode) {

    NSLog(@"没有SIM卡");

    mobile = @"无运营商";

    }else{

    mobile = [carrier carrierName];

    }
    return mobile;
}


+ (NSString *)getDBMWhereOSGN13WithStatusBar:(id)statusBar{
    NSString *signalStrength = @"NO DBM Where OSGN13";
    id wifiEntry = [self getWifiEntryWithStatusBar:statusBar];
    id cellularEntry = [self getCellularEntryWithStatusBar:statusBar];
    if (wifiEntry && [[wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
        signalStrength = [NSString stringWithFormat:@"%@dBm",[wifiEntry valueForKey:@"rawValue"]];
    } else if (cellularEntry && [[cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
         signalStrength = [NSString stringWithFormat:@"%@dBm",[cellularEntry valueForKey:@"rawValue"]];
    }
    
   
    return signalStrength;
}

+ (NSString *)getDBMWhereOSLN13WithStatusBar:(id)statusBar{
    NSString *signalStrength = @"NO DBM Where OSLN13";
    UIView *foregroundView = [self getforegroundViewWithStatusBar:statusBar];
    if ([self isLiuHai]) {
      
            id wifiEntry = [self getWifiEntryWithStatusBar:statusBar];
            id cellularEntry = [self getCellularEntryWithStatusBar:statusBar];
            if (wifiEntry && [[wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                signalStrength = [NSString stringWithFormat:@"%@dBm",[wifiEntry valueForKey:@"rawValue"]];
            } else if (cellularEntry && [[cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                signalStrength = [NSString stringWithFormat:@"%@dBm",[cellularEntry valueForKey:@"rawValue"]];
            }
    }else{
         NSString *dataNetworkItemView = nil;
        for (id subview in foregroundView.subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]] && [[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
                dataNetworkItemView = subview;
                signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_wifiStrengthRaw"]];
                break;
            }
            if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]] && ![[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
                dataNetworkItemView = subview;
                signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_signalStrengthRaw"]];
                break;
            }
        }
    }
    return signalStrength;
}

/*
 https://www.netspotapp.com/cn/wifi-signal-strength-and-its-impact.html
dbm是无线信号的强度单位。
信号强度
 -30dBm 极好 这是可实现的最大信号强度，适用于任何一种使用情景
 -50dBm 极好 此极好的信号强度适于各种网络使用情形
 -65dBm 非常好 建议为智能手机和平板电脑提供支持
 -67dBm 非常好 此信号强度对于网络电话和流媒体视频的使用是足够的
 -70 dBm 可接受 该等级是确保实现稳定的数据包传输的最低信号强度要求，对于网页冲浪和收发邮件的使用是足够的
 -80 dBm 不良 实现基本连接，但数据包传输不稳定
 -90 dBm 非常差 大多都是噪音，抑制大多数功能的实现
 - 100 dBm 最差  全是噪音
 */
+ (NSString *)getDBMSignalStrength {
    if (![self whetherConnectedNetwork]) return @"NO DBM";
    id statusBar = [self getStatusBar];
    NSString *signalStrength = @"";
    if (@available(iOS 13.0, *)) {
        signalStrength = [self getDBMWhereOSGN13WithStatusBar:statusBar];
    }else{
        signalStrength = [self getDBMWhereOSLN13WithStatusBar:statusBar];
    }
    return signalStrength;
}

+ (BOOL)whetherConnectedNetwork
{
//创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
struct sockaddr_storage zeroAddress;//IP地址
bzero(&zeroAddress, sizeof(zeroAddress));//将地址转换为0.0.0.0
zeroAddress.ss_len = sizeof(zeroAddress);//地址长度
zeroAddress.ss_family = AF_INET;//地址类型为UDP, TCP, etc.
// Recover reachability flags
SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
SCNetworkReachabilityFlags flags;
//获得连接的标志
BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
CFRelease(defaultRouteReachability);
//如果不能获取连接标志，则不能连接网络，直接返回
if (!didRetrieveFlags)
{
return NO;
}
//根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}


+ (NSString *)getPhoneNetMode{
    NSString *state = @"不是air Plane";
    id statusBar = [self getStatusBar];
    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
     NSArray *children = [[self getforegroundViewWithStatusBar:statusBar] subviews];
        for (UIView *view in children) {
            for (id child in view.subviews) {
                if ([child isKindOfClass:NSClassFromString(@"_UIStatusBarImageView")]) {
                    state = @"airPlane";
                }
            }
        }
    } else { //其他机型
         NSArray *children= [[self getforegroundViewWithStatusBar:statusBar] subviews];
        for (id child in children) {
            if ([child isKindOfClass:NSClassFromString(@"UIStatusBarAirplaneModeItemView")]) {
                state = @"airPlane";
            }
        }
    }
    return state;
}
#pragma clang diagnostic pop

@end
