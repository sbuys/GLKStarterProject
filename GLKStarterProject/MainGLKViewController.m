//
//  MainGLKViewController.m
//  GLKStarterProject
//
//  Created by Sebastian Buys on 2/6/13.
//  Copyright (c) 2013 Sebastian Buys. All rights reserved.
//

#import "MainGLKViewController.h"

typedef struct {
    GLKVector3 Position;
    GLKVector3 Normal;
    GLKVector2 Texture;
} Vertex;

@interface MainGLKViewController ()
{
    GLuint _vertexBuffer;
    Vertex *_vertices;
    int _numVertices;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

@end



@implementation MainGLKViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
    }
    return self;
}

#pragma mark - GLKViewControllerDelegate

- (void)update {
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.effect prepareToDraw];
    
    //Clear buffer
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //Bind buffer
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    //Setup position vertices
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    
    [self setProjectionAndTransformation];
    
    glDrawArrays(GL_TRIANGLE_STRIP,0, _numVertices);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    self.view = [GLKView new];
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    //view.drawableMultisample = GLKViewDrawableMultisample4X;
    //view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupVertices];
    [self setupGL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self tearDownGL];
    // free(_vertices);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    self.effect = [[GLKBaseEffect alloc] init];
    
    self.effect.useConstantColor = GL_TRUE;
    
    self.effect.constantColor = GLKVector4Make(1.0f,
                                               1.0f,
                                               1.0f,
                                               1.0f);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * _numVertices, _vertices, GL_STATIC_DRAW);
    
}

- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:self.context];
    glDeleteBuffers(1, &_vertexBuffer);
    self.effect = nil;
}

- (void)setupVertices
{
    _numVertices = 4;
    NSLog(@"Setting up %i vertices",_numVertices);
    _vertices = calloc(_numVertices, sizeof(Vertex));
    
    if(_vertices)
    {
        Vertex vertex0 = { {-0.5, -0.5, 0.0}, {0.0, 0.0} };
        
        Vertex vertex1 = { {0.5, -0.5, 0.0}, {1.0, 0.0} };
        
        Vertex vertex2 = { {-0.5, 0.5, 0.0}, {0.0, 1.0} };
        
        Vertex vertex3 = { {0.5, 0.5, 0.0}, {1.0, 1.0} };
        
        _vertices[0] = vertex0;
        _vertices[1] = vertex1;
        _vertices[2] = vertex2;
        _vertices[3] = vertex3;
        
    } else
    {
        NSLog(@"Could not allocate memory for vertices on heap");
    }
}

- (void)setProjectionAndTransformation
{
    /*float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
     GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
     self.effect.transform.projectionMatrix = projectionMatrix;
     GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
     self.effect.transform.modelviewMatrix = modelViewMatrix;*/
    
    /*GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(
     GLKMathDegreesToRadians(-60.0f), 1.0f, 0.0f, 0.0f);
     modelViewMatrix = GLKMatrix4Rotate(
     modelViewMatrix,
     GLKMathDegreesToRadians(-30.0f), 0.0f, 0.0f, 1.0f);
     modelViewMatrix = GLKMatrix4Translate(
     modelViewMatrix,
     0.0f, 0.0f, 0.25f);
     
     self.effect.transform.modelviewMatrix = modelViewMatrix;*/
    
    
    //Scale the Y coordinate based on the aspect ratio of the view's Layer which matches the screen aspect ratio
    GLKView *glkView = (GLKView*)self.view;
    const GLfloat aspectRatio = (GLfloat)glkView.drawableWidth / (GLfloat) glkView.drawableHeight;
    self.effect.transform.projectionMatrix = GLKMatrix4MakeScale( 1.0f, aspectRatio, 1.0f);
    
    /*GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(_xTranslation, -0.72, 0.0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;*/
    
}

#pragma mark - Interface Orientation overrides
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
