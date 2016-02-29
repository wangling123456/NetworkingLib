//
//  Macro.h
//  NetworkingLib
//
//  Created by YNKJMACMINI2 on 15/12/28.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#endif /* Macro_h */



#ifdef wangling
#	define DLog(fmt, ...)   NSLog((@"[DEBUG]%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif
