//
//  ViewController.m
//  DESDemo
//
//  Created by Phùng Hoàng Bắc on 4/22/16.
//  Copyright © 2016 Phùng Hoàng Bắc. All rights reserved.
//

#import "ViewController.h"
#include <CommonCrypto/CommonCryptor.h>

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* a = @"hehe";
    NSString* pass = @"pass";
    NSData* data = [a dataUsingEncoding: NSUTF8StringEncoding];
    NSData* encryptData = [self encryptDESByKey:[pass dataUsingEncoding:NSUTF8StringEncoding] data:data];
    NSLog(@"%@", data);
    NSLog(@"%@", encryptData);
    NSData* decryot = [self decryptDESByKey:[pass dataUsingEncoding:NSUTF8StringEncoding] data:encryptData];
    NSLog(@"%@", decryot);
    NSString* decrytString = [[NSString alloc] initWithData:decryot encoding:NSUTF8StringEncoding];
    NSLog(@"%@", decrytString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData *)encryptDESByKey:(NSData *)key data:(NSData *)data
{
    size_t numBytesEncrypted = 0;
    size_t bufferSize = data.length + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    
    CCCryptorStatus result = CCCrypt( kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding,
                                     key.bytes, kCCKeySizeDES,
                                     NULL,
                                     data.bytes, data.length,
                                     buffer, bufferSize,
                                     &numBytesEncrypted);
    NSData *output = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    free(buffer);
    if( result == kCCSuccess )
    {
        return output;
    } else {
        NSLog(@"Failed DES encrypt...");
        return nil;
    }
}

- (NSData *) decryptDESByKey:(NSData *)key data:(NSData *)data
{
    size_t numBytesEncrypted = 0;
    
    size_t bufferSize = data.length + kCCBlockSizeDES;
    void *buffer_decrypt = malloc(bufferSize);
    CCCryptorStatus result = CCCrypt( kCCDecrypt , kCCAlgorithmDES, kCCOptionPKCS7Padding,
                                     key.bytes, kCCKeySizeDES,
                                     NULL,
                                     data.bytes, data.length,
                                     buffer_decrypt, bufferSize,
                                     &numBytesEncrypted );
    
    NSData *output = [NSData dataWithBytes:buffer_decrypt length:numBytesEncrypted];
    free(buffer_decrypt);
    if( result == kCCSuccess )
    {
        return output;
    } else {
        NSLog(@"Failed DES decrypt ...");
        return nil;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"begin");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
}

@end
