//
//  RMSocketManager.m
//  realMatch-OC
//
//  Created by arceushs on 2019/6/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMSocketManager.h"
#import "SocketRocket.h"
#import "SVProgressHUD.h"
@import SocketIO;

@implementation RMSocketManager
{
    SocketManager* _manager;
    SRWebSocket* _webSocket;
}
+(instancetype)shared{
    static RMSocketManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RMSocketManager alloc]init];
    });
    return manager;
}

-(instancetype)init{
    if(self = [super init]){
    
    }
    return self;
}

-(void)connectWithUserId:(NSString*)userId{
    NSURL* url = [[NSURL alloc] initWithString:@"https://www.4match.top/socket.io?userId=111"];
    
    _manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"forceWebsockets": @YES,@"connectParams":@{@"userId":userId}}];
    
    SocketIOClient* socket = _manager.defaultSocket;
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        //            [socket emit:@"login" with:@[@{@"userId":@(111)}]];
       
        
    }];
    
    
    [socket on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"response is %@",data);
        [SVProgressHUD showWithStatus:data[0][@"msg"]];
        [SVProgressHUD dismissWithDelay:1];
    }];
    
    [socket connect];
}

-(void)messageSend:(NSString*)message{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary* dict = @{@"fromUser":@(4029),
                               @"toUser":@(4031),
                               @"msg":message,
                               @"msg_type":@"text",
                               };
         [_manager.defaultSocket emit:@"message" with:@[dict]];
        [self messageSend:message];
    });
   
}

//- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
//    NSLog(@"Websocket Connected");
//    //      如果需要发送数据到服务器使用下面代码
////    NSError *error;
////    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"id":@"chat",@"clientid":@"hxz",@"to":@""} options:NSJSONWritingPrettyPrinted error:&error];
////    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
////    [webSocket send:jsonString];
//    [webSocket send:@"dfasdfasdfasdfasdf"];
//}
//
//// 协议方法  接收消息
//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
//    NSLog(@"接收的消息:%@", message);
//
//}

@end
