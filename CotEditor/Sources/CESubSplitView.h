/*
=================================================
CESubSplitView
(for CotEditor)

 Copyright (C) 2004-2007 nakamuxu.
 Copyright (C) 2014 CotEditor Project
 http://coteditor.github.io
=================================================

encoding="UTF-8"
Created:2006.03.18
 
-------------------------------------------------

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. 


=================================================
*/

@import Cocoa;
#import "CEEditorWrapper.h"
#import "CENavigationBarController.h"
#import "CETextView.h"
#import "CESyntaxParser.h"


@interface CESubSplitView : NSView <NSTextViewDelegate>

@property (nonatomic, weak) CEEditorWrapper *editorWrapper;

// readonly
@property (nonatomic, readonly) CETextView *textView;
@property (nonatomic, readonly) CENavigationBarController *navigationBar;
@property (nonatomic, readonly) CESyntaxParser *syntaxParser;


// Public method
- (NSString *)string;
- (void)replaceTextStorage:(NSTextStorage *)textStorage;
- (void)setTextViewToEditorWrapper:(CETextView *)textView;
- (void)setShowLineNum:(BOOL)showLineNum;
- (void)setShowNavigationBar:(BOOL)setNavigationBar;
- (void)setWrapLines:(BOOL)wrapLines;
- (void)setShowInvisibles:(BOOL)showInvisibles;
- (void)setAutoTabExpandEnabled:(BOOL)isEnabled;
- (void)setUseAntialias:(BOOL)useAntialias;
- (void)updateCloseSubSplitViewButton:(BOOL)isEnabled;
- (BOOL)showPageGuide;
- (void)setCaretToBeginning;
- (void)setSyntaxWithName:(NSString *)styleName;
- (void)recolorAllTextViewString;
- (void)updateOutlineMenu;
- (void)updateOutlineMenuSelection;
- (void)stopUpdateLineNumberTimer;
- (void)stopUpdateOutlineMenuTimer;
- (NSCharacterSet *)firstCompletionCharacterSet;
- (void)setBackgroundColorAlpha:(CGFloat)alpha;

@end
