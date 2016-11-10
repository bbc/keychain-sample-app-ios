//
//  AudioPlayer.h
//  KeychainTestApp
//
//  Created by Jayson Turner on 10/11/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayer : NSObject

- (instancetype)initWithURL:(NSURL*)url;
- (void)play;
- (void)stop;

@end
