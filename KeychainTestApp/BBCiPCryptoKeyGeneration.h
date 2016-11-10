//
//  BBCiPCryptoKeyGeneration.h
//  BBCiPlayer
//
//  Created by John Steele on 21/01/2015.
//  Copyright (c) 2015 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCiPCryptoKeyGeneration : NSObject

+ (NSData *)randomDataOfLength:(size_t)length;
+ (NSData *)AESKeyForPassword:(NSString *)password salt:(NSData *)salt length:(NSUInteger)length;

- (NSData *)randomDataOfLength:(size_t)length;

@end
