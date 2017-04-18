% This make.m is for MATLAB and OCTAVE under Windows, Mac, and Unix

try
	Type = ver;
	% This part is for OCTAVE
	if(strcmp(Type(1).Name, 'Octave') == 1)
		mex libsvmread.c
		mex libsvmwrite.c
		mex svmtrain.c ../svm.cpp svm_model_matlab.c
		mex svmpredict.c ../svm.cpp svm_model_matlab.c
	% This part is for MATLAB
	% Add -largeArrayDims on 64-bit machines of MATLAB
	else
		mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims libsvmread.c
		mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims libsvmwrite.c
		mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims svmtrain.c ../svm.cpp svm_model_matlab.c
		mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims svmpredict.c ../svm.cpp svm_model_matlab.c

% 		mex CFLAGS="\$CFLAGS -std=c99" libsvmread.c
% 		mex CFLAGS="\$CFLAGS -std=c99" libsvmwrite.c
% 		mex CFLAGS="\$CFLAGS -std=c99" svmtrain.c ../svm.cpp svm_model_matlab.c
% 		mex CFLAGS="\$CFLAGS -std=c99" svmpredict.c ../svm.cpp svm_model_matlab.c

	end
    
mex -largeArrayDims -O -c svm.cppmex -largeArrayDims -O -c svm_model_matlab.cmex -largeArrayDims -O svmtrain.c svm.obj svm_model_matlab.omex -largeArrayDims -O svmpredict.c svm.obj svm_model_matlab.omex -largeArrayDims -O libsvmread.cmex -largeArrayDims -O libsvmwrite.c


catch
	fprintf('If make.m failes, please check README about detailed instructions.\n');
end
