/*
 
 NSString+Indentation.m
 
 CotEditor
 http://coteditor.com
 
 Created by 1024jp on 2015-10-16.
 
 ------------------------------------------------------------------------------
 
 © 2015 1024jp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import "NSString+Indentation.h"


static const NSUInteger MIN_DETECTION_LINES = 5;
static const NSUInteger MAX_DETECTION_LINES = 100;


@implementation NSString (Indentation)

#pragma mark Public Methods

// ------------------------------------------------------
/// detect indent style
- (CEIndentStyle)detectIndentStyle
// ------------------------------------------------------
{
    if ([self length] == 0) { return CEIndentStyleNotFound; }
    
    // count up indentation
    __block NSUInteger tabCount = 0;
    __block NSUInteger spaceCount = 0;
    __block NSUInteger lineCount = 0;
    [[self copy] enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop)
    {
        if (lineCount >= MAX_DETECTION_LINES) {
            *stop = YES;
        }
        
        lineCount++;
        
        if ([line length] == 0) { return; }
        
        // check first character
        switch ([line characterAtIndex:0]) {
            case '\t':
                tabCount++;
                break;
            case ' ':
                spaceCount++;
                break;
        }
    }];
    
    // detect indent style
    if (tabCount + spaceCount < MIN_DETECTION_LINES) {  // no enough lines to detect
        return CEIndentStyleNotFound;
        
    } else if (tabCount > spaceCount * 2) {
        return  CEIndentStyleTab;
        
    } else if (spaceCount > tabCount * 2) {
        return CEIndentStyleSpace;
    }
    
    return CEIndentStyleNotFound;
}


// ------------------------------------------------------
/// standardize indent style
- (nonnull NSString *)stringByStandardizingIndentStyleTo:(CEIndentStyle)indentStyle tabWidth:(NSUInteger)tabWidth
// ------------------------------------------------------
{
    NSString *regexPattern;
    NSString *template;
    switch (indentStyle) {
        case CEIndentStyleSpace:
            regexPattern = @"(^|\\G)\t";
            template =[@"" stringByPaddingToLength:tabWidth withString:@" " startingAtIndex:0];  // repeat space chars
            break;
            
        case CEIndentStyleTab:
            regexPattern = [NSString stringWithFormat:@"(^|\\G) {%li}", tabWidth];
            template = @"\t";
            break;
            
        default:
            return [self copy];  // do nothing
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionAnchorsMatchLines error:nil];
    
    return [regex stringByReplacingMatchesInString:self options:0
                                             range:NSMakeRange(0, [self length])
                                      withTemplate:template];
}

@end
