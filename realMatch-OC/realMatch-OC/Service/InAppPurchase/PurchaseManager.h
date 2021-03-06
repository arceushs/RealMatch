//
//  PurchaseManager.h
//  realMatch-OC
//
//  Created by yxl on 2019/5/27.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseManager : NSObject

@property (nonatomic,strong) NSArray* premiumArr;

@property (nonatomic,copy) NSString* enviroment;

+(instancetype) shareManager;

+(void) checkOrderStatus;

- (void)restorePurchase;

-(void)startPurchaseWithID:(NSString*)purchaseId;

@end

NS_ASSUME_NONNULL_END
