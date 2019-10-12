//
//  PurchaseManager.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/27.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "PurchaseManager.h"
#import <StoreKit/StoreKit.h>
#import "SVProgressHUD.h"
#import "realMatch_OC-Swift.h"

@interface PurchaseManager()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,copy) NSString* purchaseId;

@end

@implementation PurchaseManager

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    static PurchaseManager * manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[PurchaseManager alloc]init];
    });
    return manager;
}

-(instancetype)init{
    if(self = [super init]){
        _premiumArr = @[@"12_month_premium",@"6_month_premium",@"1_month_premium"];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
    return self;
}

-(void)startPurchaseWithID:(NSString*)purchaseId{
    if(purchaseId){
        if([SKPaymentQueue canMakePayments]){
            self.purchaseId = purchaseId;
            NSSet * nsset = [NSSet setWithArray:@[purchaseId]];
            SKProductsRequest * request = [[SKProductsRequest alloc]initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [SVProgressHUD showInfoWithStatus:@"您的设备不支持应用内购"];
        }
    }
}

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    NSArray* product = response.products;
    if([product count]<= 0){
        return;
    }
    
    SKProduct *p = nil;
    
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:self.purchaseId]){
            p = pro;
            break;
        }
    }
    
    SKPayment* payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)completeTransaction:(SKPaymentTransaction*)transaction{
    NSString* productIdentifier = transaction.payment.productIdentifier;
    NSString* receipt = [transaction.transactionReceipt base64Encoding];

}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for(SKPaymentTransaction * tran in transactions){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transactions.firstObject];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    [RMUserCenter shared].userIsVip = NO;
    for(SKPaymentTransaction * tran in queue.transactions){
        if([self.premiumArr containsObject:tran.payment.productIdentifier]){
            [RMUserCenter shared].userIsVip = YES;
        }
    }
}


@end
