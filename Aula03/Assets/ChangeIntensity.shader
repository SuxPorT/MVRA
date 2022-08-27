Shader "Custom/ChangeIntensity"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Intensity ("Intensity", Range(0.0, 10.0)) = 1.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
                #pragma vertex vert;
                #pragma fragment frag;

                uniform sampler2D _Texture;
                float _Intensity;

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

                float4 intensity(float4 input)
                {
                    float r = input[0] * _Intensity;
                    float g = input[1] * _Intensity;
                    float b = input[2] * _Intensity;

                    return float4(r, g, b, input[3]);
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

                    return intensity(color);
                }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
