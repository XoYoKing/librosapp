//
//  ReaderFramesetter.h
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderFormatter.h"

@interface ReaderFramesetter : NSObject

@property (nonatomic, strong) ReaderFormatter * formatter;
// Keep this up to date when your view changes size!
@property (nonatomic) CGRect bounds;


-(id)pageForChapter:(NSInteger)chapter page:(NSInteger)page;
-(NSInteger)pagesForChapter:(NSInteger)chapter;


-(void)emptyExceptChapter:(NSInteger)chapter;
-(void)empty;

-(BOOL)hasPagesForChapter:(NSInteger)chapter;
-(void)ensurePagesForChapter:(NSInteger)chapter;


-(CGFloat)percentThroughChapter:(NSInteger)chapter page:(NSInteger)page;
-(NSInteger)pageForChapter:(NSInteger)chapter percent:(CGFloat)percent;
    
@end
