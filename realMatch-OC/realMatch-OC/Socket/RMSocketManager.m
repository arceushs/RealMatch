//
//  RMSocketManager.m
//  realMatch-OC
//
//  Created by arceushs on 2019/6/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMSocketManager.h"
#import "SocketRocket.h"
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
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"wss://www.4match.top/socket.io/?userId=733&EIO=3&transport=websocket"]]];
        _webSocket.delegate = self;
        NSLog(@"Opening Connection...");
        [_webSocket open];
        
//        NSURL* url = [[NSURL alloc] initWithString:@"https://www.4match.top/socket.io?userId=111"];
//
//        _manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"forceWebsockets": @YES,@"connectParams":@{@"userId":@(111)}}];
//
//        SocketIOClient* socket = _manager.defaultSocket;
//        
//        [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
//            NSLog(@"socket connected");
////            [socket emit:@"login" with:@[@{@"userId":@(111)}]];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [socket emit:@"message" with:@[@"xxxx"]];
//            });
//
//        }];
//
//
//        [socket on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
//            NSLog(@"response is %@",data);
//        }];
//
//        [socket connect];
    }
    return self;
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Websocket Connected");
    //      如果需要发送数据到服务器使用下面代码
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"id":@"chat",@"clientid":@"hxz",@"to":@""} options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    [webSocket send:jsonString];
    [webSocket send:@"dfasdfasdfasdfasdf"];
}

// 协议方法  接收消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"接收的消息:%@", message);
   
}

@end
