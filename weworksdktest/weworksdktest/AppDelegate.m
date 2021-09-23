//
//  AppDelegate.m
//  weworksdktest
//
//  Created by toraleap on 16/5/25.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "AppDelegate.h"
//头文件不要忘
#import <objc/runtime.h>

#import "WWKApi.h"

@interface AppDelegate () <WWKApiDelegate>

@end

@implementation AppDelegate
//对UIApplication的openURL:方法进行hook
-(void)swizzleOpenUrl{
    SEL openUrlSEL=@selector(openURL:);
    BOOL (*openUrlIMP)(id,SEL,id) =(BOOL(*)(id,SEL,id))[UIApplication instanceMethodForSelector:openUrlSEL];
    static int count=0;
    BOOL (^myOpenURL)(id SELF,NSURL * url)=^(id SELF,NSURL *url){
        
        //打印出分享的URL
        NSLog(@"\n----------open url: %d----------\n%@\n%@\n",count++,url,@"\n"/*[NSThread callStackSymbols]*/);
        
        //获取系统剪切板
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        //打印获取QQ在剪切板的key 得知key为 com.tencent.mqq.api.apiLargeData
        NSLog(@"%@",pasteboard.pasteboardTypes);
        
        //获取QQ在剪切板参数 图片与链接分享时才有值
        NSData * qzoneInfoData = [pasteboard valueForPasteboardType:@"wxworksdk"];
        //QQ是使用NSKeyedArchiver序列化数据的
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:qzoneInfoData options:NSJSONReadingMutableLeaves error:nil];
        
        //微信是使用NSPropertyListSerialization做序列化的，这与QQ是不同的
        NSDictionary * wechatInfo = [NSPropertyListSerialization propertyListWithData:qzoneInfoData options:0 format:NULL error:nil];
        NSLog(@"%@",wechatInfo);
        /**
         bid = "com.yxhj.uhouzz";
         cls = WWKSendMessageReq;
         name = "";
         seq = 2;
         "sm.att.icon" = <fff>,
         "sm.att.summary" = "\U94fe\U63a5\U4ecb\U7ecd";
         "sm.att.title" = "\U94fe\U63a5\U6807\U9898";
         "sm.att.type" = link;
         "sm.att.url" = "http://www.tencent.com";
         
         
         //图片
         bid = "com.yxhj.uhouzz";
         cls = WWKSendMessageReq;
         name = "";
         seq = 1;
         "sm.att.filename" = "test.gif";
         "sm.att.type" = image;
         */
        
       NSString *sssss = [[NSString alloc] initWithData:qzoneInfoData encoding:NSUTF8StringEncoding];
        //图片分享是会有image_data_list
        //qzoneInfoDic:
        //{
        //    "image_data_list" = NSData数据
        //}
        
        //链接分享只有previewimagedata
        //qzoneInfoDic:
        //{
        //    "previewimagedata" = NSData数据
        //}

//        NSDictionary * qzoneInfoDic = [NSKeyedUnarchiver unarchiveObjectWithData:qzoneInfoData];
//
//        //图片
//        NSData * image_data_list_data = qzoneInfoDic[@"image_data_list"];
//        NSArray * image_data_list = [NSKeyedUnarchiver unarchiveObjectWithData:image_data_list_data];
//        NSMutableArray * images = [NSMutableArray array];
//        for (NSData * imgData in image_data_list) {
//            UIImage * image = [UIImage imageWithData:imgData];
//            [images addObject:image];
//        }
//
//        //缩略图 小于32k
//        NSData * previewimagedata = qzoneInfoDic[@"previewimagedata"];
//        UIImage * previewimage = [UIImage imageWithData:previewimagedata];
        
        return (BOOL)openUrlIMP(SELF,openUrlSEL,url);
    };
    class_replaceMethod([UIApplication class], openUrlSEL, imp_implementationWithBlock(myOpenURL), NULL);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self swizzleOpenUrl];
    /*! @brief 不走管理端的注册方式
     *
     * 或许不久的将来我们会开放支持仅仅通过第三方App的schema作为AppId来进行注册，继而调用SDK对应的接口进行工作
     * 这个接口虽然现在开放了，但暂时还没有开放权限，敬请期待...
     * @param registerApp 第三方App的Schema
     */
    // [WWKApi registerApp:@"wwauth797275b8b439f4b5000002"];
    
    
    /*! @brief 调用这个方法前需要先到管理端进行注册 走管理端的注册方式
     *
     * 在管理端通过注册(可能需要等待审批)，获得schema+corpid+agentid
     * @param registerApp 第三方App的Schema
     * @param registerApp 第三方App所属企业的ID
     * @param registerApp 第三方App在企业内部的ID
     */
    [WWKApi registerApp:@"wwauth365a204c85987172000113" corpId:@"ww365a204c85987172" agentId:@"1000113"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self handleOpenURL:url sourceApplication:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    return [self handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    /*! @brief 处理外部调用URL的时候需要将URL传给SDK进行相关处理
     * @param url 外部调用传入的url
     * @param delegate 当前类需要实现WWKApiDelegate对应的方法
     */
    return YES;//[WWKApi handleOpenURL:url delegate:self];
}

//- (void)onResp:(WWKBaseResp *)resp {
//    /*! @brief 所有通过sendReq发送的SDK请求的结果都在这个函数内部进行异步回调
//     * @param resp SDK处理请求后的返回结果 需要判断具体是哪项业务的回调
//     */
//    NSMutableString *extra = [NSMutableString string];
//    
//    /* 选择联系人的回调 */
//    if ([resp isKindOfClass:[WWKPickContactResp class]]) {
//        WWKPickContactResp *r = (WWKPickContactResp *)resp;
//        for (int i = 0; i < MIN(r.contacts.count, 5); ++i) {
//            if (extra.length) [extra appendString:@"\n"];
//            [extra appendFormat:@"%@<%@>", [r.contacts[i] name], [r.contacts[i] email]];
//        }
//        if (r.contacts.count > 5) {
//            [extra appendString:@"\n…"];
//        }
//    }
//    
//    /* SSO的回调 */
//    if ([resp isKindOfClass:[WWKSSOResp class]]) {
//        WWKSSOResp *r = (WWKSSOResp *)resp;
//        [extra appendFormat:@"%@ for %@", r.code, r.state];
//    }
//    
//    if (extra.length) [extra insertString:@"\n\n" atIndex:0];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"返回结果" message:[NSString stringWithFormat:@"错误码：%d\n错误信息：%@%@", resp.errCode, resp.errStr, extra] preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
//}

@end
