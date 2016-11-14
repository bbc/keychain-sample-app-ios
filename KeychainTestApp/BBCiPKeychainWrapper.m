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

- (id)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (void)setData:(NSData*)data status:(OSStatus *)status{
    [self saveDataForIdentifier:_identifier data:data status:status];
}

- (NSData*)dataAndStatus:(OSStatus *)status {
    return [self dataForIdentifier:_identifier status:status];
}

- (void)resetKeychainAndGetStatus:(OSStatus*)status {
    NSMutableDictionary *keychainItem = [self createNewEmptyKeychainDictionaryWithIdentifier:_identifier];
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        *status = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
    }
}

#pragma mark -
#pragma mark Private Methods

- (NSData*)dataForIdentifier:(NSString*)identifier status:(OSStatus*)status{
    
    NSData *data = nil;
    NSMutableDictionary *keychainItem = [self createNewEmptyKeychainDictionaryWithIdentifier:identifier];
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    
    *status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    
    if(*status == noErr && result)
    {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        data = resultDict[(__bridge id)kSecValueData];
    }
    
    return data;
}

- (void)saveDataForIdentifier:(NSString*)identifier data:(NSData*)data status:(OSStatus*)status{
    
    NSMutableDictionary *keychainItem = [self createNewEmptyKeychainDictionaryWithIdentifier:identifier];
    
    if(!(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)) {
        keychainItem[(__bridge id)kSecValueData] = [[NSData alloc] initWithData:data];
        *status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
    } else {
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [[NSData alloc] initWithData:data];;
        
        *status = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
    }
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
