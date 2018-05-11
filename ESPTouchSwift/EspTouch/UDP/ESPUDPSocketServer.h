//
//  ESPUDPSocketServer.h
//  EspTouchDemo
//
//  Created by 白 桦 on 4/13/15.
//  Copyright (c) 2015 白 桦. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BUFFER_SIZE 64

@interface ESPUDPSocketServer : NSObject
{
    @private
    Byte _buffer[BUFFER_SIZE];
}

@property (nonatomic, assign) int port;

- (void) close;

- (void) interrupt;


- (void) setSocketTimeout: (int) timeout;

/**
 * Receive one byte from the port
 *
 * @return one byte receive from the port or UINT8_MAX(it impossible receive it from the socket)
 */
- (Byte) receiveOneByte4;

- (NSData *) receiveSpecLenBytes4: (int)len;

- (Byte) receiveOneByte6;

- (NSData *) receiveSpecLenBytes6:(int)len;

- (id) initWithPort: (int) port AndSocketTimeout: (int) socketTimeout;

@end
