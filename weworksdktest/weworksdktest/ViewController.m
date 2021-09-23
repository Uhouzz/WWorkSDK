//
//  ViewController.m
//  weworksdktest
//
//  Created by toraleap on 16/5/25.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "ViewController.h"
#import "WWKApi.h"

extern NSString *WWKAPP_SCHEME;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)sourceSelect:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择认证方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"腾讯企业号应用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WWKApi registerApp:@"wwauth700000a5f2191000014" corpId:@"ww700000a5f2191" agentId:@"1000014"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"第三方企业号应用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WWKApi registerApp:@"wwauth797275b8b439f4b5000002" corpId:@"ww797275b8b439f4b5" agentId:@"1000002"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"普通应用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WWKApi registerApp:@"wwk88f8f625770f7f32"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)schemeSelect:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择企业微信版本" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"通用版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WWKAPP_SCHEME = @"wxwork";
    }]];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wxworkdebug:"]]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"调试版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WWKAPP_SCHEME = @"wxworkdebug";
        }]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wxworkrdm:"]]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"RDM版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WWKAPP_SCHEME = @"wxworkrdm";
        }]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wxworkrelease:"]]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"发布版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WWKAPP_SCHEME = @"wxworkrelease";
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

/*! @brief 分享文字 */
- (IBAction)shareText:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageTextAttachment *attachment = [[WWKMessageTextAttachment alloc] init];
    attachment.text = @"惊天魔盗团2 / 三人行 / 独立日2 腾讯员工IMAX特惠票来袭，仅需40元不补差看巨幕3D影片，全城最低，等你来团";
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享文件 */
- (IBAction)shareFile:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageFileAttachment *attachment = [[WWKMessageFileAttachment alloc] init];
    attachment.filename = @"Download.pdf";
    attachment.path = [[NSBundle mainBundle] pathForResource:@"About Downloads" ofType:@"pdf"];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享图片 */
- (IBAction)shareImage:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageImageAttachment *attachment = [[WWKMessageImageAttachment alloc] init];
    attachment.filename = @"test.gif";
    attachment.path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享小视频 */
- (IBAction)shareVideo:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageVideoAttachment *attachment = [[WWKMessageVideoAttachment alloc] init];
    attachment.filename = @"video.mp4";
    attachment.path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享链接 */
- (IBAction)shareLink:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageLinkAttachment *attachment = [[WWKMessageLinkAttachment alloc] init];
    attachment.title = @"链接标题";
    attachment.summary = @"链接介绍";
    attachment.url = @"http://www.tencent.com";
    attachment.icon = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 转发 */
- (IBAction)shareForward:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageGroupAttachment *attachment = [[WWKMessageGroupAttachment alloc] init];
    attachment.title = @"XXX的聊天记录";
    NSMutableArray *array = [NSMutableArray array];

    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小明";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-1000];
        wrapper.avatarUrl = @"http://p.qlogo.cn/bizmail/BDHWBviaRjEgxSn7E5dBwXMM0bibQVVFXe6C6dhtAdsGMu7vL7AuNpIQ/100";
        wrapper.attachment = ({
            WWKMessageTextAttachment *text = [[WWKMessageTextAttachment alloc] init];
            text.text = @"关注你我健康";
            text;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小明";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-950];
        wrapper.avatarUrl = @"http://p.qlogo.cn/bizmail/BDHWBviaRjEgxSn7E5dBwXMM0bibQVVFXe6C6dhtAdsGMu7vL7AuNpIQ/100";
        wrapper.attachment = ({
            WWKMessageImageAttachment *image = [[WWKMessageImageAttachment alloc] init];
            image.filename = @"test.gif";
            image.path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];
            image;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小明";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-930];
        wrapper.avatarUrl = @"http://p.qlogo.cn/bizmail/BDHWBviaRjEgxSn7E5dBwXMM0bibQVVFXe6C6dhtAdsGMu7vL7AuNpIQ/100";
        wrapper.attachment = ({
            WWKMessageLocationAttachment *loc = [[WWKMessageLocationAttachment alloc] init];
            loc.title = @"T.I.T创意园";
            loc.address = @"广东省广州市海珠区新港中路397号";
            loc.lat = 23.098837;
            loc.lng = 113.325119;
            loc;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-900];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageTextAttachment *text = [[WWKMessageTextAttachment alloc] init];
            text.text = @"学车找我不愁";
            text;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-850];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageFileAttachment *file = [[WWKMessageFileAttachment alloc] init];
            file.filename = @"Download.pdf";
            file.path = [[NSBundle mainBundle] pathForResource:@"About Downloads" ofType:@"pdf"];
            file;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-850];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageVideoAttachment *video = [[WWKMessageVideoAttachment alloc] init];
            video.filename = @"video.mp4";
            video.path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
            video;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-800];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageLinkAttachment *link = [[WWKMessageLinkAttachment alloc] init];
            link.title = @"链接标题";
            link.summary = @"链接介绍";
            link.url = @"http://www.tencent.com";
            link.icon = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
            link;
        });
        wrapper;
    })];
    
    attachment.contents = array;
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 选择联系人 */
- (IBAction)pickContact:(id)sender {
    WWKPickContactReq *req = [[WWKPickContactReq alloc] init];
    req.type = @"mail";
    [WWKApi sendReq:req];
}

/*! @brief SSO */
- (IBAction)SSO:(id)sender {
    WWKSSOReq *req = [[WWKSSOReq alloc] init];
    req.state = @"adfasdfasdf23412341fqw4df14t134rtflajssf8934haioefy";
    [WWKApi sendReq:req];
}

@end
