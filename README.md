<H1>Character Reognition</H1>
<p>This is a matlab app for recognition of characters in a image containing a word. This project was done as a B.Tech Project with Ayush Mukund Gupta and Abhinav Rishikesh.</p>
<H3>Preprocessing</H3>
-Abhinav Rishikesh <br>
<p>The input image is taken and is converted to binary form using otsu method.</p>
<H3>Segmentation</H3>
-Ayush Mukund Gupta <br>
<p>The binarized image is segmented into individual characters using horizontal and vertical projections of the image.</p>
<H3>Classification</H3>
-Ashutosh Pandey <br>
<p>Classification is done using Neural Network. The Neural Network is a single hidden layer network with 600 hidden layer nodes. </p>
<p>The input the Neural network is a matrix in which each row has 625 elements corresponding to the pixels of 25 x 25 image. </p>
<p>The output of the Neural network is matrix in which each row has 62 elements out of which only one element is 1 others are 0 denoting the chosen class [A-Z a-z 0-9].</p>
<p>The Code used for traning of the neural network is also provided in the Traning folder. The dataset used for training was a manually chosen subset of Erik's  huge dataset.</p>
<p>https://erikbern.com/2016/01/21/analyzing-50k-fonts-using-deep-neural-networks.html</p>
<p>The neural networks hidden layer size, regularization parameter and optimizing function can be changed with ease but changing the number of hidden layers would take some understanding of code.</p>
<p>I coded the neural network while i was doing the coursera machine learning course by Andrew Ng. And some of the function are used from the course like 'fmincg.m' and 'displaydata.m'. The function fmin_adam is also from matlab file exchange.</p>
