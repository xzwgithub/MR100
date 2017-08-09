//
//  FTPManager.m
//  DVDemo
//
//  Created by luo雨思 on 16/7/5.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "FTPManager.h"
#import "TcpManager.h"

#define Host_IP @"192.168.100.1"
#define PORT @"21"
enum {
    kSendBufferSize = 32768
};

@interface FTPManager ()<NSStreamDelegate>
{
    NSInputStream *   fileStream;
    NSOutputStream *  networkStream;
    
    NSString *ip;
    NSString *port;
    NSString *userName;
    NSString *password;
    
}
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;

@end

@implementation FTPManager
{
    uint8_t                     _buffer[kSendBufferSize];
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        port = PORT;
        ip = Host_IP;
        userName = @"AW819";
        password = @"1663819";
    }
    return self;
}

-(NSString *)desUrl
{
    
    return [NSString stringWithFormat:@"%@:%@/",ip,port];
}

-(void)startSendFirmware:(NSString *)filePath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    
    BOOL                    success;
    NSURL *                 url;
    url = [self smartURLForString: [self desUrl]];
    NSLog(@"%@--des url",url.absoluteString);
    success = (url != nil);
    if (success) {
        // Add the last part of the file name to the end of the URL to form the final
        // URL that we're going to put to.
        
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                                );
        success = (url != nil);
    }
    
    if ( ! success) {
        NSLog(@"url为空");
    } else {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
        fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(fileStream != nil);
        
        [fileStream open];
        
        // Open a CFFTPStream for the URL.
        
        networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        assert(networkStream != nil);
        
        if ([userName length] != 0) {
            success = [networkStream setProperty:userName forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            success = [networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
        }
        
        networkStream.delegate = self;
        [networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [networkStream open];
        
    }
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
//            [self updateStatus:@"Sending"];
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [fileStream read:_buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self stopSend];  //error
                } else if (bytesRead == 0) {
                    [self stopSend];  //完成
                    NSLog(@"传输完成");
                    if (self.resultBlock)
                    {
                        self.resultBlock(YES);
                    }
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [networkStream write:&_buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSend];  // network error
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            NSLog(@"ftp 上传出错");
            [self stopSend];
            if (self.resultBlock)
            {
                self.resultBlock(NO);
            }
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)stopSend
{
    if (networkStream != nil) {
        [networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        networkStream.delegate = nil;
        [networkStream close];
        networkStream = nil;
    }
    if (fileStream != nil) {
        [fileStream close];
        fileStream = nil;
    }
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && ([trimmedStr length] != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"ftp"  options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

@end
