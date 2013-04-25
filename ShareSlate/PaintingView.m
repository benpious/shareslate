/*
     File: PaintingView.m
 Abstract: The class responsible for the finger painting. The class wraps the 
 CAEAGLLayer from CoreAnimation into a convenient UIView subclass. The view 
 content is basically an EAGL surface you render your OpenGL scene into.
  Version: 1.11
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
*/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "PaintingView.h"

//CLASS IMPLEMENTATIONS:

// A class extension to declare private methods
@interface PaintingView (private)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation PaintingView

@synthesize  location;
@synthesize  previousLocation;

// Implement this to override the default layer class (which is [CALayer class]).
// We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    
	CGImageRef		brushImage;
	CGContextRef	brushContext;
	GLubyte			*brushData;
	size_t			width, height;
    
    self = [super initWithFrame:frame];
    
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        self.isActive = YES;
		
		eaglLayer.opaque = YES;
		// In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		
		// Create a texture from an image
		// First create a UIImage object from the data in a image file, and then extract the Core Graphics image
		brushImage = [UIImage imageNamed:@"Particle.png"].CGImage;
		
		// Get the width and height of the image
		width = CGImageGetWidth(brushImage);
		height = CGImageGetHeight(brushImage);
		
		// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
		// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
		
		// Make sure the image exists
		if(brushImage) {
			// Allocate  memory needed for the bitmap context
			brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
			// Use  the bitmatp creation function provided by the Core Graphics framework.
			brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
			// After you create the context, you can draw the  image to the context.
			CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
			// You don't need the context at this point, so you need to release it to avoid memory leaks.
			CGContextRelease(brushContext);
			// Use OpenGL ES to generate a name for the texture.
			glGenTextures(1, &brushTexture);
			// Bind the texture name.
			glBindTexture(GL_TEXTURE_2D, brushTexture);
			// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			// Specify a 2D texture image, providing the a pointer to the image data in memory
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
			// Release  the image data; it's no longer needed
            free(brushData);
		}
		
		// Set the view's scale factor
		self.contentScaleFactor = 1.0;
        
		// Setup OpenGL states
		glMatrixMode(GL_PROJECTION);
		//CGRect frame = self.bounds;
        //NSLog(@"%f,%f", frame.size.height, frame.size.width);
		CGFloat scale = self.contentScaleFactor;
		// Setup the view port in Pixels
        //assumes a view size of 797 and 753
		glOrthof(0, 1024 * scale, 0, 768 * scale, -1, 1);
		glViewport(0, 0, 1024 * scale, 768 * scale);
		glMatrixMode(GL_MODELVIEW);
		glDisable(GL_DITHER);
		glEnable(GL_TEXTURE_2D);
        
		glEnableClientState(GL_VERTEX_ARRAY);
		
	    glEnable(GL_BLEND);
		// Set a blending function appropriate for premultiplied alpha pixel data
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnable(GL_POINT_SPRITE_OES);
		glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
		glPointSize(width / kBrushScale);

		// Make sure to start with a cleared buffer
		needsErase = YES;
		
        notificationCenter = [NSNotificationCenter defaultCenter];
        self.currColor = malloc(sizeof(colorData));
		//glEnableClientState(GL_COLOR_ARRAY);
        [self setBrushColorWithRed:0.1f green:0.1f blue:0.1f];
        
        self.brushPointsCapacity = 1000;

        self.brushPoints = malloc(sizeof(pointData) * self.brushPointsCapacity);
        self.colorForBrushPoints = malloc(sizeof(colorData) * self.brushPointsCapacity);
        self.versionIndices =  [[NSMutableArray alloc] initWithCapacity:5] ;
        self.autoVersionTimer = [NSTimer timerWithTimeInterval: 2.0 target:self selector:@selector(addNewVersion:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.autoVersionTimer forMode:NSDefaultRunLoopMode];
    }
    
    
    return self;
}

-(void) addNewVersion: (NSTimer*) timer
{
    [self.versionIndices insertObject: [NSNumber numberWithLong:self.numBrushPoints] atIndex:0];
}

-(void) revertToIndex: (NSNumber*) version
{
    self.numBrushPoints = [((NSNumber*)[self.versionIndices objectAtIndex: version.intValue]) longValue];
    [self renderLines];
}

// If our view is resized, we'll be asked to layout subviews.
// This is the perfect opportunity to also update the framebuffer so that it is
// the same size as our display area.
-(void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	
	// Clear the framebuffer the first time it is allocated
	if (needsErase) {
		[self erase];
		needsErase = NO;
	}
}

- (BOOL)createFramebuffer
{
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

// Releases resources when they are not longer needed.
- (void) dealloc
{
	if (brushTexture)
	{
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];
	[super dealloc];
}

// Erases the screen
- (void) erase
{
	[EAGLContext setCurrentContext:context];
	
	// Clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(1.0, 1.0, 1.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

// Draws a line onscreen based on where the user touches
/*
    This method records the touches twice -- once to draw the first time, and 
    once to handle revisions such as undo/redo and version control reverts
 */
- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{

	NSUInteger			vertexCount = 0,
						count,
						i;
    
    static GLfloat*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 64;

    [EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);

    glBindTexture(GL_TEXTURE_2D, brushTexture);

    if(vertexBuffer == NULL)
		vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));

	

	// Convert locations from Points to Pixels
	CGFloat scale = self.contentScaleFactor;
	start.x *= scale;
	start.y *= scale;
	end.x *= scale;
	end.y *= scale;
	
	// Add points to the buffer so there are drawing points every X pixels
	count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
	for(i = 0; i < count; ++i) {
        
        //record for immediate drawing
        if(vertexCount == vertexMax) {
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
		}
        
        vertexBuffer[2 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
		vertexBuffer[2 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
        vertexCount += 1;

        
        //record for later drawing 
        if(self.numBrushPoints == self.brushPointsCapacity) {
            self.brushPointsCapacity = 2 * self.brushPointsCapacity;
            self.brushPoints = realloc(self.brushPoints, self.brushPointsCapacity * sizeof(pointData));
            self.colorForBrushPoints = realloc(self.colorForBrushPoints, self.brushPointsCapacity * sizeof(colorData));
		}
        
        pointData* curr = malloc(sizeof(pointData));
        colorData* currColor = malloc(sizeof(colorData));
        curr->x = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
        curr->y = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
        currColor->r = self.currColor->r;
        currColor->g = self.currColor->g;
        currColor->b = self.currColor->b;
        currColor->a = self.currColor->a;
        self.brushPoints[self.numBrushPoints] = *curr;
        free(curr);
        self.colorForBrushPoints[self.numBrushPoints] = *currColor;
        free(currColor);
        self.numBrushPoints+=1;
        
        
	}
    glDisableClientState(GL_COLOR_ARRAY);
	// Render the vertex array
	glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
     

}

-(void) renderLines
{
    [EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glBindTexture(GL_TEXTURE_2D, brushTexture);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    // Render the vertex array
    glColorPointer(4, GL_FLOAT, sizeof(colorData), self.colorForBrushPoints);
	glVertexPointer(2, GL_FLOAT, sizeof(pointData), self.brushPoints);
	glDrawArrays(GL_POINTS, 0, self.numBrushPoints);
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
    glDisableClientState(GL_COLOR_ARRAY);
    
    


    
}

-(UIImage*) renderLinesFromIndex: (NSNumber*) index
{
    
    if (index.intValue > self.numBrushPoints) {
        return nil;
    }
    
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;

    
    glEnableClientState(GL_COLOR_ARRAY);
    glBindTexture(GL_TEXTURE_2D, brushTexture);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    // Render the vertex array
    glColorPointer(4, GL_FLOAT, sizeof(colorData), self.colorForBrushPoints);
	glVertexPointer(2, GL_FLOAT, sizeof(pointData), self.brushPoints);
	glDrawArrays(GL_POINTS, 0, index.intValue);
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
    glDisableClientState(GL_COLOR_ARRAY);
        
    //CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));

    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                    ref, NULL, true, kCGRenderingIntentDefault);
    
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, width, height), iref);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);

    
    //return [[UIImage alloc] initWithCGImage:imgRef];
    return image;
}



-(void) renderImageFrom: (CGPoint) start
{
    
    if (self.imageToDraw == nil) {
        self.imageToDraw = [UIImage imageNamed:@"sampleImage"];
    }
    
    glColor4f(1, 1, 1, 1);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    GLubyte			*imageData;
	CGContextRef	imageContext;
    GLuint imageTexture;
    
    [EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    
    size_t width = CGImageGetWidth(self.imageToDraw.CGImage);
    size_t height = CGImageGetHeight(self.imageToDraw.CGImage);
    // Allocate  memory needed for the bitmap context
    imageData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
    // Use  the bitmatp creation function provided by the Core Graphics framework.
    imageContext = CGBitmapContextCreate(imageData, width, height, 8, width * 4, CGImageGetColorSpace(self.imageToDraw.CGImage), kCGImageAlphaPremultipliedLast);
    // After you create the context, you can draw the  image to the context.
    CGContextDrawImage(imageContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), self.imageToDraw.CGImage);
    // You don't need the context at this point, so you need to release it to avoid memory leaks.
    CGContextRelease(imageContext);
    // Use OpenGL ES to generate a name for the texture.
    glGenTextures(1, &imageTexture);
    // Bind the texture name.
    glBindTexture(GL_TEXTURE_2D, imageTexture);
    // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    // Specify a 2D texture image, providing the a pointer to the image data in memory
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    // Release  the image data; it's no longer needed
    free(imageData);
    GLfloat* imageVertexBuffer = NULL;

    CGFloat scale = self.contentScaleFactor;
	start.x *= scale;
	start.y *= scale;

    imageVertexBuffer = [self populateArraysWithScaleFactor:1.0 xOffset:start.x yOffset:start.y withScreenSize:[self bounds] CGImage: self.imageToDraw.CGImage];
    GLfloat* textureVertexBuffer = [self defineTextureCoords];
    glTexCoordPointer(2, GL_FLOAT, 0, textureVertexBuffer);
    glVertexPointer(2, GL_FLOAT, 0, imageVertexBuffer);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
    
    free(imageVertexBuffer);
    free(textureVertexBuffer);

    glColor4f(0, 0, 0, 1);

    
}


// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!(self.isActive)) {
        return;
    }
    
    
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	location = [touch locationInView:self];
	location.y = bounds.size.height - location.y;
    
    if (self.drawingImages) {
        [self renderImageFrom: location];
        NSString* coords = [[NSString alloc] initWithFormat:@"i:%f:%fC", location.x, location.y];
        [notificationCenter postNotification: [NSNotification notificationWithName:@"imageDrawingEvent" object:coords ]];

        return;
    }

}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
   	
    if (!(self.isActive)) {
        return;
    }
    
    if (self.drawingImages) {
        
        return;
    }
    
	CGRect				bounds = [self bounds];
	UITouch*			touch = [[event touchesForView:self] anyObject];
		
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
	} else {
		location = [touch locationInView:self];
	    location.y = bounds.size.height - location.y;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
	}
		
	// Render the stroke
    NSString* coords = [[NSString alloc] initWithFormat:@"b:%f:%f:%f:%fC", previousLocation.x, previousLocation.y, location.x, location.y];
    [notificationCenter postNotification: [NSNotification notificationWithName:@"drawingEvent" object:coords ]];

	[self renderLineFromPoint:previousLocation toPoint:location];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!(self.isActive)) {
        return;
    }
    
    if (self.drawingImages) {
        
        return;
    }
    
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
		[self renderLineFromPoint:previousLocation toPoint:location];
        NSString* coords = [[NSString alloc] initWithFormat:@"b:%f:%f:%f:%fC", previousLocation.x, previousLocation.y, location.x, location.y];
        //NSLog(@"%@",coords);
        [notificationCenter postNotification: [NSNotification notificationWithName:@"drawingEvent" object:coords ]];
	}
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	// Set the brush color using premultiplied alpha values
	glColor4f(red	* kBrushOpacity,
			  green * kBrushOpacity,
			  blue	* kBrushOpacity,
			  kBrushOpacity);
    self.currColor->r = red;
    self.currColor->g = green;
    self.currColor->b = blue;
    self.currColor->a = kBrushOpacity;
}


-(GLfloat*) populateArraysWithScaleFactor: (GLfloat) scaleFactor xOffset: (GLfloat) xOffset yOffset: (GLfloat) yOffset withScreenSize: (CGRect) screenSize CGImage: (CGImageRef) ref
{
    
    GLfloat* vertexCoords = malloc(sizeof(GLfloat) * 12);
    
   GLfloat height = CGImageGetHeight(ref) ;
   GLfloat width = CGImageGetWidth(ref);
   
   vertexCoords[0] = width + xOffset;
   vertexCoords[1] = height + yOffset;
   vertexCoords[2] = xOffset;
   vertexCoords[3] = yOffset;
   vertexCoords[4] = xOffset;
   vertexCoords[5] = height + yOffset;
   vertexCoords[6] = width + xOffset;
   vertexCoords[7] = height + yOffset;
   vertexCoords[8] = width + xOffset;
   vertexCoords[9] = yOffset;
   vertexCoords[10] = xOffset;
   vertexCoords[11] = yOffset;
    
    return vertexCoords;

}

-(GLfloat*) defineTextureCoords
{
    
    GLfloat* textureCoordsArray = malloc(sizeof(GLfloat) * 12);
    
    textureCoordsArray[0] = 0.0f;
    textureCoordsArray[1] = 0.0f;
    
    textureCoordsArray[2] = 1.0f;
    textureCoordsArray[3] = 1.0f;
    
    textureCoordsArray[4] = 1.0f;
    textureCoordsArray[5] = 0.0f;
    
    textureCoordsArray[6] = 0.0f;
    textureCoordsArray[7] = 0.0f;
    
    textureCoordsArray[8] = 0.0f;
    textureCoordsArray[9] = 1.0f;
    
    textureCoordsArray[10] = 1.0f;
    textureCoordsArray[11] = 1.0f;
    

    return textureCoordsArray;
    
}

-(void) setPointSize:(float) pointsize
{
    glPointSize(pointsize / kBrushScale);
}

/*
    Draws previous versions into offscreen opengl es contexts, then gets a bitmap of the 
    result and puts it into the array as a uiimageview to return
 
 */
-(NSMutableArray*) makeVersionPreviews
{
    NSMutableArray* imageViews = [[NSMutableArray alloc] initWithCapacity: [self.versionIndices count]];
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;

    GLuint colorRenderbuffer;
    glGenRenderbuffers(1, &colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA4, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    if(status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", status);
    }

    //test int to limit amount of versions made
    int i =0;
    for (NSNumber* currIndex in self.versionIndices)
    {
        if (i > 5) {
            break;
        }
        i++;
        UIImageView* currView = [[UIImageView alloc] initWithImage: [self renderLinesFromIndex:currIndex]];
        UIViewController* currController = [[UIViewController alloc] init];
        currController.view = currView;
        [imageViews addObject:currController];
    }
    
    //fix opengl state
    
    return imageViews;
}

@end
