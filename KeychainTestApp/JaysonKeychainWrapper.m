//
//  JaysonKeychainWrapper.m
//  KeychainTestApp
//
//  Created by Jayson Turner on 10/11/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "JaysonKeychainWrapper.h"

@implementation JaysonKeychainWrapper

- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup {
    self = [super init];
    if (self) {
        
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

@end
