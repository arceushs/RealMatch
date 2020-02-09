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
    }
    return self;
}

- (void)restorePurchase{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
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

-(void)completeTransaction:(SKPaymentTransaction*)transaction isRestore:(BOOL)restore{
    //获取透传字段
    NSString *produ = transaction.payment.applicationUsername;
    //transactionIdentifier：相当于Apple的订单号
    NSString *transationId = transaction.transactionIdentifier;
    //从沙盒中获取交易凭证
    NSString *receiptStr = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL] usedEncoding:kCFStringEncodingUTF8 error:nil];
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    //转化成Base64字符串（用于校验）
    NSString *base64ReceiptString = [receiptData base64EncodedStringWithOptions:0];
 
    RMPurchaseCheckAPI * purchaseCheckAPI = [[RMPurchaseCheckAPI alloc] initWithReceiptData:base64ReceiptString transactionId:transaction.transactionIdentifier productId:transaction.payment.productIdentifier userId:[RMUserCenter shared].userId];
    if (restore) {
        [SVProgressHUD showWithStatus:@"restoring......"];
    }
    [[RMNetworkManager shareManager] request:purchaseCheckAPI completion:^(RMNetworkResponse *response) {
        if (restore) {
            [SVProgressHUD dismiss];
        }
        if (response.error){
            return;
        }
        RMPurchaseCheckAPIData *data = (RMPurchaseCheckAPIData *)response.responseObject;
        [RMUserCenter shared].userIsVip = data.recharged;
        if (data.recharged) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RMPurchaseSuccess" object:nil];
        }
    }];
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for(SKPaymentTransaction * tran in transactions){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                [SVProgressHUD showWithStatus:@"purchasing......"];
                break;
            case SKPaymentTransactionStatePurchased:
                [SVProgressHUD dismiss];
                [self completeTransaction:transactions.firstObject isRestore:NO];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
//                [SVProgressHUD showErrorWithStatus:transactions.firstObject.error.description];
                [SVProgressHUD dismissWithDelay:2];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateRestored:
                [self completeTransaction:transactions.firstObject isRestore:YES];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            default:
                break;
        }
    }
}


@end
