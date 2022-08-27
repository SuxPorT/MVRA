Shader "Custom/Covolution"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}

        [Enum(Blur, 1, Laplace, 2, Sharp, 3, Emboss, 4)]
        _Kernel ("Kernel", Float) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                sampler2D _Texture;
                float4 _Texture_TexelSize;
                float _Kernel;
                float3x3 selectedKernel;
                
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
                
                VertexOutput vert(VertexInput input)
                {
                    VertexOutput output;

                    output.pos = UnityObjectToClipPos(input.vertex);
                    output.texCoord = input.texCoord;

                    return output;
                }
                
                float3x3 FilterChannel(int channel, sampler2D tex, float2 texCoord, float4 size)
                {
                    float3x3 matrixResult;

                    for (int y = -1; y < 2; y++)
                    {
                        for (int x = -1; x < 2; x++)
                        {
                            matrixResult[x + 1][y + 1] = tex2D(tex, texCoord + float2(x * size.x, y * size.y))[channel];
                        }
                    }

                    return matrixResult;
                }

                float Convolve(float3x3 kernel, float3x3 pixels)
                {
                    float result = 0.0;

                    for (int y = 0; y < 3; y++)
                    {
                        for (int x = 0; x < 3; x++)
                        {
                            result += kernel[2 - x][2 - y] * pixels[x][y];
                        }
                    }
                    
                    return result;
                }
                
                float4 frag (VertexOutput input) : SV_Target
                {
                    float3x3 blurKernel = 
                        float3x3 (
                            0.0, 0.2, 0.0, 
                            0.2, 0.2, 0.2,
                            0.0, 0.2, 0.0
                        );
                    
                    float3x3 laplaceKernel = 
                        float3x3 (
                            0.0,  1.0, 0.0,
                            1.0, -4.0, 1.0,
                            0.0,  1.0, 0.0
                        );
                    
                    float3x3 sharpKernel = 
                        float3x3 (
                             0.0, -1.0,  0.0,
                            -1.0,  5.0, -1.0,
                             0.0, -1.0,  0.0
                        );
                    
                    float3x3 embossKernel = 
                        float3x3 (
                            -2.0, -1.0, 0.0,
                            -1.0,  0.0, 1.0,
                             0.0,  1.0, 2.0
                        );

                    switch (_Kernel) {
                        case 1:
                            selectedKernel = blurKernel;
                            break;
                        case 2:
                            selectedKernel = laplaceKernel;
                            break;
                        case 3:
                            selectedKernel = sharpKernel;
                            break;
                        case 4:
                            selectedKernel = embossKernel;  
                            break;
                    }
                
                    float3x3 r = FilterChannel(0, _Texture, input.texCoord, _Texture_TexelSize);
                    float3x3 g = FilterChannel(1, _Texture, input.texCoord, _Texture_TexelSize);
                    float3x3 b = FilterChannel(2, _Texture, input.texCoord, _Texture_TexelSize);
                    
                    return float4(
                        Convolve(selectedKernel, r),
                        Convolve(selectedKernel, g),
                        Convolve(selectedKernel, b),
                        1.0
                    );
                }
            ENDCG
        }
    }
}
