//
//  AHTimer.m
//  TimerTest
//
//  Created by yxl on 2019/6/6.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "AHTimer.h"

@interface TimerTargetProxy : NSProxy

@property (weak,nonatomic) id target;

@end

@implementation TimerTargetProxy

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

@end


@implementation AHTimer
{
    NSTimer* _timer;
}
+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats{
    TimerTargetProxy * targetProxy = [TimerTargetProxy alloc];
    targetProxy.target = target;
    AHTimer* thisTimer = [[AHTimer alloc]init];
    thisTimer->_timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:targetProxy selector:selector userInfo:userInfo repeats:repeats];
    return thisTimer;
}

+(instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats{
    AHTimer* thisTimer = [[AHTimer alloc]init];
    thisTimer->_timer = [NSTimer timerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats];
    
    return thisTimer;
}

-(void)fire{
    [self->_timer fire];
}

-(void)invalidate{
    [self->_timer invalidate];
    self->_timer = nil;
}


@end
