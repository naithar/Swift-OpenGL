#if os(Linux) || os(OSX)
    import COpenGLOSX
#endif

#if os(iOS)
    import OpenGLES
#endif


public enum gl {
    
    //glGetError() // https://www.khronos.org/opengl/wiki/GLAPI/glGetError
    
    public struct Color {
        public var red: Double
        public var green: Double
        public var blue: Double
        public var alpha: Double
        
        public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
    }
    
    public struct Vertex {
        public var x: Double
        public var y: Double
        public var z: Double
        public var w: Double
        
        public init(x: Double, y: Double, z: Double = 0, w: Double = 1) {
            self.x = x
            self.y = y
            self.z = z
            self.w = w
        }
    }
    
    public struct BufferBitMask: OptionSet {
        
        public let rawValue: Int32
        
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        
        public static let color = BufferBitMask(rawValue: GL_COLOR_BUFFER_BIT)
        public static let stencil = BufferBitMask(rawValue: GL_STENCIL_BUFFER_BIT)
        public static let depth = BufferBitMask(rawValue: GL_DEPTH_BUFFER_BIT)
    }
    
    public static func viewport(x: Int, y: Int, width: Int, height: Int) {
        glViewport(GLint(x), GLint(y), GLsizei(width), GLsizei(height))
    }
    
    public static func clear(color: Color) {
        glClearColor(GLclampf(color.red), GLclampf(color.green), GLclampf(color.blue), GLclampf(color.alpha))
    }
    
    public static func clear(_ mask: BufferBitMask) {
        let mask = GLbitfield(mask.rawValue)
        glClear(mask)
    }
    
    public static func flush() {
        glFlush()
    }
    
    public static func color(_ color: gl.Color) {
        glColor4f(GLfloat(color.red), GLfloat(color.green), GLfloat(color.blue), GLfloat(color.alpha))
    }
    
    public static func vertex(_ vertex: gl.Vertex) {
        #if !os(iOS)
            glVertex4f(GLfloat(vertex.x), GLfloat(vertex.y), GLfloat(vertex.z), GLfloat(vertex.w))
        #endif
    }
    
    public enum MatrixMode {
        
        case modelView
        case projection
        case texture
        case color
        
        internal var raw: GLenum {
            switch self {
            case .modelView:
                return GLenum(GL_MODELVIEW)
            case .projection:
                return GLenum(GL_PROJECTION)
            case .texture:
                return GLenum(GL_TEXTURE)
            case .color:
                return GLenum(GL_COLOR)
            }
        }
    }
    
    public static func matrixMode(_ mode: MatrixMode) {
        glMatrixMode(mode.raw)
    }
    
    public static func loadIdentity() {
        glLoadIdentity()
    }
    
    public static func ortho(left: Double, right: Double, bottom: Double, top: Double, near: Double, far: Double) {
        #if os(iOS)
            glOrthof(Float(left), Float(right), Float(bottom), Float(top), Float(near), Float(far))
        #else
            glOrtho(left, right, bottom, top, near, far)
        #endif
    }
    
    public static func frustum(left: Double, right: Double, bottom: Double, top: Double, near: Double, far: Double) {
        #if os(iOS)
            glFrustumf(Float(left), Float(right), Float(bottom), Float(top), Float(near), Float(far))
        #else
            glFrustum(left, right, bottom, top, near, far)
        #endif
    }
    
    public static func perspective(angle: Double, aspect: Double, near: Double, far: Double) {
        let height = tan( angle / 360 * M_PI ) * near;
        let width = height * aspect;
        
        #if os(iOS)
            glFrustumf(Float(-width), Float(width), Float(-height), Float(height), Float(near), Float(far))
        #else
            glFrustum(-width, width, -height, height, near, far)
        #endif
    }
    
    public enum DrawMode {
        
        case triangles
        
        #if !os(iOS)
        case quads
        #endif
        
        internal var raw: GLenum {
            #if !os(iOS)
                switch self {
                case .triangles:
                    return GLenum(GL_TRIANGLES)
                case .quads:
                    return GLenum(GL_QUADS)
                }
            #else
                switch self {
                case .triangles:
                    return GLenum(GL_TRIANGLES)
                }
            #endif
        }
    }
    
//    public static func Drawer {
    
        //func vertex
        //func color
        //func index
        
//    }
    
    //newList
    //Certain commands are not compiled into the display list but are executed immediately, regardless of the display-list mode. These commands are glAreTexturesResident, glColorPointer, glDeleteLists, glDeleteTextures, glDisableClientState, glEdgeFlagPointer, glEnableClientState, glFeedbackBuffer, glFinish, glFlush, glGenLists, glGenTextures, glIndexPointer, glInterleavedArrays, glIsEnabled, glIsList, glIsTexture, glNormalPointer, glPopClientAttrib, glPixelStore, glPushClientAttrib, glReadPixels, glRenderMode, glSelectBuffer, glTexCoordPointer, glVertexPointer, and all of the glGet commands.
    

    
    //drawArray client state
    //draw?
    public static func begin(_ mode: DrawMode, draw: (Void) -> Void) { //throws
        //draw.color
        //draw.index
        //draw.vertex ??
        //
        //The commands are glVertex, glColor, glSecondaryColor, glIndex, glNormal, glFogCoord, glTexCoord, glMultiTexCoord, glVertexAttrib, glEvalCoord, glEvalPoint, glArrayElement, glMaterial, and glEdgeFlag.
        #if !os(iOS)
            glBegin(mode.raw)
            draw()
            glEnd()
        #endif
        //else 
        //stack
        //https://pandorawiki.org/Porting_to_GLES_from_GL
        
    }
    
}


//https://www.opengl.org/sdk/docs/man/
//print("Hello, world!")
/*
 glDepthMask(GLboolean(GL_FALSE))
 glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
 glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GLint(GL_MIRRORED_REPEAT))
 
 struct Texture {
 
 func parameters(for target: gl.Target) -> Parameter {
 return Parameter(target: target)
 }
 
 func bind(_ texture: Int, to: gl.Target) {
 
 }
 
 func generate(count: Int) -> [Int] {
 return []
 }
 }
 
 extension Texture {
 
 struct Parameter {
 
 private var target: gl.Target
 
 enum Name {
 
 case minFilter
 case magFilter
 }
 
 enum Value {
 case nearest
 case linear
 }
 
 init(target: gl.Target) {
 self.target = target
 }
 
 func set(_ value: Value, for name: Name) {
 
 }
 
 func set(_ value: [Value], for name: Name) {
 
 }
 
 func set(_ value: [Double], for name: Name) {
 
 }
 
 func set(_ value: Double, for name: Name) {
 
 }
 
 func get(_ name: Name) -> [Value] {
 return []
 }
 
 func get(_ name: Name) -> [Double] {
 return []
 }
 }
 }
 
 struct gl {
 
 enum Target {
 
 case texture1D
 case texture2D
 case texture3D
 case textureCubeMap
 //        GL_COLOR_TABLE, GL_POST_CONVOLUTION_COLOR_TABLE, GL_POST_COLOR_MATRIX_COLOR_TABLE, GL_PROXY_COLOR_TABLE, GL_PROXY_POST_CONVOLUTION_COLOR_TABLE, or GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE.
 }
 
 
 
 static var texture: Texture {
 return Texture()
 }
 
 static func begin(closure: (() -> Void)? = nil) {
 
 }
 
 static func end() {
 
 }
 
 
 
 static func error() throws {
 
 }
 
 }
 
 
 gl.texture.parameters(for: .texture1D).set(.nearest, for: .magFilter)
 
 let value: [Texture.Parameter.Value] = gl.texture.parameters(for: .texture1D).get(.magFilter)
 
 gl.begin()
 gl.end()
 
 gl.begin {
 gl.clear(mask: [.color, .buffer])
 gl.color()
 }*/
