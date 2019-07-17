# targeted-dropout
An inquiry into the nature of pruning and targeted dropout

### Motivation
Neural networks are huge. Large networks allow for more fine tuning and greater precision. Now that the ML field is no longer bound by the constraints of computational power, they will probably continue to get bigger. Upon further inspection, a significant number of parameters in neural networks do not do much of anything at all. Examining the graph below, we see that only a small minority of the network is doing the heavy lifting.

![graph, by for.ai](https://for.ai/img/targeted-dropout/comtx1.png)

The insignificant parameters function as place holders during training, but their importance during prediction is not well understood, and are questionable at best. To explore this, I have conducted an experiment by which I trained a wide, vanilla, ReLU-activated network on the fashion-mnist dataset, removed the unimportant weights, and tested the accuracy. But how do we know which unimportant weights are suited for removal? Well there are two approaches. 

![targeting, by for.ai](https://for.ai/img/targeted-dropout/tdsteps.png)

Out of the two approaches, weighted dropout has shown dramatic results by reducing the network by 99.1% while seeing a mere 4% decrease in accuracy<sup><a href="https://openreview.net/pdf?id=HkghWScuoQ">[1]</a></sup>. This has incredible implications for the ability to deploy neural networks to computationally limited devices,

### Process

To train the network, I made a convolution-less network with four ReLU-activated hidden layers of size 1,000 1,000 500 and 200. Then, I trained the network for 100 epochs to encourage weight values to set themselves to 0 in what is known as the [Leaky ReLU problem](http://cs231n.github.io/neural-networks-1/#actfun). 

#### Weight Dropout
For weight level drop out

#### Unit Dropout
For unit level dropout

### My Results

Due to leaving my laptop on a plane in Montreal, I do not have a working version of these implementations. I have a backup and a few changes in this [repo](https://github.com/geringer/targeted-dropout/blob/master/AdamNet.ipynb), but no successful implementation until I get my laptop back :( For now, I am basing my analysis on the [for.ai paper](https://openreview.net/pdf?id=HkghWScuoQ).

### Analysis (Speculation)

These results are possible by a number of factors which can be mostly summed up by the nature of the ReLU activation curve and by the fashion in which the network was trained. 

#### ReLU
To understand why ReLU is responsible for this behavior, it's important to understand ReLU.
![relu graph](https://miro.medium.com/max/700/1*DfMRHwxY1gyyDmrIAd-gjQ.png)
The ReLU graph above can be broken into a two-part piecewise function. 
##### x < 0
For weights valued at less than 0, the units pass 0 forward. Depending on initialization, this can cause large swaths of the weights to be ignored during training and thus lessen their importance to the network overall. Since the network is interpreting 
ReLU( Sum ( (stricty positive outputs from previous layer) x (negative weight values) ) ) = 0. 
Thus we should expect a not insignifcant number of these units to output zero. For the smallest absolute weight values, we are turning them into 0, so we should only 

##### x > 0
On the other hand, the values greater than zero are output linearly. Likewise, the initialization of these weights can cause parts of these weights to ouput series of strictly positive values creating subnetworks with linear activations. When I started writing this I thought this would imply that the hidden layers could be condensed into the weights of the input layers. But as I was reading, I am presently unsure if this falls into the category of combining-two-affine-functions-into-one. I had originally thought that this would encourage subnetwork dependance and compressions, but alas I am not familiar enough with back prop to say.

#### Hyperparameters
As mentioned earlier, my model was trained for 100 epochs to encourage what is known as the [dying ReLU problem](http://cs231n.github.io/neural-networks-1/#actfun). This is an effect caused by the single-shot the back propogation algoratm has at recovering these units. If they are not recovered, their values stop changing and the back-prop algorithm focuses on other parts of the network. As a result, they fall out of importance and are zeroed out.

Additionally, I did not employ any run-time dropout. Dropout was originally created to prevent subnetwork interdepedance to prevent overfitting<sup><a href="http://jmlr.org/papers/volume15/srivastava14a.old/srivastava14a.pdf">[2]</a></sup>. We want to encourage subnetwork interdependance and dropout later.

### Further Work

When I began this project, I started with a network with biases and built my code around that structure. I did not understand that these biases maybe negatively impacting my model by having biases toward weights that maybe getting deleted. I did not realize this until I started operating on the list of weight matricies and was getting shape errors. In the future, I'd like to explore the effects of targeted dropout on networks not using biases.
