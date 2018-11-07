% In our exercise, we will work with 3 matrices:
% MEG_data 125 x 306, 125 trials x 306 sensors
% stim_ID 125 rows, stimulus observed in each trial (image ordered 1-25)
% cat_ID 125 rows, stimulus category ('beach', 'building', 'forest', 'highway', 'mountain' ordered 1:5)
% MEG_data(i,:) MEG response in all 306 sensors to image stim_ID(i) with cat_ID(i)
% MEG_data(i,j) MEG response of jth sensor to ith stimulus

% we will try to apply the k-means algorithm to cluster our data using only channels 200, 233
% kmeans(X,k) partitions points in the n x p matrix X into k clusters,
% minimizing the sum over all clusters of within-cluster sums of point-to-centroid distances
% rows of X correspond to points, columns to variables
% kmeans returns nx1 vector IDX containing cluster indices of point
% by default using squared Euclidean distances

load('kmeans_results.mat')
load('MEG_decoding_data_final.mat')

X = MEG_data(:,[200,233])
IDX = kmeans(X, 5)

% MATLAB lets us define our x and y coordinates using a relational statement
% Goal: plot entries of vector B that have a 2 in their corresponding index A against entries of B with 1 in corresponding index A

x = B(A==1,1); y = B(A==2,1);
plot(x,y,'s')


% Plot different clusters by selecting groups with same IDX,
% plotting x as column 1 and y as column 2, and coloring those groups by IDX

figure
x1 = X(IDX == 1, 1); y1 = X(IDX == 1, 2); 
plot(x1,y1,'b.','MarkerSize',16);
xlabel('Sensor 200 (T x 10^-12)'); ylabel('Sensor 233 (T x 10^-12)');
set(gca,'Xticklabel', {'-8','-6','-4','-2','0','2','4'});
set(gca,'Yticklabel', {'-6','-4','-2','-0','2','4','6'});
hold on

x2 = X(IDX == 2, 1); y2 = X(IDX ==2, 2); 
plot(x2,y2,'r.','MarkerSize',16);
x3 = X(IDX == 3, 1); y3 = X(IDX == 3, 2); 
plot(x3,y3,'g.','MarkerSize',16);
x4 = X(IDX == 4, 1); y4 = X(IDX == 4, 2); 
plot(x4,y4,'k.','MarkerSize',16);
x5 = X(IDX == 5, 1); y5 = X(IDX == 5, 2); 
plot(x5,y5,'m.','MarkerSize',16);

% SVM (support vector machine) is a supervised machine learning algorithm
% All of the channels will be used
% Data has been split into training and test sets
% SVM is a binary classifier, so it can only separate two classes at a time
% Only the 'beach' and 'forest' classes are provided

% fitcsvm trains or crossvalidates a SVM model for binary classification on a low/moderate-dimensional predictor data set
% supports mapping using kernel functions, sequential minimum optimization (SMO), iterative single data algorithm (ISDA) or soft-margin minimization for objective-function minimization
% to train on a high-dimensional data set, use a linear SVM model with fitclinear
% for multiclass learning with combined binary SVM, use error-correcting output codes (ECOC). See fitcecoc.
% to train an SVM regression model, see fitrsvm for low/moderate- and fitrlinear for high-dimensional data sets
% syntax:  model = fitcsvm(table,class_labels) returns an SVM classifier trained using the predictors in table and the class labels in class_labels
% SVMStruct contains the parameters that describe the hyperplane separating our classes

SVMStruct = fitcsvm(train_data,train_cat_labels,'Standardize','on');
pred = predict(SVMStruct,test_data);

pred'
test_cat_labels

A = sum(pred' == test_cat_labels)
accuracy = A/length(pred)

