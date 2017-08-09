//
//  Decoder.m
//  H264Demo
//
//  Created by luo雨思 on 16/10/27.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "Decoder.h"
#import <VideoToolbox/VideoToolbox.h>
#import "FZJPhotoTool.h"
static void didFinishedDecompress( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
}

@interface Decoder ()
{
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
    
    VTDecompressionSessionRef _decoderSession;
    CMVideoFormatDescriptionRef _decoderFormatDescription;
    
    int ret;
    CVPixelBufferRef cache;
    BOOL _needShare;//用以标记是否要分享
}
@property(nonatomic, strong) dispatch_source_t timer;                  //
@property(nonatomic, copy) CollectImageComplete myImageBlock;          //添加完图片的block回调
@property(nonatomic, strong) NSMutableArray *shareImageArray;          //需要分享的图片数组

@end

@implementation Decoder

- (void)resetH264Decoder
{
    if(_decoderSession && _decoderSession != nil) {
        VTDecompressionSessionInvalidate(_decoderSession);
        CFRelease(_decoderSession);
        _decoderSession = NULL;
    }
    CFDictionaryRef attrs = NULL;
    const void *keys[] = { kCVPixelBufferPixelFormatTypeKey };
    //      kCVPixelFormatType_420YpCbCr8Planar is YUV420
    //      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange is NV12
    uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    const void *values[] = { CFNumberCreate(NULL, kCFNumberSInt32Type, &v) };
    attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    VTDecompressionOutputCallbackRecord callBackRecord;
    callBackRecord.decompressionOutputCallback = didFinishedDecompress;
    callBackRecord.decompressionOutputRefCon = NULL;
    if(VTDecompressionSessionCanAcceptFormatDescription(_decoderSession, _decoderFormatDescription))
    {
        
    }
    
    VTDecompressionSessionCreate(kCFAllocatorSystemDefault,
                                                   _decoderFormatDescription,
                                                   NULL, attrs,
                                                   &callBackRecord,
                                                   &_decoderSession);
    CFRelease(attrs);
}

-(BOOL)initH264Decoder  //创建会话
{
    if (_decoderSession) {
        return YES  ;
    }
    const uint8_t * const parameter[2] = {_sps , _pps};
    const size_t parameterSetSizes[2] = {static_cast<size_t>(_spsSize) , static_cast<size_t>(_ppsSize)};  //size_t 即 unsigned int
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault, 2, parameter, parameterSetSizes,
                                                                          4, //startcode 占4字节
                                                                          &_decoderFormatDescription);
    if (status == noErr) {
        
        CFDictionaryRef attrs = NULL;
        const void * keys[] = {kCVPixelBufferPixelFormatTypeKey};
        //  kCVPixelFormatType_420YpCbCr8Planar is YUV420
        //  kCVPixelFormatType_420YpCbCr8BiPlanarFullRange is NV12
        uint32_t yuv420 = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
        const void *values[] = {CFNumberCreate(NULL, kCFNumberSInt32Type, &yuv420)};
        attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
        
        VTDecompressionOutputCallbackRecord callBackRecord;
        callBackRecord.decompressionOutputCallback = didFinishedDecompress;
        callBackRecord.decompressionOutputRefCon = NULL;
        
        status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                              _decoderFormatDescription,
                                              NULL, attrs,
                                              &callBackRecord,
                                              &_decoderSession);
        CFRelease(attrs);
    }
    else return NO;
    
    return YES;
}

-(void)clearH264Deocder {
    if(_decoderSession) {
        VTDecompressionSessionInvalidate(_decoderSession);
        CFRelease(_decoderSession);
        _decoderSession = NULL;
    }
    
    if(_decoderFormatDescription) {
        CFRelease(_decoderFormatDescription);
        _decoderFormatDescription = NULL;
    }
    
    free(_sps);
    free(_pps);
    _spsSize = _ppsSize = 0;
}

-(CVPixelBufferRef)decode:(uint8_t *)buffer BufferSize:(int)bufferSize {
    
    if (!_sps || !_pps || !_ppsSize || !_spsSize) {
        return nil;
    }
    
    CVPixelBufferRef outputPixelBuffer = NULL;
    
    CMBlockBufferRef blockBuffer = NULL;
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                          buffer, bufferSize,
                                                          kCFAllocatorNull,
                                                          NULL, 0, bufferSize,
                                                          0, &blockBuffer);
    if(status == kCMBlockBufferNoErr) {
        CMSampleBufferRef sampleBuffer = NULL;
        
        const size_t sampleSizeArray[] = {static_cast<size_t>(bufferSize)};
        status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                           blockBuffer,
                                           _decoderFormatDescription ,
                                           1, 0, NULL, 1, sampleSizeArray,
                                           &sampleBuffer);
        if (status == kCMBlockBufferNoErr && sampleBuffer) {
            VTDecodeFrameFlags flags = 0;
            VTDecodeInfoFlags flagOut = 0;
            OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_decoderSession,
                                                                      sampleBuffer,
                                                                      flags,
                                                                      &outputPixelBuffer,
                                                                      &flagOut);
            
            if(decodeStatus == kVTInvalidSessionErr) {
//                NSLog(@"IOS8VT: Invalid session, reset decoder session");
                [self resetH264Decoder];
            } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
//                NSLog(@"IOS8VT: decode failed status=%d(Bad data)", decodeStatus); // decode failed status=-12911,一般是数据丢包，会产生绿色色块
            } else if(decodeStatus != noErr) {
//                NSLog(@"IOS8VT: decode failed status=%d", decodeStatus);
            }
            
            CFRelease(sampleBuffer);
        }
        CFRelease(blockBuffer);
    }
    
    return outputPixelBuffer;
}

-(void) decodeNalu:(uint8_t *)frame withSize:(uint32_t)frameSize
{
    //    NSLog(@">>>>>>>>>>开始解码");
    int nalu_type = (frame[4] & 0x1F);
    CVPixelBufferRef pixelBuffer = NULL;
    uint32_t nalSize = (uint32_t)(frameSize - 4);
    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    //转换字节序
    frame[0] = *(pNalSize + 3);
    frame[1] = *(pNalSize + 2);
    frame[2] = *(pNalSize + 1);
    frame[3] = *(pNalSize);
    //传输的时候。关键帧不能丢数据 否则绿屏   B/P可以丢  这样会卡顿
    switch (nalu_type)
    {
        case 0x05:
            //           NSLog(@"nalu_type:%d Nal type is IDR frame",nalu_type);  //关键帧
            if([self initH264Decoder])
            {
                pixelBuffer = [self decode:frame BufferSize:frameSize];
            }
            break;
        case 0x07:
            //           NSLog(@"nalu_type:%d Nal type is SPS",nalu_type);   //sps
            _spsSize = frameSize - 4;
            _sps = (uint8_t *) malloc(_spsSize);
            memcpy(_sps, &frame[4], _spsSize);
            break;
        case 0x08:
        {
            //            NSLog(@"nalu_type:%d Nal type is PPS",nalu_type);   //pps
            _ppsSize = frameSize - 4;
            _pps = (uint8_t *) malloc(_ppsSize);
            memcpy(_pps, &frame[4], _ppsSize);
            break;
        }
        default:
        {
            //            NSLog(@"Nal type is B/P frame");//其他帧
            if([self initH264Decoder])
            {
                pixelBuffer = [self decode:frame BufferSize:frameSize];
            }
            break;
        }
            
            
    }
    
    if(pixelBuffer) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _showLayer.pixelBuffer = pixelBuffer;
            
            dispatch_source_set_event_handler(self.timer, ^{
                if (_takePhotosNum > 0) {
                    cache = CVPixelBufferRetain(pixelBuffer);
                    [self costPic:cache];
                }
            });
        });
        
        CVPixelBufferRelease(pixelBuffer);
    }
    
}

- (void)gotSpsPps:(uint8_t*)sps pps:(uint8_t*)pps SpsSize:(int)spsSize PpsSize:(int)ppsSize
{
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    //发sps
    NSMutableData *h264Data = [[NSMutableData alloc] init];
    [h264Data appendData:ByteHeader];
    [h264Data appendBytes:sps length:spsSize];
    [self decodeNalu:(uint8_t *)[h264Data bytes] withSize:(uint32_t)h264Data.length];
    
//    NSLog(@"%@",h264Data);
    //发pps
    [h264Data resetBytesInRange:NSMakeRange(0, [h264Data length])];
    [h264Data setLength:0];
    [h264Data appendData:ByteHeader];
    [h264Data appendBytes:pps length:ppsSize];
//    NSLog(@"%@",h264Data);
    [self decodeNalu:(uint8_t *)[h264Data bytes] withSize:(uint32_t)h264Data.length];
}

#pragma mark - share

- (void)startShareAndCollectImageDataWithBlock:(CollectImageComplete)block {
    self.myImageBlock = block;
    _needShare = YES;
}

- (void)closeShare {
    _needShare = NO;
    self.shareImageArray = nil;
}

-(void)costPic:(CVPixelBufferRef)pixelBuffer
{
    if (_takePhotosNum > 0) {
        
        UIImage *image = [self getImg:pixelBuffer];
        if (image) {
            [[FZJPhotoTool sharedFZJPhotoTool] saveImageIntoCustomeCollectionFromImageArr:@[image] resultBlock:nil];
            if (_needShare) {
                [self.shareImageArray addObject:image];
            }
            
            CVPixelBufferRelease(cache);
            _takePhotosNum--;
        }
    }
    
    if (_takePhotosNum == 0 && _needShare && (self.shareImageArray.count > 0)) {
        if (self.myImageBlock) {
            self.myImageBlock(self.shareImageArray);
        }
        self.shareImageArray = nil;
    }
}

-(UIImage *)getImg:(CVPixelBufferRef)pixelBuf
{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuf];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuf),
                                                 CVPixelBufferGetHeight(pixelBuf))];
    
    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return uiImage;
}

- (NSMutableArray *)shareImageArray {
    
    if (_shareImageArray == nil) {
        _shareImageArray = [NSMutableArray array];
    }
    return _shareImageArray;
}

- (dispatch_source_t)timer {

    if (_timer == nil) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_resume(_timer);
    }
    return _timer;
}

@end
