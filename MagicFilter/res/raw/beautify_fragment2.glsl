precision highp float;

uniform sampler2D inputImageTexture;
uniform vec2 singleStepOffset; 
uniform highp vec4 params; 

varying highp vec2 textureCoordinate;

const highp vec3 W = vec3(0.299,0.587,0.114);
const mat3 saturateMatrix = mat3(
		1.1102,-0.0598,-0.061,
		-0.0774,1.0826,-0.1186,
		-0.0228,-0.0228,1.1772);
		
float hardlight(float color)
{
	if(color <= 0.5)
	{
		color = color * color * 2.0;
	}
	else
	{
		color = 1.0 - ((1.0 - color)*(1.0 - color) * 2.0);
	}
	return color;
}

const mediump mat3 rgb2yuv = mat3(0.299,-0.147,0.615,0.587,-0.289,-0.515,0.114,0.436,-0.1);

void main(){
	float distanceNormalizationFactor = 4.0;
	float skinwhiteBeta;
	vec2 blurCoordinates[12];
	vec2 blurStep;   	   
	float gaussianWeightTotal;
	vec4 sum;
	vec4 sampleColor;
	float distanceFromCentralColor;
	float gaussianWeight;
	vec4 centralColor = texture2D(inputImageTexture, textureCoordinate);
	bool skinflag;
	  
	float r = centralColor.r;
    float g = centralColor.g;
    float b = centralColor.b;
    vec3 yuv = rgb2yuv * centralColor.rgb;

    if(yuv.g<-0.225 || yuv.g>0.0 || yuv.b<0.022 || yuv.b>0.206){  
    	skinflag = false;
    }else{
    	skinflag = true;
    }

    if(skinflag){
		blurCoordinates[0] = textureCoordinate.xy + singleStepOffset * vec2(-4.,-4.);
	    blurCoordinates[1] = textureCoordinate.xy + singleStepOffset * vec2(4.,-4.);
	    blurCoordinates[2] = textureCoordinate.xy + singleStepOffset * vec2(-4.,4.);
	    blurCoordinates[3] = textureCoordinate.xy + singleStepOffset * vec2(4.,4.);	          	        
	         	        
	    blurCoordinates[4] = textureCoordinate.xy + singleStepOffset * vec2(-2.,-2.);
	    blurCoordinates[5] = textureCoordinate.xy + singleStepOffset * vec2(2.,-2.);
	    blurCoordinates[6] = textureCoordinate.xy + singleStepOffset * vec2(2.,2.);
	    blurCoordinates[7] = textureCoordinate.xy + singleStepOffset * vec2(-2.,2.); 	           	                         
	    
	    blurCoordinates[8] = textureCoordinate.xy + singleStepOffset * vec2(0.,-4.);
	    blurCoordinates[9] = textureCoordinate.xy + singleStepOffset * vec2(4.,0.);
	    blurCoordinates[10] = textureCoordinate.xy + singleStepOffset * vec2(-4.,0);
	    blurCoordinates[11] = textureCoordinate.xy + singleStepOffset * vec2(0.,4.);	 
	    	 
		gaussianWeightTotal = 0.5;
		sum = centralColor * 0.5;
		 
		sampleColor = texture2D(inputImageTexture, blurCoordinates[0]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.1 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[1]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.1 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[2]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.1 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[3]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.05 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
	
		sampleColor = texture2D(inputImageTexture, blurCoordinates[4]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.25 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[5]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.25 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[6]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.25 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[7]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.25 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
	
		sampleColor = texture2D(inputImageTexture, blurCoordinates[8]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[9]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[10]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		sampleColor = texture2D(inputImageTexture, blurCoordinates[11]);
		distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
		gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
		gaussianWeightTotal += gaussianWeight;
		sum += sampleColor * gaussianWeight;
		
		vec4 bilateral = sum / gaussianWeightTotal;
	    gl_FragColor = (0.4) * (centralColor - bilateral) + bilateral; //smooth degree
    }
	else {
	    gl_FragColor = centralColor;
	}
}