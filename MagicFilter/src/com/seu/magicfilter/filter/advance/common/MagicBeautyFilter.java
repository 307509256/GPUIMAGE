package com.seu.magicfilter.filter.advance.common;

import android.R.integer;
import android.content.Context;
import android.opengl.GLES20;

import com.seu.magicfilter.R;
import com.seu.magicfilter.filter.base.gpuimage.GPUImageFilter;
import com.seu.magicfilter.filter.helper.MagicFilterParam;
import com.seu.magicfilter.utils.OpenGLUtils;

public class MagicBeautyFilter extends GPUImageFilter {
	private int mSingleStepOffsetLocation;
	private int mParamsLocation;
	private int mDisFactorLocation;

    public MagicBeautyFilter(Context context) {
    	super(NO_FILTER_VERTEX_SHADER,
    			( MagicFilterParam.mGPUPower == 1 ? 
    					OpenGLUtils.readShaderFromRawResource(context, R.raw.beautify_fragment) : //bilateralfilter.glsl
    					OpenGLUtils.readShaderFromRawResource(context, R.raw.beautify_fragment)));
    	System.out.println("gongjiaj1   MagicFilterParam.mGPUPower="+ MagicFilterParam.mGPUPower);
    }
   
    protected void onInit() {
        super.onInit();
        
        mSingleStepOffsetLocation = GLES20.glGetUniformLocation(getProgram(), "singleStepOffset");
        mParamsLocation = GLES20.glGetUniformLocation(getProgram(), "params");
        System.out.println("gongjiaj2 mSingleStepOffsetLocation = "+ mSingleStepOffsetLocation);
        System.out.println("gongjiaj2 mParamsLocation = "+ mParamsLocation);
        setBeautyLevel(2);
    }
    
    protected void onDestroy() {
        super.onDestroy();
    }
    
    private void setTexelSize(final float w, final float h) {
    	System.out.println("gongjiaj31 setTexelSize  w="+ w +", h="+h);
		setFloatVec2(mSingleStepOffsetLocation, new float[] {2.0f / w, 2.0f / h});
		mSingleStepOffsetLocation = GLES20.glGetUniformLocation(getProgram(), "singleStepOffset");
        mParamsLocation = GLES20.glGetUniformLocation(getProgram(), "params");
        System.out.println("gongjiaj32 mSingleStepOffsetLocation = "+ mSingleStepOffsetLocation);
        System.out.println("gongjiaj32 mParamsLocation = "+ mParamsLocation);
	}
	
	@Override
    public void onOutputSizeChanged(final int width, final int height) {
		System.out.println("gongjiaj4 width = "+ width + ", height=" +height);
        super.onOutputSizeChanged(width, height);
        setTexelSize(width, height);
    }

	public void setBeautyLevel(int level){
		System.out.println("gongjiaj5 level "+ level);
		switch (level) {
		case 1:
			setFloatVec4(mParamsLocation, new float[] {1.0f, 1.0f, 0.15f, 0.15f});
			break;
		case 2:
			setFloatVec4(mParamsLocation, new float[] {0.8f, 0.9f, 0.2f, 0.2f});
			break;
		case 3:
			setFloatVec4(mParamsLocation, new float[] {0.6f, 0.8f, 0.25f, 0.25f});//rgba
			break;
		case 4:
			setFloatVec4(mParamsLocation, new float[] {0.4f, 0.7f, 0.38f, 0.3f});
			break;
		case 5:
			setFloatVec4(mParamsLocation, new float[] {0.33f, 0.63f, 0.4f, 0.35f});
			break;
		default:
			break;
		}
	}
}
