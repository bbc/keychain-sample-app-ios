//
//  BBCiPCryptoKeyGeneration.m
//  BBCiPlayer
//
//  Created by John Steele on 21/01/2015.
//  Copyright (c) 2015 BBC. All rights reserved.
//

#import "BBCiPCryptoKeyGeneration.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>


@implementation BBCiPCryptoKeyGeneration

+ (NSData *)randomDataOfLength:(size_t)length
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    if (SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes) == -1) {
        return [[NSData alloc] init];
    }
    
    return data;
}

+ (NSData *)AESKeyForPassword:(NSString *)password salt:(NSData *)salt length:(NSUInteger)length
{
    const NSUInteger PBKDFRounds = 10000;
    
    NSMutableData *derivedKey = [NSMutableData dataWithLength:length];
    
    CCKeyDerivationPBKDF(kCCPBKDF2,                // algorithm
                         password.UTF8String,      // password
                         password.length,          // passwordLength
                         salt.bytes,               // salt
                         salt.length,              // saltLen
                         kCCPRFHmacAlgSHA1,        // Algorithm for the iterations
                         PBKDFRounds,              // The number of rounds of the Pseudo Random Algorithm to use
                         derivedKey.mutableBytes,  // derivedKey
                         derivedKey.length);       // derivedKeyLen
    
    return derivedKey;
}

- (NSData *)randomDataOfLength:(size_t)length
{
    return [BBCiPCryptoKeyGeneration randomDataOfLength:length];
}

@end
