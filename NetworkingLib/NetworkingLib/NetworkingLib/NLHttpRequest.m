//
//  NLHttpRequest.m
//  NetworkingLib
//
//  Created by YNKJMACMINI2 on 15/12/28.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import "NLHttpRequest.h"
#import "AFNetworking.h"

#define kMaxRequestCount 3

@interface NLHttpRequest()
@property (strong,nonatomic)AFHTTPSessionManager *manager;
@property (weak,nonatomic)id<NLHttpRequestProtocol> child;
@property (strong,nonatomic)NSURLSessionDataTask *task;
@property (assign,nonatomic)NSInteger requestCount;
@property (assign,nonatomic)BOOL isCancel;
@end

@implementation NLHttpRequest

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        if ([self conformsToProtocol:@protocol(NLHttpRequestProtocol)]) {
            self.child = (id<NLHttpRequestProtocol>)self;
        }
        [self configManager];
        self.requestCount = 0;
    }
    return self;
}

-(void)doRequestWithParameters:(NSDictionary*)parameters andBlock:(void(^)(id responseObject,NSError *error))block
{
    __block NSError *err = nil;
    
    if (self.isCancel) {
        err =[NSError errorWithDomain:@"LYFaultDiagnosis" code:-1002 userInfo:@{NSLocalizedDescriptionKey:@"请求被取消"}];
        block(nil,err);
        return;
    }
    //请求次数+1
    self.requestCount++;
    
    self.task = [self.manager POST:[self.child url] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"request URL: %@",task.originalRequest.URL.absoluteString);
        NSLog(@"response dictionary: %@",responseObject);
        
        NSDictionary *respDic = (NSDictionary *)responseObject;
        NSInteger statusCode =[[responseObject objectForKey:@"statusCode"] integerValue];
        if(statusCode>=200 && statusCode<300)  //statusCode在200——300之间
        {
            
            id respObj = [self.child responseObjectWithDictionary:respDic err:err];
            if (err){
                //json转model出错
                block(nil,err);
            }
            else{
                if (statusCode==200) {  //200
                    block(respObj,nil);
                }
                else  //200+
                {
                    err =[NSError errorWithDomain:@"LYFaultDiagnosis" code:(NSInteger)statusCode userInfo:@{NSLocalizedDescriptionKey:[respDic objectForKey:@"message"]}];
                    block(respObj,err);
                }
            }
            
        }
        else if(statusCode>=300) //300+
        {
            err =[NSError errorWithDomain:@"LYFaultDiagnosis" code:(NSInteger)statusCode userInfo:@{NSLocalizedDescriptionKey:[respDic objectForKey:@"message"]}];
            block(nil,err);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull err) {
        
        NSLog(@"request URL: %@",task.originalRequest.URL.absoluteString);
        if(![err.localizedDescription isEqualToString:@"cancelled"])
        {
            //判断是否达到最大访问次数
            if(self.requestCount < kMaxRequestCount)
            {
                //没达到最大次数，继续请求
                [self doRequestWithParameters:parameters andBlock:block];
            }
            else
            {
                block(nil,err);
            }
        }
        else
        {
            err =[NSError errorWithDomain:@"LYFaultDiagnosis" code:-1002 userInfo:@{NSLocalizedDescriptionKey:@"请求被取消"}];
            block(nil,err);
        }
    }];
}

-(void)cancel
{
    self.isCancel = YES;
    if(self.task)
    {
        [self.task cancel];
    }

}

#pragma mark - private method
-(void)configManager
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    self.manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
}
@end
