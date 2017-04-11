Shader "Unlit/GrassShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _WaveAuto         ("Wave Auto",    Range(0, 1))  = 1
        _WavePower1       ("Wave Power 1",       float)  = 1
        _WavePower2       ("Wave Power 2",       float)  = 0.5
        _WaveDirection    ("Wave Direction",     Vector) = (1, 0, 0, 1)
        _WaveSpeed        ("Wave Speed",         float)  = 1
        _WaveEllapsedTime ("Wave Ellapsed Time", float)  = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        // モデルに合わせて Culling On / Off を切り替えます。

        LOD 100
        CULL Off

        Pass
        {
            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile_fog
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv     : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4    _MainTex_ST;
            
            float  _WaveAuto;
            float  _WavePower1;
            float  _WavePower2;
            float3 _WaveDirection;
            float  _WaveSpeed;
            float  _WaveEllapsedTime;

            float random(float2 coord, int Seed)
            {
                return frac(sin(dot(coord.xy, float2(12.9898, 78.233)) + Seed) * 43758.5453);
            }

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = v.vertex;

                // factor1 は全体的に曲げる。
                // factor2 は時間経過で上の方だけ曲げる。

                float randomValue  = random(float2(v.vertex.x, 0), 0);
                float ellapsedTime = _WaveAuto == 1 ? _Time.y : _WaveEllapsedTime;

                float factor1 = _WavePower1 * v.vertex.y;
                float factor2 = _WavePower2 * sin(ellapsedTime * _WaveSpeed) * (v.vertex.y / 2);

                float3 direction = length(_WaveDirection) > 1 ? normalize(_WaveDirection) : _WaveDirection;

                o.vertex.x += (direction.x * factor1) + (direction.x * factor2 * factor2);
                o.vertex.z += (direction.z * factor1) + (direction.z * factor2 * factor2);

                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv     = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                return color;
            }

            ENDCG
        }
    }
}