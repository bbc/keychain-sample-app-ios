//
//  ViewController.m
//  KeychainTestApp
//
//  Created by Jayson Turner on 09/11/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "ViewController.h"
#import "BBCiPCryptoKeyGeneration.h"
#import "KeychainItemWrapper.h"
#import "JaysonKeychainWrapper.h"
#import "AudioPlayer.h"

const size_t kKeyLength = 64;
NSString * const kKeychainIdentifier = @"uk.co.bbc.KeychainTestApp";

typedef enum : NSUInteger {
    KeychainTypeAppleWrapper = 0,
    KeychainTypeMyWrapper = 1,
} KeychainType;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *keyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addKeyResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *getKeyResultLabel;
@property (strong) NSData *currentKeyData;
@property KeychainType keychainType;
@property (strong) AudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keychainType = KeychainTypeAppleWrapper;
    [self cleanUp];
}

#pragma mark -
#pragma mark UI Actions
- (IBAction)playMusicButtonPressed:(id)sender {
    NSString *birdSongPath = [[NSBundle mainBundle] pathForResource:@"Exotic-birds-chirping" ofType:@"mp3"];
    NSURL *birdSongURL = [NSURL URLWithString:birdSongPath];
    _audioPlayer = [[AudioPlayer alloc] initWithURL:birdSongURL];
    [_audioPlayer play];
}

- (IBAction)stopMusicButtonPressed:(id)sender {
    [_audioPlayer stop];
}

- (IBAction)newKeyButtonPressed:(id)sender {
    _currentKeyData = [[[BBCiPCryptoKeyGeneration alloc] init] randomDataOfLength:kKeyLength];
    _keyValueLabel.text = [NSString stringWithFormat:@"%@", _currentKeyData];
}

- (IBAction)addKeyButtonPressed:(id)sender {
    OSStatus result = [[self keychain] setObject:_currentKeyData forKey:(__bridge id)kSecValueData];
    _addKeyResultLabel.text = [NSString stringWithFormat:@"%d", result];
}

- (IBAction)getKeyButtonPressed:(id)sender {
    NSData *keyData = [[self keychain] objectForKey:(__bridge id)kSecValueData];
    _getKeyResultLabel.text = [NSString stringWithFormat:@"%@", keyData];
}

- (IBAction)addKeyAfterFiveSecondsButtonPressed:(id)sender {
    [self performSelectorInBackground:@selector(delayedAdd) withObject:nil];
}

- (IBAction)getKeyAfterFiveSecondsButtonPressed:(id)sender {
    [self performSelectorInBackground:@selector(delayedGet) withObject:nil];
}

- (IBAction)resetButtonPressed:(id)sender {
    [[self keychain] resetKeychainItem];
}

- (IBAction)cleanButtonPressed:(id)sender {
    [self cleanUp];
}


- (IBAction)segmentControlValueChanged:(id)sender {
    UISegmentedControl *segmentControl = (UISegmentedControl*)sender;
    
    if ([segmentControl selectedSegmentIndex] == 0) {
        _keychainType = KeychainTypeAppleWrapper;
    } else if ([segmentControl selectedSegmentIndex] == 1) {
        _keychainType = KeychainTypeMyWrapper;
    }
    
    [self cleanUp];
}

#pragma mark -
#pragma mark Private Methods

- (void)delayedAdd {
    sleep(60);
    [self performSelectorOnMainThread:@selector(addKeyButtonPressed:) withObject:nil waitUntilDone:NO];
}

- (void)delayedGet {
    sleep(60);
    [self performSelectorOnMainThread:@selector(getKeyButtonPressed:) withObject:nil waitUntilDone:NO];
}

- (id<Keychain>)keychain {
    if (_keychainType == KeychainTypeAppleWrapper) {
        return [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainIdentifier accessGroup:nil];
    } else {
        return [[JaysonKeychainWrapper alloc] initWithIdentifier:kKeychainIdentifier accessGroup:nil];
    }
    
    return nil;
}

- (void)cleanUp {
    _currentKeyData = nil;
    _getKeyResultLabel.text = @"";
    _addKeyResultLabel.text = @"";
    _keyValueLabel.text = @"";
}


@end
