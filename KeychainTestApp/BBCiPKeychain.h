//
//  Keychain.h
//  KeychainTestApp
//
//  Created by Jayson Turner on 10/11/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBCiPKeychain <NSObject>

- (instancetype)initWithIdentifier:(NSString *)identifier;
- (void)setData:(NSData*)data status:(OSStatus*)status;
- (NSData*)dataAndStatus:(OSStatus*)status;
- (void)resetKeychainAndGetStatus:(OSStatus*)status;

@end
