//
//  NLHttpRequestProtocol.h
//  NetworkingLib
//
//  Created by YNKJMACMINI2 on 15/12/28.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol NLHttpRequestProtocol <NSObject>
-(NSString*)url;
-(JSONModel*)responseObjectWithDictionary:(NSDictionary*)dic err:(NSError*)err;
@end
