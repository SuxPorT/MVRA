Shader "Custom/ColorToBlackWhite"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
                #pragma vertex vert;
                #pragma fragment frag;

                uniform sampler2D _Texture;

                struct VertexInput
                {
                    float4 vertex : POSITION;
                    float4 texCoord : TEXCOORD0;
                };

                struct VertexOutput
                {
                    float4 pos : SV_POSITION;
                    float4 texCoord : TEXCOORD0;
                };

                float greyscale(float4 input)
                {
                    float r = input[0];
                    float g = (input[0] + input[1] + input[2]) / 3;
                    float b = (0.3 * r) + (0.59 * b) + (0.11 * input[2]);

                    return float4(r, g, b, input[3]);
                }

                VertexOutput vert(VertexInput input)
                {
                    VertexOutput output;
                    
                    output.pos = UnityObjectToClipPos(input.vertex);
                    output.texCoord = input.texCoord;

                    return output;
                };

                float4 frag(VertexOutput input) : COLOR
                {
                    float4 color = tex2D(_Texture, input.texCoord.xy);
                    
                    return greyscale(color);
                };
            ENDCG
        }
    }
    FallBack "Diffuse"
}
