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
#define myOrderId @"128|23" //胜
#define myAppKey @"20170329driverappwpy"

#define orderUrl229(a,b) [NSString stringWithFormat:@"http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=%@&driverid=129&companyid=23&lng=114.594564&lat=39.840367&token=%@",a,b]

#define orderUrl229a(a,b) [NSString stringWithFormat:@"http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=%ld&driverid=129&companyid=23&lng=114.594974&lat=39.836918&token=%@",a,b]

#define orderUrl269(a,b) [NSString stringWithFormat:@"http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=%@&driverid=269&companyid=23&lng=114.59695&lat=39.850959&token=%@",a,b]

#define orderUrl178(a,b) [NSString stringWithFormat:@"http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=%@&driverid=178&companyid=23&lng=114.594511&lat=39.84117&token=%@",a,b]


#define orderUrl337(a,b) [NSString stringWithFormat:@"http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=%@&driverid=337&companyid=23&lng=114.594511&lat=39.84117&token=%@",a,b]


#define orderUrlAll(a,b,c) [NSString stringWithFormat:@"http://183.196.249.184:9003/driver.ashx?func=updateordergrab&orderidid=%ld&driverid=269&companyid=23&%@&token=%@",a,b,c]

typedef void(^COMPLETION_BLOCK)(void);
#endif /* Custom_h */





