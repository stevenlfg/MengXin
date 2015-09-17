//
//  Login.h
//  MengXin
//
//  Created by stevenlfg on 15/9/17.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Login : NSObject
//请求
@property (readwrite, nonatomic, strong) NSString *email, *password, *j_captcha;
@property (readwrite, nonatomic, strong) NSNumber *remember_me;

- (NSString *)goToLoginTipWithCaptcha:(BOOL)needCaptcha;
- (NSDictionary *)toParams;

+ (BOOL) isLogin;
+ (void) doLogin:(NSDictionary *)loginData;
+ (void) doLogout;
+ (void)setPreUserEmail:(NSString *)emailStr;
+ (NSString *)preUserEmail;
+ (User *)curLoginUser;
+ (void)setXGAccountWithCurUser;
+ (User *)userWithGlobaykeyOrEmail:(NSString *)textStr;
+ (NSMutableDictionary *)readLoginDataList;
+(BOOL)isLoginUserGlobalKey:(NSString *)global_key;
@end
