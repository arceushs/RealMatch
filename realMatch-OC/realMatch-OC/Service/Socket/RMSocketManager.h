//
//  RMSocketManager.h
//  realMatch-OC
//
//  Created by arceushs on 2019/6/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
#import "realMatch_OC-Swift.h"
NS_ASSUME_NONNULL_BEGIN

@protocol RMSocketManagerDelegate <NSObject>

-(void)didReceiveMessage;

@end

@interface RMSocketManager : NSObject

@property (nonatomic,strong) NSMutableArray<id<RMSocketManagerDelegate>>* delegates;

+(instancetype)shared;
-(void)connectWithUserId:(NSString*)userId;
-(void)disconnect:(NSString*)userId;
-(void)messageSend:(RMMessageDetail*)message;

-(void)addDelegate:(id<RMSocketManagerDelegate>)delegate;
-(void)removeDelegate:(id<RMSocketManagerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
