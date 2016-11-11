//
//  BBCiPKeychainWrapper.m
//  KeychainTestApp
//
//  Created by Jayson Turner on 10/11/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCiPKeychainWrapper.h"

@interface BBCiPKeychainWrapper ()
@property (strong) NSString *identifier;
@end

@implementation BBCiPKeychainWrapper

- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (OSStatus)setObject:(id)inObject forKey:(id)key {
    NSData *data = (NSData*)inObject;
    NSString *password = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self savePasswordForIdentifier:_identifier password:password];
    return 0;
}

- (id)objectForKey:(id)key {
    return [self passwordForIdentifier:_identifier];
}

- (void)resetKeychainItem {
    
}

#pragma mark -
#pragma mark Private Methods

- (NSString*)passwordForIdentifier:(NSString*)identifier {
    
    NSString *password = nil;
//
//    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
//    
//    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
//    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
//    keychainItem[(__bridge id)kSecAttrGeneric] = identifier;
//    
//    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
//        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
//        attributesToUpdate[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
//        
//        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
//        NSLog(@"Error Code: %d", (int)sts);
//    }

    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrGeneric] = identifier;
    
    //Check if this keychain item already exists.
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    
    NSLog(@"Error Code: %d", (int)sts);
    
    if(sts == noErr)
    {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *pswd = resultDict[(__bridge id)kSecValueData];
        password = [[NSString alloc] initWithData:pswd encoding:NSUTF8StringEncoding];
    }
    
    return password;
}

- (OSStatus)savePasswordForIdentifier:(NSString*)identifier password:(NSString*)item {
    OSStatus status;
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrGeneric] = identifier;
    
    if(!(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)) {
        keychainItem[(__bridge id)kSecValueData] = [item dataUsingEncoding:NSUTF8StringEncoding];
        
        status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"Error Code: %d", (int)status);
    }
    
    return status;
}

@end
