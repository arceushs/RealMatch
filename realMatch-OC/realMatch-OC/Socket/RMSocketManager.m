//
//  RMSocketManager.m
//  realMatch-OC
//
//  Created by arceushs on 2019/6/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMSocketManager.h"

@implementation RMSocketManager
{
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
        _webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:@"wss://www.4match.top/socket.io"]];
        _webSocket.delegate = self;
        [_webSocket open];

    }
    return self;
}



-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    [_webSocket send:@"xxxxx"];
}

-(void)dealloc{
    _webSocket.delegate = nil;
    [_webSocket close];
}

@end
