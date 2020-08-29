//
//  ConfigViewController.m
//  NetworkMonitorSample
//
//  Created by fengsl on 2020/8/25.
//  Copyright © Copyright © 2020 Ssky. All rights reserved.
//

#import "ConfigViewController.h"
#import "ViewController.h"
#import <HLLNetworkMonitor/HLLNetworkMonitor.h>

const NSString *rtpKey = @"NetworkMonitor_rtpKey";
const NSString *rspKey = @"NetworkMonitor_rspKey";
const NSString *urlKey = @"NetworkMonitor_urlKey";
const NSString *urlWlKey = @"NetworkMonitor_urlWlKey";
const NSString *cmdWlKey = @"NetworkMonitor_cmdWlKey";

@interface ConfigViewController ()<HLLPingDelegate>
@property (weak, nonatomic) IBOutlet UITextField *url;

@property (weak, nonatomic) IBOutlet UITextField *urlWhiteList;
@property (weak, nonatomic) IBOutlet UITextField *cmdWhiteList;
@property (weak, nonatomic) IBOutlet UITextField *requestPara;
@property (weak, nonatomic) IBOutlet UITextField *responsePara;
@property (weak, nonatomic) IBOutlet UISwitch *sdkSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *logSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (nonatomic, strong) HLLPingTester *pingTester;
@property (nonatomic, strong) HLLConfig *config;

@end

@implementation ConfigViewController

- (void)didPingSucccessWithHostName:(NSString *)hostName time:(float)time error:(NSError *)error;
{
    if (error)
    {
        NSLog(@"网络有问题");
    }
    else
    {
        NSLog(@"hostName：%@, %@", hostName, [[NSString stringWithFormat:@"%d", (int)time] stringByAppendingString:@"ms"]);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pingTester = [[HLLPingTester alloc] initWithHostName:@"www.baidu.com"];
     self.pingTester.delegate = self;
    //开了这个之后就是ping
//     [self.pingTester startPing];
    self.title = @"配置";
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [self.view addGestureRecognizer:recognizer];
    
    self.config = [[HLLConfig alloc] init];
    self.config.enableNetworkMonitor = YES;
    self.config.enableLog = NO;
    self.config.enableInterferenceMode = NO;
//    NSDictionary *rtp = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)rtpKey];
//    if (rtp) {
//        self.requestPara.text = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:rtp options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//    }
//    NSDictionary *rsp = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)rspKey];
//    if (rsp) {
//        self.responsePara.text = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:rsp options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//    }
//    NSArray *urlWl = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)urlWlKey];
//    if (urlWl) {
//        self.urlWhiteList.text = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:urlWl options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//    }
//    NSArray *cmdWl = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)cmdWlKey];
//    if (cmdWl) {
//        self.cmdWhiteList.text = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:cmdWl options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//    }
//    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)urlKey];
//    if (url) {
//        self.url.text = url;
//    }
}

- (IBAction)sdkSwitch:(id)sender {
    
}

- (IBAction)logSwitch:(id)sender {
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        self.config.enableLog = YES;
    } else {
        self.config.enableLog = NO;
    }
}

- (IBAction)modeSwitch:(id)sender {
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        self.config.enableInterferenceMode = YES;
    } else {
        self.config.enableInterferenceMode = NO;
    }
}

- (IBAction)startBtnClick:(id)sender {
    if (self.urlWhiteList.text) {
        self.config.urlWhiteList = [NSJSONSerialization JSONObjectWithData:[self.urlWhiteList.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:self.config.urlWhiteList forKey:(NSString *)urlWlKey];
    }
    
    if (self.cmdWhiteList.text) {
        self.config.cmdWhiteList = [NSJSONSerialization JSONObjectWithData:[self.cmdWhiteList.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:self.config.cmdWhiteList forKey:(NSString *)cmdWlKey];
    }
    
    if (self.requestPara.text) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[self.requestPara.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:(NSString *)rtpKey];
    }
    
    if (self.responsePara.text) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[self.responsePara.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:(NSString *)rspKey];
    }
    
    if (self.url.text) {
        [[NSUserDefaults standardUserDefaults] setObject:self.url.text forKey:(NSString *)urlKey];
    }
    

    
    
        [[HLLNetworkMonitorManager sharedNetworkMonitorManager] initConfig:self.config];
        //    NSArray *data = [[HLLNetworkMonitorManager sharedNetworkMonitorManager] getAllData];
        if (self.sdkSwitch.isOn) {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] start];
        } else {
            [[HLLNetworkMonitorManager sharedNetworkMonitorManager] stop];
        }
        __weak typeof(self) weakSelf = self;
       [HLLNetworkMonitorManager sharedNetworkMonitorManager].outputBlock = ^(NSString *traceId, NSDictionary *data) {
            [weakSelf alert:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]];
        };

    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alert:(NSString *)str {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"数据监控" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)viewClick {
    [self.urlWhiteList resignFirstResponder];
    [self.cmdWhiteList resignFirstResponder];
    [self.requestPara resignFirstResponder];
    [self.responsePara resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
