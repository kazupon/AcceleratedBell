// 
//   BellPlayer.m
//   AcceleratedBell
//   
//   Created by kazuya kawaguchi on 2010-03-18.
//   Copyright 2010 kazuya kawaguchi. All rights reserved.
// 

#import "BellPlayer.h"


@implementation BellPlayer


@synthesize playBuffer;
@synthesize totalFrames;
@synthesize numberOfChannels;
@synthesize currentFrame;
@synthesize isDone;
@synthesize playCount;


static OSStatus renderCallback(void *inRefCon, 
                               AudioUnitRenderActionFlags *ioActionFlags, 
                               const AudioTimeStamp *inTimeStamp, 
                               UInt32 inBusNumber, 
                               UInt32 inNumberFrames, 
                               AudioBufferList *ioData) {
    
    BellPlayer *def = (BellPlayer *)inRefCon;
    
    AudioUnitSampleType *outLeft = ioData->mBuffers[0].mData;
    AudioUnitSampleType *outRight = ioData->mBuffers[1].mData;
    
    AudioUnitSampleType **buffer = def.playBuffer;
    SInt64 currentFrame = def.currentFrame;
    SInt64 totalFrames = def.totalFrames;
    UInt32 numberOfChannels = def.numberOfChannels;
    
    
    for(int i = 0; i < inNumberFrames; i++) {
        if(def.isDone) {
            *outLeft++ = *outRight++ = 0;
        } else {
            if(currentFrame == totalFrames) {
                currentFrame = 0;
                def.isDone = YES;
            }
            if(numberOfChannels == 2) { // Streao
                *outLeft++ = buffer[0][currentFrame++];
                *outRight++ = buffer[1][currentFrame];
            } else { // Monoral
                *outLeft++ = buffer[0][currentFrame++];
                *outRight++ = buffer[0][currentFrame];
            }
        }
    }
    
    def.currentFrame = currentFrame;
    
    return noErr;
}


- (id)initWithContentsOfURL:(NSURL *)url {
    
    if((self = [super init])) {
        [self prepareExtAudio:url];
        [self prepareAudioUint];
        playCount = 0;
    }
    
    return self;
}


- (void)dealloc {
    
    if(isPlaying)   [self stop];
    
    // Release audio buffer.
    for(int i = 0; i < numberOfChannels; i++)   free(playBuffer[i]);
    free(playBuffer);
    
    OSStatus error;
    error = AudioUnitUninitialize(audioUnit);
    [self checkError:error message:@"AudioUnitUninitialize"];
    
    AudioComponentInstanceDispose(audioUnit);
    DEBUG(@"AudioComponentInstanceDispose : %d", audioUnit);
    
    [super dealloc];
    
}


- (void)start {
    
    OSStatus error;
    if(!isPlaying) {
        error = AudioOutputUnitStart(audioUnit);
        [self checkError:error message:@"AudioOutputUnitStart"];
    }
    
    isPlaying = YES;
    
}


- (void)play {
    
    isDone = NO;
    currentFrame = 0;
    playCount++;
    
}


- (void)stop {
    
    OSStatus error;
    if(isPlaying) {
        error = AudioOutputUnitStop(audioUnit);
        [self checkError:error message:@"AudioOutputUnitStop"];
    }
    
    isPlaying = NO;
    
}


- (void)prepareAudioUint {
    
    OSStatus error;
    
    // Create AudioUnit.
    AudioComponentDescription audioComponent;
    audioComponent.componentType = kAudioUnitType_Output;
    audioComponent.componentSubType = kAudioUnitSubType_RemoteIO;
    audioComponent.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioComponent.componentFlags = 0;
    audioComponent.componentFlagsMask = 0;
    
    AudioComponent component = AudioComponentFindNext(NULL, &audioComponent);
    error = AudioComponentInstanceNew(component, &audioUnit);
    [self checkError:error message:@"AudioComponentInstanceNew"];
    error = AudioUnitInitialize(audioUnit);
    [self checkError:error message:@"AudioUnitInitialize"];
    
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = renderCallback;
    callbackStruct.inputProcRefCon = self;
    
    
    // Regist Callback Function.
    error = AudioUnitSetProperty(audioUnit, 
                                 kAudioUnitProperty_SetRenderCallback, 
                                 kAudioUnitScope_Input, 
                                 0, 
                                 &callbackStruct, 
                                 sizeof(AURenderCallbackStruct));
    [self checkError:error message:@"AudioUnitSetProperty"];
    
    
    // Setup Client Data Format.
    AudioStreamBasicDescription outputFormat;
    outputFormat.mSampleRate = 44100.0;
    outputFormat.mFormatID = kAudioFormatLinearPCM;
    outputFormat.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
    outputFormat.mChannelsPerFrame = 2;
    outputFormat.mBytesPerPacket = sizeof(AudioUnitSampleType);
    outputFormat.mBytesPerFrame = sizeof(AudioUnitSampleType);
    outputFormat.mFramesPerPacket = 1;
    outputFormat.mBitsPerChannel = 8 * sizeof(AudioUnitSampleType);
    outputFormat.mReserved = 0;
    
    
    // Setup AudioStreamBasicDescription fit channel count.
    error = AudioUnitSetProperty(audioUnit, 
                                 kAudioUnitProperty_StreamFormat, 
                                 kAudioUnitScope_Input, 
                                 0,
                                 &outputFormat, 
                                 sizeof(AudioStreamBasicDescription));
    [self checkError:error message:@"AudioUnitSetProperty"];
    
}


- (void)prepareExtAudio:(NSURL *)fileURL {
    
    OSStatus error;
    
    // Create ExtAudioFileRef.
    ExtAudioFileRef extAudioFile;
    error = ExtAudioFileOpenURL((CFURLRef)fileURL, &extAudioFile);
    [self checkError:error message:@"ExtAudioFileOpenURL"];
    
    
    // Get File Data Format.
    AudioStreamBasicDescription inputFormat;
    UInt32 size = sizeof(AudioStreamBasicDescription);
    error = ExtAudioFileGetProperty(extAudioFile, 
                                    kExtAudioFileProperty_FileDataFormat, 
                                    &size, 
                                    &inputFormat);
    [self checkError:error message:@"ExtAudioFileGetProperty"];
    
    
    // Fit file channle that played channle count.
    AudioStreamBasicDescription clientFormat;
    numberOfChannels = inputFormat.mChannelsPerFrame;
    clientFormat.mSampleRate = inputFormat.mSampleRate;
    clientFormat.mFormatID = kAudioFormatLinearPCM;
    clientFormat.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
    clientFormat.mChannelsPerFrame = inputFormat.mChannelsPerFrame;
    clientFormat.mBytesPerPacket = sizeof(AudioUnitSampleType);
    clientFormat.mBytesPerFrame = sizeof(AudioUnitSampleType);
    clientFormat.mFramesPerPacket = 1;
    clientFormat.mBitsPerChannel = 8 * sizeof(AudioUnitSampleType);
    clientFormat.mReserved = 0;
    
    
    // Setup reading format to audio unit normally.
    error = ExtAudioFileSetProperty(extAudioFile, 
                                    kExtAudioFileProperty_ClientDataFormat, 
                                    sizeof(AudioStreamBasicDescription), 
                                    &clientFormat);
    [self checkError:error message:@"ExtAudioFileSetProperty"];
    
    
    // Get total frames.
    SInt64 fileLengthFrames;
    size = sizeof(SInt64);
    error = ExtAudioFileGetProperty(extAudioFile, 
                                    kExtAudioFileProperty_FileLengthFrames, 
                                    &size, 
                                    &fileLengthFrames);
    [self checkError:error message:@"ExtAudioFileGetProeprty"];
    totalFrames = fileLengthFrames;
    
    
    // Create AudioBufferList.
    playBuffer = malloc(sizeof(AudioUnitSampleType *) * numberOfChannels);
    for(int i = 0; i < numberOfChannels; i++) {
        playBuffer[i] = malloc(sizeof(AudioUnitSampleType) * fileLengthFrames);
    }
    AudioBufferList *audioBufferList = malloc(sizeof(AudioBufferList));
    audioBufferList->mNumberBuffers = numberOfChannels;
    for(int i = 0; i < numberOfChannels; i++) {
        audioBufferList->mBuffers[i].mNumberChannels = 1;
        audioBufferList->mBuffers[i].mDataByteSize = 
                                sizeof(AudioUnitSampleType) * fileLengthFrames;
        audioBufferList->mBuffers[i].mData = playBuffer[i];
    }
    
    
    // Move location to 0.
    error = ExtAudioFileSeek(extAudioFile, 0);
    [self checkError:error message:@"ExtAudioFileSeek"];
    
    // Read all frame buffers.
    UInt32 readFrameSize = fileLengthFrames;
    error = ExtAudioFileRead(extAudioFile, &readFrameSize, audioBufferList);
    [self checkError:error message:@"ExtAudioFileRead"];
    
    
    free(audioBufferList);
    currentFrame = 0;
    
}


- (void)checkError:(OSStatus)status message:(NSString *)message {
    
    DEBUG(@"%@ : %d", message, status);
    if(status) exit(1);
    
}


@end
