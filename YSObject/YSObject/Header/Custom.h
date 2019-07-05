//
//  Custom.h
//  安泰
//
//  Created by Long on 2019/2/22.
//  Copyright © 2019 Long. All rights reserved.
//

#ifndef Custom_h
#define Custom_h


//#define myOrderId @"269|23"
#define myOrderId @"129|23" //胜
#define myAppKey @"20170329driverappwpy"
#define orderUrl(a,b) [NSString stringWithFormat:@"http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=%@&driverid=129&companyid=23&lng=114.594974&lat=39.836918&token=%@",a,b]



typedef void(^COMPLETION_BLOCK)(void);
#endif /* Custom_h */





