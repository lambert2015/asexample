// ActionScript file

		/*
		 * 骨骼混合shader 
         *
		 * @date 11.13 2012
         * @author harry
		 * 
		 */
		protected function initShaders3():void
		{
			// vertex-blend
			var strVertexBlend:String = '';
			var intVaIndex:uint = 2;
			var intCountBones:uint = this.intMaxBoneBlend;
			
			if( mIsRenderMeshOnly || mIsUseSoftwareBlendVertex)
			{
				if( mIsHasTexture )
				{
					strVertexBlend = "m44 op, va0, vc0\n"+		// vertex * matrix3d
									 "mov v0, va1"				// move uv to v0
				}
				else
				{
					strVertexBlend = "m44 op, va0, vc0\n"+		// vertex * matrix3d
									 "mov v0, vc10\n"				// move uv to v0
				}
			}
			else
			{
				// clear the result register
				strVertexBlend += "mov vt7, vc9\n";// clear to zero
				
				//
				// 经过bind shape matrix后，顶点放到 vt1中, bindshape后的顶点
				//
				//
				strVertexBlend += "mov vt1, vc9\n";// clear to zero
				strVertexBlend += "m34 vt1.xyz, va0.xyzw, vc4\n";// mul bind shape matrix = v_origin * bind_shape_matrix
				
				//
				// 分别和对应的混合矩阵相乘,然后乘weight
				//
				//
				var strBoneIndex:String = "";
				while(intCountBones--)
				{
					switch(intVaIndex-2)
					{
						case 0:
							strVertexBlend += "mov vt0, vc[va7.x]\n";// boneIndex
							strBoneIndex = "va7.x";
							break;
						case 1:
							strVertexBlend += "mov vt0, vc[va7.y]\n";
							strBoneIndex = "va7.y";
							break;
						case 2:
							strVertexBlend += "mov vt0, vc[va7.z]\n";
							strBoneIndex = "va7.z";
							break;
						case 3:
							strVertexBlend += "mov vt0, vc[va7.w]\n";
							strBoneIndex = "va7.w";
							break;
						default:
							throw new Error('error!');
							break;
					}
					
					//
					// 混合矩阵调入vt0中，顶点在vt1中, 骨骼index在va7中
					//
					//
					strVertexBlend += getMultiplyBlendMatrixAssemble2(intVaIndex-2, strBoneIndex);// q * vector * weight
					intVaIndex++;
				}
				
				//
				// 最后的结果存储在vt7中
				//
				//
				//	
				strVertexBlend += 'm44 op, vt7, vc0\n';// the new calc x,y,z,1 (vt1 - Just inverse bind shape matrix)
				
				if( mIsHasTexture )
					strVertexBlend += "mov v0, va1\n";
				else
					strVertexBlend += "mov v0, vc10\n";
			}
			
			mVertexShaderAssembler = new AGALMiniAssembler()
			mVertexShaderAssembler.assemble(
											Context3DProgramType.VERTEX,
											strVertexBlend
											);
			
			// textured using UV coordinates
			mFragmentShaderAssembler = new AGALMiniAssembler();
			var strFragment:String = '';
			if( mIsHasTexture )
				strFragment =   "tex ft1, v0, fs0 <2d,repeat,nomip>\n" +
								"mov oc, ft1\n";
			else
				strFragment = "mov oc, v0\n";
				
			mFragmentShaderAssembler.assemble(
												Context3DProgramType.FRAGMENT,
												strFragment
											);
			
			// create program
			mShaderProgram = mContext3DPointer.createProgram();
			mShaderProgram.upload(mVertexShaderAssembler.agalcode,
									mFragmentShaderAssembler.agalcode);
		}

		private function getMultiplyBlendMatrixAssemble2(index:uint, strBoneIndex:String):String
		{
			var agalCode:String = '';
			
			// vt1 - 顶点
			// vt0 - 四元数
			
			// p*q'
			
			
			// w
			// w1 = - x * x2 - y * y2 - z * z2;
			agalCode += "mul vt3.x, vt1.x, vt0.x\n";// a
			agalCode += "mul vt4.y, vt1.y, vt0.y\n";// b
			agalCode += "mul vt5.z, vt1.z, vt0.z\n";// c
			
			agalCode += "add vt6.x, vt3.x, vt4.y\n";// a+b
			agalCode += "add vt3.x, vt6.x, vt5.z\n";// +c
			agalCode += "neg vt6.w, vt3.x\n";// *-1 w --- ok
			agalCode += "mul vt2.w, vt6.w, vc9.w\n";
			
			
			// x
			// x1 = w * x2 + y * z2 - z * y2;
			agalCode += "mul vt3.x, vt0.w, vt1.x\n";// a
			agalCode += "mul vt4.y, vt0.y, vt1.z\n";// b
			agalCode += "mul vt5.z, vt0.z, vt1.y\n";// c
			
			agalCode += "neg vt6.x, vt5.z\n";// *-1
			agalCode += "add vt5.x, vt3.x, vt4.y\n";// a+b
			
			agalCode += "add vt3.x, vt6.x, vt5.x\n";// +c
			agalCode += "mul vt2.x, vt3.x, vc9.w\n";
			
			
			
			// y
			// y1 = w * y2 - x * z2 + z * x2;
			agalCode += "mul vt3.x, vt0.w, vt1.y\n";// a
			agalCode += "mul vt4.y, vt0.x, vt1.z\n";// b
			agalCode += "mul vt5.z, vt0.z, vt1.x\n";// c
			
			agalCode += "neg vt6.x, vt4.y\n";// *-1
			agalCode += "add vt4.x, vt3.x, vt5.z\n";// a+b
			
			agalCode += "add vt3.y, vt4.x, vt6.x\n";// +c
			agalCode += "mul vt2.y, vt3.y, vc9.w\n";
			
			
			// z
			// z1 = w * z2 + x * y2 - y * x2;
			agalCode += "mul vt3.x, vt0.w, vt1.z\n";// a
			agalCode += "mul vt4.y, vt0.x, vt1.y\n";// b
			agalCode += "mul vt5.z, vt0.y, vt1.x\n";// c
			
			agalCode += "neg vt6.x, vt5.z\n";// *-1
			agalCode += "add vt5.x, vt3.x, vt4.y\n";// a+b
			
			agalCode += "add vt3.z, vt6.x, vt5.x\n";// +c
			agalCode += "mul vt2.z, vt3.z, vc9.w\n";
			
			// --------------------------------------------------------------------------------------------------
			// p* q'
			
			
			
			// --------------------------------------------------------------------------------------------------
			// vt2 * vt0
			// vt2 - 新计算出来的四元数
			// x - vt0, x1 - vt2
			// 最后计算的顶点位置: vt6
			
			// posx
			// target.x = -w1 * x + x1 * w - y1 * z + z1 * y;
			agalCode += "mul vt3.x, vt2.w, vt0.x\n";// a
			agalCode += "mul vt4.x, vt2.y, vt0.z\n";// c
			agalCode += "add vt5.x, vt3.x, vt4.x\n";
			agalCode += "neg vt3.x, vt5.x\n";// a+c
			
			agalCode += "mul vt4.x, vt2.x, vt0.w\n";// b
			agalCode += "add vt5.x, vt3.x, vt4.x\n";// +b
			
			agalCode += "mul vt4.x, vt2.z, vt0.y\n";// d
			agalCode += "add vt3.x, vt4.x, vt5.x\n";// +d
			
			agalCode += "mul vt6.x, vt3.x, vc9.w\n";
			
			// posy
			// target.y = -w1 * y + x1 * z + y1 * w - z1 * x;
			agalCode += "mul vt3.x, vt2.w, vt0.y\n";// a
			agalCode += "mul vt4.x, vt2.z, vt0.x\n";// d
			agalCode += "add vt5.x, vt3.x, vt4.x\n";
			agalCode += "neg vt3.x, vt5.x\n";// a+d
			
			agalCode += "mul vt4.x, vt2.x, vt0.z\n";// b
			agalCode += "add vt5.x, vt3.x, vt4.x\n";// +b
			
			agalCode += "mul vt3.x, vt2.y, vt0.w\n";// c
			agalCode += "add vt4.y, vt3.x, vt5.x\n";// +c
			
			agalCode += "mul vt6.y, vt4.y, vc9.w\n";
			
			// posz
			// target.z = -w1 * z - x1 * y + y1 * x + z1 * w;
			agalCode += "mul vt3.x, vt2.w, vt0.z\n";// a
			agalCode += "mul vt4.x, vt2.x, vt0.y\n";// b
			agalCode += "add vt5.x, vt3.x, vt4.x\n";// a+b
			agalCode += "neg vt3.x, vt5.x\n";// a+c
			
			agalCode += "mul vt4.x, vt2.y, vt0.x\n";// c
			agalCode += "add vt5.x, vt3.x, vt4.x\n";// +c
			
			agalCode += "mul vt4.x, vt2.z, vt0.w\n";// d
			agalCode += "add vt3.z, vt4.x, vt5.x\n";// +d
			
			agalCode += "mul vt6.z, vt3.z, vc9.w\n";
			
			
			
			// ---------------------------------------------------------------------------
			// add the translation values(x,y,z)
			
			switch(index)
			{
				case 0:
					agalCode += "mov vt5, vc[va5.x]\n";// translation index
					break;
				case 1:
					agalCode += "mov vt5, vc[va5.y]\n";// translation index
					break;
				case 2:
					agalCode += "mov vt5, vc[va5.z]\n";// translation index
					break;
				case 3:
					agalCode += "mov vt5, vc[va5.w]\n";// translation index
					break;
			}
			
			
			agalCode += "mov vt3, vt6\n";
			agalCode += "add vt6.xyz, vt5.xyz, vt3.xyz\n";// add translate
			// ---------------------------------------------------------------------------
			
			
			
			// last pos = vt1
			// * weight
			switch(index)
			{
				case 0:
					agalCode += "mul vt4.xyz, vt6.xyz, va6.xxx\n";
					break;
				case 1:
					agalCode += "mul vt4.xyz, vt6.xyz, va6.yyy\n";
					break;
				case 2:
					agalCode += "mul vt4.xyz, vt6.xyz, va6.zzz\n";
					break;
				case 3:
					agalCode += "mul vt4.xyz, vt6.xyz, va6.www\n";
					break;
				case 4:
					throw new Error('error!');
					break;
			}
			
			// add
			agalCode += "mov vt3, vt7\n";
			agalCode += "add vt7.xyz, vt4.xyz, vt3.xyz\n"// to the last counter register
			
			return agalCode;
		}