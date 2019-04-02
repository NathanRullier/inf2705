#version 410

uniform sampler2D leLutin;
uniform int texnumero;

in Attribs {
    vec2 texCoord;
    vec4 couleur;
} AttribsIn;

out vec4 FragColor;

void main( void )
{
    // Mettre un test bidon afin que l'optimisation du compilateur n'élimine l'attribut "couleur".
    // Vous ENLEVEREZ cet énoncé inutile!
    if (texnumero == 0)
    {
        FragColor = AttribsIn.couleur;
    }
    else if ( texnumero == 1 )
    {
        vec4 texel = texture( leLutin, AttribsIn.texCoord );
        if (texel.a < 0.1) discard;

        FragColor = mix( AttribsIn.couleur, texel, 0.6 );
    }
    else if ( texnumero == 2 )
    {
        vec4 texel = texture( leLutin, AttribsIn.texCoord );
        if (texel.a < 0.1) discard;

        FragColor = mix( AttribsIn.couleur, texel, 0.6 );
    }
    else if ( texnumero == 3 )
    {
        vec4 texel = texture( leLutin, AttribsIn.texCoord );
        if (texel.a < 0.1) discard;

        FragColor = mix( AttribsIn.couleur, texel, 0.6 );
    }
}
