clear;clc;
[label_vector, instance_matrix] = libsvmread('heart_scale');
train = instance_matrix;
train_label = label_vector;
test = train;
test_label = train_label;
model = svmtrain(train_label,train,'-c 2 -g 0.01');
[predict_label,accuracy,~] = svmpredict(test_label,test,model);