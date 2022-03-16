Shader "Unlit/ScaleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 scale : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float sdBox(float2 p,float2 s)
            {
                float2 q=abs(p)-s;
                return length(max(q,.0))+min(max(q.x,q.y),.0);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float scaleX = length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x));
                float scaleZ = length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z));
                o.scale = float2(scaleX,scaleZ);
                o.uv = v.uv.xy * o.scale;
                return o;
            }

            float map(float2 p)
            {
                float sdf2d=sdBox(p,float2(.5,.5));
                return sdf2d;
            }

            float4 frag (v2f i) : SV_Target
            {
                i.uv=(i.uv*2.-i.scale)/min(i.scale.x,i.scale.y);
                float d = map(i.uv);
                float3 col=fixed3(d,d,d);
                float4 lastCol = float4(col,1);
                return lastCol;
            }
            ENDCG
        }
    }
}
