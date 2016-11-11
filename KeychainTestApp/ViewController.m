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
#import "BBCiPKeychainWrapper.h"
#import "AudioPlayer.h"

const size_t kKeyLength = 64;
const int delayInSeconds = 10;
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
@property (strong) dispatch_queue_t queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keychainType = KeychainTypeAppleWrapper;
    _queue = dispatch_queue_create("uk.co.bbc.KeychainTestApp.bg_queue", NULL);
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
    [self add];
}

- (IBAction)getKeyButtonPressed:(id)sender {
    [self get];
}

- (IBAction)addKeyAfterFiveSecondsButtonPressed:(id)sender {
    [self delayedAdd];
}

- (IBAction)getKeyAfterFiveSecondsButtonPressed:(id)sender {
    [self delayedGet];
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

- (void)add {
    dispatch_async(_queue, ^{
        OSStatus result = [[self keychain] setObject:_currentKeyData forKey:(__bridge id)kSecValueData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _addKeyResultLabel.text = [NSString stringWithFormat:@"%d", result];
        });
    });
}

- (void)get {
    dispatch_async(_queue, ^{
        NSData *keyData = [[self keychain] objectForKey:(__bridge id)kSecValueData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _getKeyResultLabel.text = [NSString stringWithFormat:@"%@", keyData];
        });
    });
}

- (void)delayedAdd {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delay, _queue, ^(void){
        
        OSStatus result = [[self keychain] setObject:_currentKeyData forKey:(__bridge id)kSecValueData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _addKeyResultLabel.text = [NSString stringWithFormat:@"%d", result];
        });
    });
}

- (void)delayedGet {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delay, _queue, ^(void){
        
        NSData *keyData = [[self keychain] objectForKey:(__bridge id)kSecValueData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _getKeyResultLabel.text = [NSString stringWithFormat:@"%@", keyData];
        });
    });
}

- (id<Keychain>)keychain {
    if (_keychainType == KeychainTypeAppleWrapper) {
        return [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainIdentifier accessGroup:nil];
    } else {
        return [[BBCiPKeychainWrapper alloc] initWithIdentifier:kKeychainIdentifier accessGroup:nil];
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
