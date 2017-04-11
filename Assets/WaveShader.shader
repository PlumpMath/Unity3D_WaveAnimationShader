Shader "Unlit/WaveShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _WavePower        ("Wave Power",         float) = 0.05
        _WaveDirection    ("Wave Direction",     Vector) = (1, 0, 0, 1)
        _WaveEllapsedTime ("Wave Ellapsed Time", float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        LOD 100

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
            
            float  _WavePower;
            float3 _WaveDirection;
            float  _WaveEllapsedTime;

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = v.vertex;

                float  factor    = _WavePower * sin(_WaveEllapsedTime) * v.vertex.y;
                float3 direction = _WaveDirection == 0 ? _WaveDirection : normalize(_WaveDirection);

                o.vertex.x += direction.x * factor;
                o.vertex.z += direction.z * factor;

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