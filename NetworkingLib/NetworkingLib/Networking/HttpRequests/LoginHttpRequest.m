//
//  NLLoginHttpRequest.m
//  NetworkingLib
//
//  Created by YNKJMACMINI2 on 15/12/28.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import "LoginHttpRequest.h"
#import "LoginResponse.h"

@implementation LoginHttpRequest
-(NSString*)url
{
    return @"http://192.168.88.218:8080/fds/inter/mobile/login";
}
-(JSONModel*)responseObjectWithDictionary:(NSDictionary*)dic err:(NSError*)err
{
    LoginResponse *resp = [[LoginResponse alloc] initWithDictionary:dic error:&err];
    return resp;
}
@end
