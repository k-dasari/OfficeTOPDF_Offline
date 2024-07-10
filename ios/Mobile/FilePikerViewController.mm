//
//  FilePikerViewController.m
//  Mobile
//
//  Created by Karthik Dasari on 05/06/24.
//  Copyright © 2024 Collabora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilePikerViewController.h"
#import "DocumentViewController.h"

#import "config.h"

#import <cstdio>

#import <objc/message.h>
#import <objc/runtime.h>

#import <poll.h>
#import <sys/stat.h>

#import "ios.h"
#import "FakeSocket.hpp"
#import "COOLWSD.hpp"
#import "Log.hpp"
#import "MobileApp.hpp"
#import "SigUtil.hpp"
#import "Util.hpp"


//@implementation FilePikerViewController

// - (void)connect {
//   /* In here would be code to attempt a connection to the
//    * specified URL, while possibly handling connection errors.
//    */
// }
//
// + (BOOL)canHandleRequest:(NSString *)type
//                   forUrl:(NSString *)url {
//   /* And in here would be code to see if the given URL passed
//    * in is capable of handling the HTTP request type specified
//    * by the "type" parameter. It will return YES or NO.
//    */
//     return YES;
// }

@implementation FilePickerViewController

- (void)viewDidLoad {
    printf("############### viewDidLoad");
}

static std::atomic<unsigned> appDocIdCounter(1);

- (void)viewDidAppear:(BOOL)animated {
    printf("############### viewDidAppear");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"doc_table" ofType:@"doc"];
    if (filePath) {
        NSLog(@"File path: %@", filePath);
        
        NSURL *docUrl = [NSURL fileURLWithPath:filePath];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DocumentViewController *documentViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DocumentViewController"];
        documentViewController.document = [[CODocument alloc] initWithFileURL:docUrl];
        documentViewController.document->fakeClientFd = -1;
        documentViewController.document->appDocId = appDocIdCounter++;
        documentViewController.document->readOnly = false;
        documentViewController.document.viewController = documentViewController;
        [self presentViewController:documentViewController animated:YES completion:nil];
        
       

        // Access the Downloads directory
        NSURL *downloadsDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask].firstObject;
        if (!downloadsDirectory) {
            NSLog(@"Could not find the Downloads directory");
            return;
        }

        // Generate the file name with the desired format extension
        
        NSString *originalFileName = [[docUrl lastPathComponent] stringByDeletingPathExtension];
        NSString *fileName = [originalFileName stringByAppendingPathExtension:@"pdf"];
        NSURL *downloadAsURL = [downloadsDirectory URLByAppendingPathComponent:fileName];

        // Remove any existing file at the path
        NSError *removeError = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[downloadAsURL path]]) {
            if (![[NSFileManager defaultManager] removeItemAtURL:downloadAsURL error:&removeError]) {
                NSLog(@"Could not remove existing file: %@", removeError.localizedDescription);
                return;
            }
        }
        
        DocumentData::allocate(1).coDocument = documentViewController.document;
        DocumentData *data = new DocumentData();
        
       // data->loKitDocument =  documentViewController.document;


        NSTimeInterval delayInSeconds = 30.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          NSLog(@"############## Delay Executing");
            DocumentData::get(documentViewController.document->appDocId).loKitDocument->saveAs([[downloadAsURL absoluteString] UTF8String], "pdf", nullptr);

        });
        
        
        // Save the document to the specified file
        //DocumentData::get(documentViewController.document->appDocId).loKitDocument->saveAs([[downloadAsURL absoluteString] UTF8String], [@"pdf" UTF8String], nullptr);

        // Verify that the file was saved
        struct stat statBuf;
        if (stat([[downloadAsURL path] UTF8String], &statBuf) == -1) {
            NSLog(@"Could not save to '%s'", [[downloadAsURL path] UTF8String]);
            return;
        }

        // Log success message
        NSLog(@"File saved to '%s'", [[downloadAsURL path] UTF8String]);

            
            
    } else {
        NSLog(@"File not found in bundle");
    }
    
    
   
    printf("############### viewDidAppear completed");
}

 @end
