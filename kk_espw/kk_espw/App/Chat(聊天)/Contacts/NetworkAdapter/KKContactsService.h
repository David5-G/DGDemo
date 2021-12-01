//
//  KKContactsService.h
//  kk_espw
//
//  Created by 阿杜 on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKContactsService : NSObject

+(void)requestMyContacts:(void(^)(NSArray *,NSArray *))finish;

@end

