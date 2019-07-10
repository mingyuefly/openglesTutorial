//
//  OpenGLView.m
//  Tutorial06
//
//  Created by Gguomingyue on 2017/11/30.
//  Copyright © 2017年 Gguomingyue. All rights reserved.
//

#import "OpenGLView.h"
#import "GLESUtils.h"
#import "ParametricEquations.h"
#import "Quaternion.h"
#import "GLESMath.h"

@implementation DrawableVBO

- (void) cleanup
{
    if (_vertexBuffer != 0) {
        glDeleteBuffers(1, &_vertexBuffer);
        _vertexBuffer = 0;
    }
    
    if (_lineIndexBuffer != 0) {
        glDeleteBuffers(1, &_lineIndexBuffer);
        _lineIndexBuffer = 0;
    }
    
    if (_triangleIndexBuffer) {
        glDeleteBuffers(1, &_triangleIndexBuffer);
        _triangleIndexBuffer = 0;
    }
}

@end

@interface OpenGLView ()
{
    NSMutableArray * _vboArray;
    DrawableVBO * _currentVBO;
    
    ivec2 _fingerStart;
    Quaternion _orientation;
    Quaternion _previousOrientation;
    KSMatrix4 _rotationMatrix;
}

- (void)setupLayer;
- (void)setupContext;
- (void)setupBuffers;
- (void)destoryBuffers;

- (void)setupProgram;
- (void)setupProjection;

- (DrawableVBO *)createVBO:(int)surfaceType;
- (void)setupVBOs;
- (void)destroyVBOs;

- (ISurface *)createSurface:(int)surfaceType;
- (vec3)mapToSphere:(ivec2)touchpoint;
- (void)updateSurfaceTransform;
- (void)resetRotation;
- (void)drawSurface;

@end

@implementation OpenGLView

#pragma mark - Initilize GL

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupProgram];
        [self setupProjection];
        
        [self resetRotation];
        _vboArray = [@[] mutableCopy];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupProgram];
        [self setupProjection];
        
        [self resetRotation];
        _vboArray = [@[] mutableCopy];
    }
    return self;
}

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

-(void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

-(void)setupContext
{
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:_context]) {
        _context = nil;
        
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupBuffers
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    // Set as current renderbuffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // Allocate color renderbuffer
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    // Set as current framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    // Attach _colorRenderBuffer to _frameBuffer
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)destoryBuffers
{
    if (_colorRenderBuffer != 0) {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    
    if (_frameBuffer != 0) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
}

-(void)cleanup
{
    [self destroyVBOs];
    [self destoryBuffers];
    
    if (_programHandle != 0) {
        glDeleteProgram(_programHandle);
        _programHandle = 0;
    }
    
    if (_context && [EAGLContext currentContext] == _context)
    {
        [EAGLContext setCurrentContext:nil];
    }
    
    _context = nil;
}

-(void)setupProgram
{
    // Load shaders
    //
    NSString * vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader"
                                                                  ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader"
                                                                    ofType:@"glsl"];
    
    _programHandle = [GLESUtils loadProgram:vertexShaderPath
                 withFragmentShaderFilepath:fragmentShaderPath];
    if (_programHandle == 0) {
        NSLog(@" >> Error: Failed to setup program.");
        return;
    }
    
    glUseProgram(_programHandle);
    
    // Get the attribute position slot from program
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
    
    // Get the attribute color slot from program
    _colorSlot = glGetAttribLocation(_programHandle, "vSourceColor");
    
    // Get the uniform model-view matrix slot from program
    _modelViewSlot = glGetUniformLocation(_programHandle, "modelView");
    
    // Get the uniform projection matrix slot from program
    _projectionSlot = glGetUniformLocation(_programHandle, "projection");
}

-(void)setupProjection
{
    // Generate a perspective matrix with a 60 degree FOV
    float aspect = self.frame.size.width / self.frame.size.height;
    ksMatrixLoadIdentity(&_projectionMatrix);
    ksPerspective(&_projectionMatrix, 60.0, aspect, 4.0f, 12.0f);
    
    // Load projection matrix
    glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    glEnable(GL_CULL_FACE);//背面剔除
}

const int SurfaceSphere = 0;
const int SurfaceCone = 1;
const int SurfaceTorus = 2;
const int SurfaceTrefoilKnot = 3;
const int SurfaceKleinBottle = 4;
const int SurfaceMobiusStrip = 5;
const int SurfaceMaxCount = 6;

-(ISurface *)createSurface:(int)type
{
    ISurface *surface = NULL;
    if (type == SurfaceCone) {
        surface = new Cone(4, 1);
    } else if (type == SurfaceTorus) {
        surface = new Torus(2.0f, 0.3f);
    } else if (type == SurfaceTrefoilKnot) {
        surface = new TrefoilKnot(2.4f);
    } else if (type == SurfaceKleinBottle) {
        surface = new KleinBottle(0.25f);
    } else if (type == SurfaceMobiusStrip) {
        surface = new MobiusStrip(1.4);
    } else {
        surface = new Sphere(2.0f);
    }
    return surface;
}

-(void)setCurrentSurface:(int)index
{
    index = index % [_vboArray count];
    _currentVBO = [_vboArray objectAtIndex:index];
    
    [self resetRotation];
    [self render];
}

// 创建顶点缓存对象，分配空间并初始化
-(DrawableVBO *)createVBO:(int)surfaceType
{
    ISurface * surface = [self createSurface:surfaceType];
    
    // Get vertice from surface.
    int vertexSize = surface->GetVertexSize();
    int vBufSize = surface->GetVertexCount() * vertexSize;
    GLfloat * vbuf = new GLfloat[vBufSize];
    surface->GenerateVertices(vbuf);
    
    // Get triangle indices from surface
    int triangleIndexCount = surface->GetTriangleIndexCount();
    unsigned short * triangleBuf = new unsigned short[triangleIndexCount];
    surface->GenerateTriangleIndices(triangleBuf);
    
    // Get line indices from surface
    int lineIndexCount = surface->GetLineIndexCount();
    unsigned short * lineBuf = new unsigned short[lineIndexCount];
    surface->GenerateLineIndices(lineBuf);
    
    // Create the VBO for the vertice
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);//创建顶点缓存对象
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);//设置对象为数组缓存对象
    // 为顶点缓存对象申请内存空间（显存空间），并进行初始化
    glBufferData(GL_ARRAY_BUFFER, vBufSize * sizeof(GLfloat), vbuf, GL_STATIC_DRAW);
    
    // Create the VBO for the line indice
    GLuint lineIndexBuffer;
    glGenBuffers(1, &lineIndexBuffer);//创建顶点缓存对象
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, lineIndexBuffer);//设置对象为元素缓存对象
    // 为顶点缓存对象申请内存空间，并进行初始化
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, lineIndexCount * sizeof(GLushort), lineBuf, GL_STATIC_DRAW);
    
    // Create the VBO for the triangle indice
    GLuint triangleIndexBuffer;
    glGenBuffers(1, &triangleIndexBuffer);//创建顶点缓存对象
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, triangleIndexBuffer);//设置对象为元素缓存对象
    // 为顶点缓存对象申请内存空间，并进行初始化
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, triangleIndexCount * sizeof(GLushort), triangleBuf, GL_STATIC_DRAW);
    
    delete [] vbuf;
    delete [] lineBuf;
    delete [] triangleBuf;
    delete surface;
    
    DrawableVBO *vbo = [[DrawableVBO alloc] init];
    vbo.vertexBuffer = vertexBuffer;
    vbo.lineIndexBuffer = lineIndexBuffer;
    vbo.triangleIndexBuffer = triangleIndexBuffer;
    vbo.vertexSize = vertexSize;
    vbo.lineIndexCount = lineIndexCount;
    vbo.triangleIndexCount = triangleIndexCount;
    
    return vbo;
}

-(void)setupVBOs
{
    for (int i = 0; i < SurfaceMaxCount; i++) {
        DrawableVBO *vbo = [self createVBO:i];
        [_vboArray addObject:vbo];
        vbo = nil;
    }
    [self setCurrentSurface:0];
}

-(void)destroyVBOs
{
    for (DrawableVBO * vbo in _vboArray) {
        [vbo cleanup];
    }
    _vboArray = nil;
    
    _currentVBO = nil;
}

-(void)resetRotation
{
    ksMatrixLoadIdentity(&_rotationMatrix);
    _previousOrientation.ToIdentity();
    _orientation.ToIdentity();
}

-(void)updateSurfaceTransform
{
    ksMatrixLoadIdentity(&_modelViewMatrix);
    
    ksTranslate(&_modelViewMatrix, 0.0, 0.0, -7);
    
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    
    // Load the model-view matrix
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}

// 使用VBO进行渲染
-(void)drawSurface
{
    if (_currentVBO == nil) {
        return;
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, [_currentVBO vertexBuffer]);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, [_currentVBO vertexSize] * sizeof(GLfloat), 0);// 因为上面使用了glBindBuffer，所以最后一个参数可以为0
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw the red triangles.
    glVertexAttrib4f(_colorSlot, 1.0, 0.0, 0.0, 1.0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [_currentVBO triangleIndexBuffer]);
    glDrawElements(GL_TRIANGLES, [_currentVBO triangleIndexCount], GL_UNSIGNED_SHORT, 0);//使用顶点索引数组渲染
    
    // Draw the black lines.
    glVertexAttrib4f(_colorSlot, 0.0, 0.0, 0.0, 1.0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [_currentVBO lineIndexBuffer]);
    glDrawElements(GL_LINES, [_currentVBO lineIndexCount], GL_UNSIGNED_SHORT, 0);// 因为上面使用了glBindBuffer，所以最后一个参数可以为0
    
    // 背面剔除
    glDisableVertexAttribArray(_positionSlot);
}

-(void)render
{
    if (_context == nil) {
        return;
    }
    
    glClearColor(0.0, 1.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);//清除之前的绘制
    
    // Setup viewport
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self updateSurfaceTransform];
    [self drawSurface];
    
    [_context presentRenderbuffer:GL_RENDERER];
}

-(void)layoutSubviews
{
    [EAGLContext setCurrentContext:_context];
    glUseProgram(_programHandle);
    
    [self destoryBuffers];
    
    // 创建渲染缓存
    [self setupBuffers];
    
    // 创建模型
    [self setupVBOs];
    
    // 进行渲染着色
    [self render];
}

#pragma mark - Touch events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    _fingerStart = ivec2(location.x, location.y);
    _previousOrientation = _orientation;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    ivec2 touchPoint = ivec2(location.x, location.y);
    
    vec3 start = [self mapToSphere:touchPoint];
    vec3 end = [self mapToSphere:touchPoint];
    
    Quaternion delta = Quaternion::CreateFromVectors(start, end);
    _orientation = delta.Rotated(_previousOrientation);
    _orientation.ToMatrix4(&_rotationMatrix);
    
    [self render];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    ivec2 touchPoint = ivec2(location.x, location.y);
    
    vec3 start = [self mapToSphere:_fingerStart];
    vec3 end = [self mapToSphere:touchPoint];
    Quaternion delta = Quaternion::CreateFromVectors(start, end);
    _orientation = delta.Rotated(_previousOrientation);
    _orientation.ToMatrix4(&_rotationMatrix);
    
    [self render];
}

-(vec3)mapToSphere:(ivec2)touchpoint
{
    ivec2 centerPoint = ivec2(self.frame.size.width/2, self.frame.size.height/2);
    float radius = self.frame.size.width/3;
    float safeRadius = radius - 1;
    
    vec2 p = touchpoint - centerPoint;
    
    // Flip the Y axis because pixel coords increase towards the bottom.
    p.y = -p.y;
    
    if (p.Length() > safeRadius) {
        float theta = atan2(p.y, p.x);
        p.x = safeRadius * cos(theta);
        p.y = safeRadius * sin(theta);
    }
    
    float z = sqrt(radius * radius - p.LengthSquared());
    vec3 mapped = vec3(p.x, p.y, z);
    return mapped/radius;
}


@end
