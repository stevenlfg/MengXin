//
//  NSString+Common.h
//  MengXin
//
//  Created by stevenlfg on 15/9/17.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
- (NSString *)md5Str;
- (NSString*) sha1Str;
- (NSString *)transformToPinyin;
@end
