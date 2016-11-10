//
//  AudioPlayer.m
//  KeychainTestApp
//
//  Created by Jayson Turner on 10/11/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer ()
@property (strong) NSURL *url;
@property (strong) AVAudioPlayer *player;
@end

@implementation AudioPlayer

- (instancetype)initWithURL:(NSURL*)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)play {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    NSError *error;
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_url error:&error];
    
    if (error) {
        NSLog(@"Error %@", error);
    }

    [_player play];
}

- (void)stop {
    [_player pause];
}

@end
