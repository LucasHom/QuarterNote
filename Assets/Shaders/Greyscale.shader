Shader "Custom/Greyscale"
{
    Properties
    {
        // we have removed support for texture tiling/offset,
        // so make them not be displayed in material inspector
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Blend ("Blend Amount", Range(0,1)) = 1.0
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM
            // use "vert" function as the vertex shader
            #pragma vertex vert
            // use "frag" function as the pixel (fragment) shader
            #pragma fragment frag
            #include "UnityCG.cginc"

            // vertex shader inputs
            struct appdata
            {
                float4 vertex : POSITION; // vertex position
                float2 uv : TEXCOORD0; // texture coordinate
            };

            // vertex shader outputs ("vertex to fragment")
            struct v2f
            {
                float2 uv : TEXCOORD0; // texture coordinate
                float4 vertex : SV_POSITION; // clip space position
            };

            // vertex shader
            v2f vert (appdata v)
            {
                v2f o;
                // transform position to clip space
                // (multiply with model*view*projection matrix)
                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
                // just pass the texture coordinate
                o.uv = v.uv;
                return o;
            }
            
            // texture we will sample
            sampler2D _MainTex;
            half _Blend;

            // pixel shader; returns low precision ("fixed4" type)
            // color ("SV_Target" semantic)
            fixed4 frag (v2f i) : SV_Target
            {
                // sample texture and return it
                // fixed4 col = tex2D(_MainTex, i.uv);
                // half gray = dot(col.rgb, half3(0.299, 0.587, 0.114));
                // return half4(gray, gray, gray, col.a);
                fixed4 col = tex2D(_MainTex, i.uv);
                half gray = dot(col.rgb, half3(0.299, 0.587, 0.114));
                half3 grayscale = half3(gray, gray, gray);
                col.rgb = lerp(col.rgb, grayscale, _Blend);
                return col;
            }
            ENDHLSL
        }
    }
}