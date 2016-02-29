//
//  NLHttpRequest.h
//  NetworkingLib
//
//  Created by YNKJMACMINI2 on 15/12/28.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "NLHttpRequestProtocol.h"

@interface NLHttpRequest : NSObject
-(void)doRequestWithParameters:(NSDictionary*)parameters andBlock:(void(^)(id responseObject,NSError *error))block;
-(void)cancel;
@end
