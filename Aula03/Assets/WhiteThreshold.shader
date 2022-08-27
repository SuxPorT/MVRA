Shader "Custom/WhiteThreshold"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Threshold ("Threshold", Range(0.0, 1.0)) = 0.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
                #pragma vertex vert;
                #pragma fragment frag;

                uniform sampler2D _Texture;
                float _Threshold;

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

                float4 threshold(float4 input)
                {
                    float r = input[0], 
                          g = input[1],
                          b = input[2];

                    if (r >= _Threshold || g >= _Threshold || b >= _Threshold)
                    {
                        return float4(1, 1, 1, input[3]);
                    }
                    else
                    {
                        return float4(0, 0, 0, input[3]);
                    }
                }

                VertexOutput vert(VertexInput input)
                {
                    VertexOutput output;

                    output.pos = UnityObjectToClipPos(input.vertex);
                    output.texCoord = input.texCoord;

                    return output;
                }

                float4 frag(VertexOutput input) : COLOR
                {
                    float4 color = tex2D(_Texture, input.texCoord.xy);
                    
                    return threshold(color);
                }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
