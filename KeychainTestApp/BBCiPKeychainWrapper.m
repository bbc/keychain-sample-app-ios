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
    [self savePasswordForIdentifier:_identifier password:data];
    return 0;
}

- (id)objectForKey:(id)key {
    return [self passwordForIdentifier:_identifier];
}

- (void)resetKeychainItem {
    NSMutableDictionary *keychainItem = [self createNewEmptyKeychainDictionaryWithIdentifier:_identifier];
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
        NSLog(@"Delete Error Code: %d", (int)sts);
    }
}

#pragma mark -
#pragma mark Private Methods

- (NSData*)passwordForIdentifier:(NSString*)identifier {
    
    NSData *password = nil;
    NSMutableDictionary *keychainItem = [self createNewEmptyKeychainDictionaryWithIdentifier:identifier];
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    
    NSLog(@"Find Error Code: %d", (int)sts);
    
    if(sts == noErr)
    {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        password = resultDict[(__bridge id)kSecValueData];
    }
    
    return password;
}

- (OSStatus)savePasswordForIdentifier:(NSString*)identifier password:(NSData*)password {
    OSStatus status;
    
    NSMutableDictionary *keychainItem = [self createNewEmptyKeychainDictionaryWithIdentifier:identifier];
    
    if(!(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)) {
        keychainItem[(__bridge id)kSecValueData] = [[NSData alloc] initWithData:password];
        
        status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"Add Error Code: %d", (int)status);
    } else {
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [[NSData alloc] initWithData:password];;
        
        status = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        NSLog(@"Update Error Code: %d", (int)status);
    }
    
    return status;
}

- (NSMutableDictionary*)createNewEmptyKeychainDictionaryWithIdentifier:(NSString*)identifier {
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    keychainItem[(__bridge id)kSecAttrService] = identifier;
    keychainItem[(__bridge id)kSecAttrAccount] = identifier;
    keychainItem[(__bridge id)kSecAttrGeneric] = identifier;

    return keychainItem;
}

@end
