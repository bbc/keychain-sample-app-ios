//
//  Keychain.h
//  KeychainTestApp
//
//  Created by Jayson Turner on 10/11/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Keychain <NSObject>

// Designated initializer.
- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup;
- (OSStatus)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;

@end
