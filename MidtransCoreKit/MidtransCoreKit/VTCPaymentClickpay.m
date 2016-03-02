//
//  VTCPaymentClickpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/29/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCPaymentClickpay.h"
#import "VTNetworking.h"
#import "VTConfig.h"

@interface VTCPaymentClickpay()
@property (nonatomic, readwrite) VTMandiriClickpay *clickpay;
@end

@implementation VTCPaymentClickpay

+ (instancetype)paymentWithUser:(VTUser *)user andAmount:(NSNumber *)amount clickpay:(VTMandiriClickpay *)clickpay {
    VTCPaymentClickpay *payment = [[VTCPaymentClickpay alloc] initWithUser:user amount:amount];
    payment.clickpay = clickpay;
    return payment;
}

- (void)payWithCallback:(void(^)(id response, NSError *error))callback {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], @"charge"];
    NSDictionary *param = @{@"payment_type":@"mandiri_clickpay",
                            @"mandiri_clickpay":[_clickpay requestData],
                            @"transaction_details":[self transactionDetail],
                            @"customer_details":[self.user customerDetails]
                            };
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:param callback:^(id response, NSError *error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            
        }
    }];
}

- (void)pay {
    NSString *URL = [NSString stringWithFormat:@"%@/%@", [[VTConfig sharedInstance] baseUrl], @"charge"];
    NSDictionary *param = @{@"payment_type":@"mandiri_clickpay",
                            @"mandiri_clickpay":[_clickpay requestData],
                            @"transaction_details":[self transactionDetail],
                            @"customer_details":[self.user customerDetails]
                            };
    
    [[VTNetworking sharedInstance] getFromURL:URL parameters:param callback:^(id response, NSError *error) {
        if (error) {
            if (self.delegate) {
                [self.delegate paymentFailed];
            }
        } else {
            if (self.delegate) {
                [self.delegate paymentSuccessfullyCompleted];
            }
        }
    }];
}

@end
