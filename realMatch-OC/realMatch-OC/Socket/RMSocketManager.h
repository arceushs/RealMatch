//
//  RMSocketManager.h
//  realMatch-OC
//
//  Created by arceushs on 2019/6/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
NS_ASSUME_NONNULL_BEGIN

@interface RMSocketManager : NSObject<SRWebSocketDelegate>

+(instancetype)shared;
-(void)connectWithUserId:(NSString*)userId;
-(void)messageSend:(NSString*)message;

@end

NS_ASSUME_NONNULL_END
