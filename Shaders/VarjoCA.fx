// MIT License
//
// Varjo Chromatic Aberration ("RedShift Fix") Correction Shader 
//
// Copyright(c) 2023 Bernhard Berger
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this softwareand associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and /or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright noticeand this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#include "ReShade.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// UI Elements
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include "ReShadeUI.fxh"

uniform float offsetRed <
    ui_category = "Varjo Redshift Fix";
    ui_type = "slider";
    ui_label = "Red Offset";
    ui_tooltip = "Offset for the red color channel (use the same values as determined in RedShiftTester and OpenXR Toolkit)";
    ui_min = -0.20; ui_max = 0.2 ;ui_step = 0.001;
 > = 0.085;

uniform float offsetBlue <
    ui_category = "Varjo Redshift Fix";
    ui_type = "slider";
    ui_label = "Blue Offset";
    ui_tooltip = "Offset for the blue color channel (use the same values as determined in RedShiftTester and OpenXR Toolkit)";
    ui_min = -0.20; ui_max = 0.20;ui_step = 0.001;
 > = -0.115;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Correction Shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

texture2D texColorBuffer : COLOR;
texture2D texTarget{};

sampler2D sourceSampler
{
	Texture = texColorBuffer;
};

float4 chromaticAberrationCorrectionPS(float4 position : SV_POSITION, float2 texcoord : TEXCOORD0) : SV_Target {
    float3 color;
    float2 correctionOrigin = float2(0.1565, 0.42); // Correction origin for left eye, 
													// hardcoded for Varjo Aero, Varjo VR-3 and XR-3 (only Stereo Mode supported)

        float redOffset = offsetRed/100 + 1.000;
	float blueOffset = offsetBlue/100 + 1.000;
	float greenOffset = 1;
	
	if (texcoord.x < 0.5) {
		// Add correction for right eye
		const float2 uvr = ((texcoord - correctionOrigin) * redOffset) + correctionOrigin;
		color.r = tex2D(sourceSampler, uvr).r;

		const float2 uvg = ((texcoord - correctionOrigin) * greenOffset) + correctionOrigin;
		color.g = tex2D(sourceSampler, texcoord).g;

		const float2 uvb = ((texcoord - correctionOrigin) * blueOffset) + correctionOrigin;
		color.b = tex2D(sourceSampler, uvb).b;
	} else {
		// Add correction for right eye
		correctionOrigin.x = 1 - correctionOrigin.x;
		const float2 uvr = ((texcoord - correctionOrigin) * redOffset) + correctionOrigin;
		color.r = tex2D(sourceSampler, uvr).r;

		const float2 uvg = ((texcoord - correctionOrigin) * greenOffset) + correctionOrigin;
		color.g = tex2D(sourceSampler, texcoord).g;

		const float2 uvb = ((texcoord - correctionOrigin) * blueOffset) + correctionOrigin;
		color.b = tex2D(sourceSampler, uvb).b;
	}

    return float4(color, 1.0);
}

technique ZZZ_VarjoRedshiftFix
{
    pass ChromaticAberration
    {
        PixelShader = chromaticAberrationCorrectionPS;
		VertexShader = PostProcessVS;
    }
}
