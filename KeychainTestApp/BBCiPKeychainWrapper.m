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
    return 0;
}

- (id)objectForKey:(id)key {
    return nil;
}

- (void)resetKeychainItem {
    
}

#pragma mark -
#pragma mark Private Methods

- (NSString*)getPasswordForIdentifier:(NSString*)identifier {
    return nil;
}

- (void)savePasswordForIdentifier:(NSString*)identifier password:(NSString*)item {
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrGeneric] = identifier;
    
    if(!(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)) {
        keychainItem[(__bridge id)kSecValueData] = item;
        
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"Error Code: %d", (int)sts);
    }
}

@end
