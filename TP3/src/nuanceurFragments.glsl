#version 410

// Définition des paramètres des sources de lumière
layout (std140) uniform LightSourceParameters
{
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    vec4 position[3];      // dans le repère du monde
    float constantAttenuation;
    float linearAttenuation;
    float quadraticAttenuation;
} LightSource;

// Définition des paramètres des matériaux
layout (std140) uniform MaterialParameters
{
    vec4 emission;
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
} FrontMaterial;

// Définition des paramètres globaux du modèle de lumière
layout (std140) uniform LightModelParameters
{
    vec4 ambient;       // couleur ambiante
    bool localViewer;   // observateur local ou à l'infini?
    bool twoSide;       // éclairage sur les deux côtés ou un seul?
} LightModel;

layout (std140) uniform varsUnif
{
    // partie 1: illumination
    int typeIllumination;     // 0:Gouraud, 1:Phong
    bool utiliseBlinn;        // indique si on veut utiliser modèle spéculaire de Blinn ou Phong
    bool afficheNormales;     // indique si on utilise les normales comme couleurs (utile pour le débogage)
    // partie 2: texture
    int numTexCoul;           // numéro de la texture de couleurs appliquée
    int numTexNorm;           // numéro de la texture de normales appliquée
    bool utiliseCouleur;      // doit-on utiliser la couleur de base de l'objet en plus de celle de la texture?
    int afficheTexelFonce;    // un texel foncé doit-il être affiché 0:normalement, 1:mi-coloré, 2:transparent?
};

uniform sampler2D laTextureCoul;
uniform sampler2D laTextureNorm;

/////////////////////////////////////////////////////////////////

in Attribs {
    vec4 couleur;
    vec3 N;
    vec3 L[3];
    vec3 O;
    vec4 TexCoord;
} AttribsIn;

out vec4 FragColor;

vec4 calculerReflexion( in vec3 L, in vec3 N, in vec3 O )
{
    vec4 grisUniforme = vec4(0.7,0.7,0.7,1.0);
    return( grisUniforme );
}

vec3 modifierNormale( vec3 N )
{
    vec4 couleur = texture( laTextureNorm, AttribsIn.TexCoord.st);
    vec3 dN = normalize( ( couleur.rgb  - 0.5 ) * 2.0 );
    return normalize(N + dN);
}

void main( void )
{
    vec3 N = normalize(AttribsIn.N);
    if ( numTexNorm != 0 ) N = modifierNormale( N );

    // assigner la couleur finale
    if (typeIllumination == 0) {
        FragColor = clamp( AttribsIn.couleur, 0.0, 1.0 );
    } else {
        vec4 couleur = (FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient) +
        LightSource.ambient * FrontMaterial.ambient;
        FragColor = 0.01*AttribsIn.couleur + vec4(0.7,0.7,0.7,1.0);
        for(int i = 0; i<3;i++)
        {
            vec3 L = normalize( AttribsIn.L[i] );
            float NdotL = dot( N, L );
            if ( NdotL > 0.0 )
            {
                couleur += FrontMaterial.diffuse * LightSource.diffuse * NdotL;

                vec3 O = normalize( AttribsIn.O );
                float NdotHV;

                // composante spéculaire
                if (utiliseBlinn){
                    vec3 halfV = normalize(vec3(O + L));
                    NdotHV = max( dot(N,halfV), 0.0 );
                } else {
                    NdotHV = max(0.0, dot(reflect(-L, N), O));
                }

                couleur += FrontMaterial.specular * LightSource.specular * pow( NdotHV, FrontMaterial.shininess );
            }

            FragColor = clamp( couleur, 0.0, 1.0 );
        }
    }
    // texture de couleurs utilisée: aucune, dé, échiquier, mur, métal, mosaique
    
    vec3 grey = vec3(0.5,0.5,0.5);
    vec4 texColor = texture(laTextureCoul, AttribsIn.TexCoord.st);

    if (numTexCoul != 0) {
        if(afficheTexelFonce == 1)
        {
            if (all(lessThan(texColor.rgb, grey)))
            {
                    texColor.rgb = grey;
            }
        }
        if(afficheTexelFonce == 2 ){
            if (all(lessThan(texColor.rgb, grey)))
            {
                    discard;
            }
        }

        FragColor *= texColor;
    } 

    if ( afficheNormales ) FragColor = vec4(N,1.0);
}
