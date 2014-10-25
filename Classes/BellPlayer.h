//
//   BellPlayer.h
//   AcceleratedBell
//
//   Created by kazuya kawaguchi on 2010-03-18.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface BellPlayer : NSObject {

    AudioUnit audioUnit;
    BOOL isPlaying;
    BOOL isDone;
    UInt32 numberOfChannels;
    SInt64 totalFrames;
    SInt64 currentFrame;
    int playCount;
    AudioUnitSampleType **playBuffer;
}


@property (readonly) AudioUnitSampleType **playBuffer;
@property (readonly) UInt32 numberOfChannels;
@property (readonly) SInt64 totalFrames;
@property SInt64 currentFrame;
@property BOOL isDone;
@property int playCount;


- (id)initWithContentsOfURL:(NSURL *)url;

- (void)start;
- (void)play;
- (void)stop;
- (void)prepareAudioUint;
- (void)prepareExtAudio:(NSURL *)fileURL;

@end
