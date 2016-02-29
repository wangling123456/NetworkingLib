//
//  LoginResponse.h
//  NetworkingLib
//
//  Created by YNKJMACMINI2 on 15/12/28.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import "JSONModel.h"

@interface LoginResponse : JSONModel
@property (strong,nonatomic)NSString *status;
@property (strong,nonatomic)NSString *message;
@end
