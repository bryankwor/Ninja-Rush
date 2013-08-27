//
//  Shader.fsh
//  UntitledGame
//
//  Created by Bryan Worrell on 8/27/13.
//  Copyright (c) 2013 Bryan Worrell. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
