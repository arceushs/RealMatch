//
//  Router+AccountKit.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "Router+AccountKit.h"

@implementation Router (AccountKit)

-(void)routeToAccountKitLoginVC:(UIViewController*)vc{
    [[self topMostController] presentViewController:vc animated:YES completion:nil];
}

@end
