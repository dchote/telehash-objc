//
//  CryptoHashAdditions.h
//  telehash
//
//  Source: http://blog.mightykan.com/post/1364629932/md5-sha1-sha256-and-sha512-in-cocoa
//
//

#import <Foundation/Foundation.h>

@interface NSData (CryptoHashing)

- (NSData *)md5Hash;
- (NSString *)md5HexHash;

- (NSData *)sha1Hash;
- (NSString *)sha1HexHash;

- (NSData *)sha256Hash;
- (NSString *)sha256HexHash;

- (NSData *)sha512Hash;
- (NSString *)sha512HexHash;

@end