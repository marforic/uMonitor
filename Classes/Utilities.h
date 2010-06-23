/*
Utilities.h
Copyright (c) 2010, "Claudio Marforio - Mike Godenzi" (<marforio@gmail.com - godenzim@gmail.com>)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

+ Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

+ Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

+ Neither the name of the <ORGANIZATION> nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <Foundation/Foundation.h>


@interface Utilities : NSObject {

}

+(NSString *)getStatusReadable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress;
+(int) getStatusProgrammable:(NSDecimalNumber *)status forProgress:(NSDecimalNumber *)progress;
+(NSString *)getSizeReadable:(NSDecimalNumber *)size;
+(NSString *)getSpeedReadable:(NSDecimalNumber *)speed;
+(NSString *)getRatioReadable:(NSDecimalNumber *)ratio;
+(NSString *)getETAReadable:(NSDecimalNumber *)eta;
+(NSString *)getAvailabilityReadable:(NSDecimalNumber *)availability;
+(void)createAndShowAlertWithTitle:(NSString *)title andMessage:(NSString *)message withDelegate:(id)del andTag:(NSInteger)tag;
+(void)alertOKCancelAction:(NSString *)title andMessage:(NSString *)message withDelegate:(id)del;
+(void)showLoadingCursorForViewController:(UIViewController *)controller;
+(UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor;
+(NSArray *)RGBtoHSB:(UIColor *)RGBcolor;
+ (void)insertItemOrderedByName:(NSArray *)item inArrey:(NSMutableArray *)ma;
+ (void)removeNotNeededTorrentsFromList:(NSArray *)organizedTorrents 
						andOriginalList:(NSMutableArray *)torrentsData
					   usingRemovedList:(NSArray *)removedTorrents 
						andNeedToDelete:(BOOL)needToDelete;

@end
